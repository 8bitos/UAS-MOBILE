import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditRecipePage extends StatefulWidget {
  final Map<String, dynamic> recipe;

  const EditRecipePage({super.key, required this.recipe});

  @override
  _EditRecipePageState createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late List<String> ingredients;
  late List<String> steps;
  late int difficulty; // Use integer for star rating
  late String cookTimeMinutes;
  late String cookTimeHours;
  File? _recipeImage;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.recipe['title']);
    descriptionController = TextEditingController(text: widget.recipe['description']);
    ingredients = List<String>.from(widget.recipe['ingredients'] ?? []);
    steps = List<String>.from(widget.recipe['steps'] ?? []);

    // Map difficulty string to an integer
    difficulty = widget.recipe['difficulty'] == 'Easy'
        ? 1
        : widget.recipe['difficulty'] == 'Medium'
            ? 2
            : 3; // Default to 3 (Hard) if no match

    cookTimeMinutes = widget.recipe['cookTimeMinutes'] ?? '0';
    cookTimeHours = widget.recipe['cookTimeHours'] ?? '0';
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _recipeImage = File(pickedImage.path);
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

  void _saveRecipe() {
    final updatedRecipe = {
      'title': titleController.text,
      'description': descriptionController.text,
      'ingredients': ingredients,
      'steps': steps,
      'difficulty': difficulty == 1
          ? 'Easy'
          : difficulty == 2
              ? 'Medium'
              : 'Hard', // Map back to string
      'cookTimeMinutes': cookTimeMinutes,
      'cookTimeHours': cookTimeHours,
      'image': _recipeImage?.path ?? widget.recipe['image'], // Save selected image path or fallback
    };
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
          "Edit Recipe",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _recipeImage != null
                      ? Image.file(
                          _recipeImage!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          widget.recipe['image'] ?? 'assets/images/default_recipe.jpg',
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                  const Icon(Icons.camera_alt, size: 48, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Title
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 8),
            // Description
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16),
            // Cooking Time
              const Text('Cooking Time:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Hours',
                        suffixText: 'h',
                      ),
                      onChanged: (value) => setState(() => cookTimeHours = value),
                      controller: TextEditingController(text: cookTimeHours),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Minutes',
                        suffixText: 'm',
                      ),
                      onChanged: (value) => setState(() => cookTimeMinutes = value),
                      controller: TextEditingController(text: cookTimeMinutes),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            // Difficulty
            const Text('Difficulty:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Row(
              children: List.generate(3, (index) {
                return IconButton(
                  icon: Icon(
                    index < difficulty ? Icons.star : Icons.star_border,
                    color: Colors.orangeAccent,
                  ),
                  onPressed: () {
                    setState(() {
                      difficulty = index + 1; // Set difficulty based on star selected
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 16),
            // Ingredients
            const Text('Ingredients', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Column(
              children: ingredients
                  .asMap()
                  .entries
                  .map(
                    (entry) => ListTile(
                      title: Text(entry.value),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => setState(() => ingredients.removeAt(entry.key)),
                      ),
                    ),
                  )
                  .toList(),
            ),
            TextField(
              onSubmitted: _addIngredient,
              decoration: const InputDecoration(hintText: 'Add Ingredient'),
            ),
            const SizedBox(height: 16),
            // Steps
            const Text('Steps', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Column(
              children: steps
                  .asMap()
                  .entries
                  .map(
                    (entry) => ListTile(
                      title: Text(entry.value),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => setState(() => steps.removeAt(entry.key)),
                      ),
                    ),
                  )
                  .toList(),
            ),
            TextField(
              onSubmitted: _addStep,
              decoration: const InputDecoration(hintText: 'Add Step'),
            ),
          ],
        ),
      ),
    );
  }
}
