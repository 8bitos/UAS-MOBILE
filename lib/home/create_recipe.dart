import 'package:flutter/material.dart';
import 'package:uas_cookedex/services/recipe_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateRecipePage extends StatefulWidget {
  @override
  _CreateRecipePageState createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final _recipeService = RecipeService();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();
  File? _imageFile;

  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitRecipe() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _recipeService.createRecipe(
        _titleController.text,
        _descriptionController.text,
        _ingredientsController.text,
        _stepsController.text,
        _imageFile,
      );

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Recipe created successfully!'),
      ));

      // After successful creation, clear the form
      _titleController.clear();
      _descriptionController.clear();
      _ingredientsController.clear();
      _stepsController.clear();
      setState(() {
        _imageFile = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to create recipe: $e'),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Recipe'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Field
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Description Field
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Ingredients Section
                const Text(
                  "Ingredients",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _ingredientsController,
                  decoration: const InputDecoration(
                    hintText: "Add Ingredients (comma-separated)",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter ingredients';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Steps Section
                const Text(
                  "Steps",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _stepsController,
                  decoration: const InputDecoration(
                    hintText: "Add Steps (comma-separated)",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the steps';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Add Photo Section
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _imageFile != null
                        ? Image.file(_imageFile!, fit: BoxFit.cover)
                        : const Center(
                            child: Text("Tap to add a photo"),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                // Submit Button
                Center(
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _submitRecipe,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                          ),
                          child: const Text("Create Recipe"),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
