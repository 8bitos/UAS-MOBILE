import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import ImagePicker
import 'dart:io'; // Import for handling File operations

class EditRecipePage extends StatefulWidget {
  final Map<String, dynamic> recipe;

  const EditRecipePage({Key? key, required this.recipe}) : super(key: key);

  @override
  _EditRecipePageState createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController sourceController;
  late List<String> ingredients;
  late List<String> steps;
  late String difficulty;
  late String serve;
  late String cookTimeMinutes;
  late String cookTimeHours;
  bool publishToCommunity = false;
  File? _recipeImage; // To store the selected image

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the existing recipe data
    titleController = TextEditingController(text: widget.recipe['title']);
    descriptionController =
        TextEditingController(text: widget.recipe['description']);
    sourceController = TextEditingController(text: widget.recipe['source']);
    ingredients = List<String>.from(widget.recipe['ingredients'] ?? []);
    steps = List<String>.from(widget.recipe['steps'] ?? []);
    difficulty = widget.recipe['difficulty'] ?? 'Easy';
    serve = widget.recipe['serve'] ?? '1 Person';
    cookTimeMinutes = widget.recipe['cookTimeMinutes'] ?? '0';
    cookTimeHours = widget.recipe['cookTimeHours'] ?? '0';
    publishToCommunity = widget.recipe['publishToCommunity'] ?? false;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _recipeImage = File(pickedImage.path); // Update the recipe image
      });
    }
  }

  void _addIngredient(String ingredient) {
    if (ingredient.isNotEmpty) {
      setState(() {
        ingredients.add(ingredient);
      });
    }
  }

  void _addStep(String step) {
    if (step.isNotEmpty) {
      setState(() {
        steps.add(step);
      });
    }
  }

  void _deleteIngredient(int index) {
    setState(() {
      ingredients.removeAt(index);
    });
  }

  void _deleteStep(int index) {
    setState(() {
      steps.removeAt(index);
    });
  }

  void _saveRecipe() {
    // Collect the updated data
    final updatedRecipe = {
      'title': titleController.text,
      'description': descriptionController.text,
      'source': sourceController.text,
      'ingredients': ingredients,
      'steps': steps,
      'difficulty': difficulty,
      'serve': serve,
      'cookTimeMinutes': cookTimeMinutes,
      'cookTimeHours': cookTimeHours,
      'publishToCommunity': publishToCommunity,
      'image': _recipeImage?.path ?? widget.recipe['image'], // Save selected image path or fallback
    };

    // Pass the updated recipe back to the previous screen
    Navigator.pop(context, updatedRecipe);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Recipe Form",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: _saveRecipe,
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.orangeAccent),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Intro Section
              const Text("Intro", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // Recipe Image
              GestureDetector(
                onTap: _pickImage,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _recipeImage != null
                          ? Image.file(
                              _recipeImage!,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              widget.recipe['image'] ?? 'assets/images/default_recipe.jpg',
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                      const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 48,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: "Cook Time (minutes)"),
                      onChanged: (value) {
                        cookTimeMinutes = value;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: "Cook Time (hours)"),
                      onChanged: (value) {
                        cookTimeHours = value;
                      },
                    ),
                  ),
                ],
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
                    .map(
                      (entry) => ListTile(
                        title: Text(entry.value),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteIngredient(entry.key),
                        ),
                      ),
                    )
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
              const Text("Steps", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Column(
                children: steps
                    .asMap()
                    .entries
                    .map(
                      (entry) => ListTile(
                        title: Text(entry.value),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteStep(entry.key),
                        ),
                      ),
                    )
                    .toList(),
              ),
              TextField(
                onSubmitted: _addStep,
                decoration: const InputDecoration(
                  hintText: "Add Step",
                  suffixIcon: Icon(Icons.add, color: Colors.orangeAccent),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
