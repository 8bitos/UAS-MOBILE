import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';
import '../home/review_dialog.dart';

class RecipeDetailPage extends StatefulWidget {
  final String title;
  final String image;
  final String description;
  final String time;
  final String difficulty;
  final List<String> ingredients;
  final List<String> steps;
  final String category;

  const RecipeDetailPage({
    Key? key,
    required this.title,
    required this.image,
    required this.description,
    required this.time,
    required this.difficulty,
    required this.ingredients,
    required this.steps,
    required this.category,
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
  late String category;

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
    category = widget.category;
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
              image.startsWith('assets/')
                  ? Image.asset(image,
                      height: 200, width: double.infinity, fit: BoxFit.cover)
                  : Image.file(File(image),
                      height: 200, width: double.infinity, fit: BoxFit.cover),
              const SizedBox(height: 16),
              Text(
                title,
                style: GoogleFonts.poppins(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoColumn(Icons.timer, "Time", time),
                  _buildInfoColumn(Icons.star_border, "Difficulty", difficulty),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
                      'category': category,
                    },
                  },
                );

                if (updatedRecipe != null) {
                  final updatedRecipeMap =
                      updatedRecipe as Map<String, dynamic>;
                  setState(() {
                    title = updatedRecipeMap['title'];
                    image = updatedRecipeMap['image'];
                    description = updatedRecipeMap['description'];
                    time =
                        "${updatedRecipeMap['cookTimeHours']}h ${updatedRecipeMap['cookTimeMinutes']}m";
                    difficulty = updatedRecipeMap['difficulty'];
                    ingredients =
                        List<String>.from(updatedRecipeMap['ingredients']);
                    steps = List<String>.from(updatedRecipeMap['steps']);
                    category = updatedRecipeMap['category'];
                  });
                }
              },
            ),
            // Add this to the bottom navigation bar in RecipeDetailPage:
            IconButton(
              icon: const Icon(Icons.rate_review, color: Colors.orangeAccent),
              onPressed: () {
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                final userReviews = userProvider.userReviews
                    .where((review) => review['recipeTitle'] == title)
                    .toList();

                double averageRating = 0;
                if (userReviews.isNotEmpty) {
                  averageRating = userReviews
                          .map((review) => review['rating'] as double)
                          .reduce((a, b) => a + b) /
                      userReviews.length;
                }

                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close bottom sheet
                                // Navigate to reviews page
                                Navigator.pushNamed(
                                  context,
                                  '/reviews',
                                  arguments: {
                                    'recipeTitle': title,
                                    'rating': averageRating,
                                    'reviews': userReviews,
                                  },
                                );
                              },
                              child: Text(
                                'See All Reviews (${userReviews.length})',
                                style: const TextStyle(color: Colors.orange),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const Divider(),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                            top: 8,
                          ),
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Add a review...',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                            onTap: () {
                              Navigator.pop(context); // Close bottom sheet
                              // Navigate to reviews page
                              Navigator.pushNamed(
                                context,
                                '/reviews',
                                arguments: {
                                  'recipeTitle': title,
                                  'rating': averageRating,
                                  'reviews': userReviews,
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
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
}
