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

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                TextFormField(
                  controller: _ingredientsController,
                  decoration: const InputDecoration(labelText: 'Ingredients'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter ingredients';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _stepsController,
                  decoration: const InputDecoration(labelText: 'Steps'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the steps';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _imageFile == null
                        ? const Text('No image selected')
                        : Image.file(
                            _imageFile!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Pick Image'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _submitRecipe,
                        child: const Text('Create Recipe'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
