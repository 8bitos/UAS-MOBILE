import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  String? title;
  String? description;
  String? cookTimeMinutes;
  String? cookTimeHours;
  List<String> ingredients = [];
  List<String> steps = [];
  String selectedCategory = 'Everyday';
  File? _selectedImage; // To store the selected image file

  final ImagePicker _picker = ImagePicker();

  // Function to pick an image from the gallery
  void _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // Store the selected image file
      });
    }
  }

  // Add ingredient to the list
  void _addIngredient(String ingredient) {
    if (ingredient.isNotEmpty) {
      setState(() {
        ingredients.add(ingredient);
      });
    }
  }

  // Add step to the list
  void _addStep(String step) {
    if (step.isNotEmpty) {
      setState(() {
        steps.add(step);
      });
    }
  }

  // Submit the recipe
  void _submitRecipe() {
    if (_formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final newRecipe = {
        "image": _selectedImage != null
            ? _selectedImage!.path
            : "assets/images/default_recipe.jpg",
        "title": title!,
        "description": description!,
        "time": "${cookTimeHours ?? '0'}h ${cookTimeMinutes ?? '0'}m",
        "ingredients": ingredients,
        "steps": steps,
        "difficulty": "Medium",
        "author": userProvider.name,
        "category": selectedCategory,
      };

      // Add the new recipe
      userProvider.addRecipe(newRecipe);

      // Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe added successfully')),
      );

      // Navigate back
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Recipe"),
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
                  decoration: const InputDecoration(labelText: "Title"),
                  onChanged: (value) => title = value,
                  validator: (value) => value == null || value.isEmpty
                      ? "Title is required"
                      : null,
                ),
                const SizedBox(height: 16),
                // Description Field
                TextFormField(
                  decoration: const InputDecoration(labelText: "Description"),
                  onChanged: (value) => description = value,
                  validator: (value) => value == null || value.isEmpty
                      ? "Description is required"
                      : null,
                ),
                const SizedBox(height: 16),
                // Cook Time Fields
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: "Cook Time (Minutes)"),
                        onChanged: (value) => cookTimeMinutes = value,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: "Cook Time (Hours)"),
                        onChanged: (value) => cookTimeHours = value,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Add Photo Button
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _selectedImage != null
                        ? Image.file(_selectedImage!, fit: BoxFit.cover)
                        : const Center(
                            child: Text("Tap to add a photo"),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                // Ingredients Section
                const Text("Ingredients",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Column(
                  children: ingredients
                      .asMap()
                      .entries
                      .map((entry) => ListTile(
                            title: Text(entry.value),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  ingredients.removeAt(entry.key);
                                });
                              },
                            ),
                          ))
                      .toList(),
                ),
                TextField(
                  onSubmitted: _addIngredient,
                  decoration: const InputDecoration(
                    hintText: "Add Ingredient",
                    suffixIcon: Icon(Icons.add, color: Colors.orangeAccent),
                  ),
                ),
                const SizedBox(height: 16),
                // Steps Section
                const Text("Steps",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Column(
                  children: steps
                      .asMap()
                      .entries
                      .map((entry) => ListTile(
                            title: Text(entry.value),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  steps.removeAt(entry.key);
                                });
                              },
                            ),
                          ))
                      .toList(),
                ),
                TextField(
                  onSubmitted: _addStep,
                  decoration: const InputDecoration(
                    hintText: "Add Step",
                    suffixIcon: Icon(Icons.add, color: Colors.orangeAccent),
                  ),
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Category'),
                  value: selectedCategory,
                  items: const [
                    DropdownMenuItem(
                        value: 'Seasonal', child: Text('Seasonal')),
                    DropdownMenuItem(value: 'Cakes', child: Text('Cakes')),
                    DropdownMenuItem(
                        value: 'Everyday', child: Text('Everyday')),
                    DropdownMenuItem(value: 'Drinks', child: Text('Drinks')),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: _submitRecipe,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                    ),
                    child: const Text("Add Recipe"),
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
