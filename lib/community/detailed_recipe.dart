import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeDetailPage extends StatefulWidget {
  final String title;
  final String image;
  final String description;
  final String time;
  final String difficulty;
  final List<String> ingredients;
  final List<String> steps;

  const RecipeDetailPage({
    Key? key,
    required this.title,
    required this.image,
    required this.description,
    required this.time,
    required this.difficulty,
    required this.ingredients,
    required this.steps,
  }) : super(key: key);

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  late String title;
  late String image;
  late String description;
  late String time;
  late String difficulty;
  late List<String> ingredients;
  late List<String> steps;

  @override
  void initState() {
    super.initState();
    // Initialize the fields with the passed values
    title = widget.title;
    image = widget.image;
    description = widget.description;
    time = widget.time;
    difficulty = widget.difficulty;
    ingredients = List<String>.from(widget.ingredients);
    steps = List<String>.from(widget.steps);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe Image
              image.startsWith('assets/')
                  ? Image.asset(image, height: 200, width: double.infinity, fit: BoxFit.cover)
                  : Image.file(File(image), height: 200, width: double.infinity, fit: BoxFit.cover),
              const SizedBox(height: 16),
              // Title
              Text(
                title,
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Description
              Text(
                description,
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 16),
              // Cooking Time & Difficulty
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoColumn(Icons.timer, "Time", time),
                  _buildInfoColumn(Icons.star_border, "Difficulty", difficulty),
                ],
              ),
              const SizedBox(height: 16),
              // Ingredients
              const Text(
                "Ingredients",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...ingredients.map((ingredient) {
                return Row(
                  children: [
                    const Icon(Icons.check, color: Colors.orangeAccent),
                    const SizedBox(width: 8),
                    Text(
                      ingredient,
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                  ],
                );
              }).toList(),
              const SizedBox(height: 16),
              // Steps
              const Text(
                "Steps",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...steps.asMap().entries.map((entry) {
                final index = entry.key + 1;
                final step = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "$index. $step",
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
           IconButton(
          icon: const Icon(Icons.edit, color: Colors.orangeAccent),
          onPressed: () async {
            final updatedRecipe = await Navigator.pushNamed(
              context,
              '/edit-recipe',
              arguments: {
                'recipe': {
                  'title': title,
                  'image': image,
                  'description': description,
                  'time': time,
                  'difficulty': difficulty,
                  'ingredients': ingredients,
                  'steps': steps,
                },
              },
            );

            if (updatedRecipe != null) {
              final updatedRecipeMap = updatedRecipe as Map<String, dynamic>;
              setState(() {
                title = updatedRecipeMap['title'];
                image = updatedRecipeMap['image'];
                description = updatedRecipeMap['description'];
                time = "${updatedRecipeMap['cookTimeHours']}h ${updatedRecipeMap['cookTimeMinutes']}m";
                difficulty = updatedRecipeMap['difficulty'];
                ingredients = List<String>.from(updatedRecipeMap['ingredients']);
                steps = List<String>.from(updatedRecipeMap['steps']);
              });
            }
          },
        ),
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.orangeAccent),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/grocery-list',
                  arguments: ingredients.map((ingredient) {
                    return {'name': ingredient, 'checked': false};
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.orangeAccent),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
