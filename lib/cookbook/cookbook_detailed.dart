import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';

class CookbookDetailPage extends StatefulWidget {
  final String title;
  final String description;
  final String photo;
  final String cookbookId;

  const CookbookDetailPage({
    super.key,
    required this.title,
    required this.description,
    required this.photo,
    required this.cookbookId,
  });

  @override
  State<CookbookDetailPage> createState() => _CookbookDetailPageState();
}

class _CookbookDetailPageState extends State<CookbookDetailPage> {
  late String photo;
  late String title;
  late String description;
  late List<Map<String, dynamic>> recipes;
  List<Map<String, dynamic>> selectedRecipes = [];

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final cookbook = userProvider.getCookbookById(widget.cookbookId);
    if (cookbook != null) {
    try {
      photo = cookbook['image'];
      if (photo == null || photo.isEmpty) {
        photo = 'assets/images/default_recipe.jpg';
      }
    } catch (e) {
      photo = 'assets/images/default_recipe.jpg';
    }
    title = cookbook['title'];
    description = cookbook['description'];
    recipes = List<Map<String, dynamic>>.from(cookbook['recipes'] ?? []);
  } else {
    photo = 'assets/images/default_recipe.jpg';
    title = 'Cookbook Not Found';
    description = 'No description available';
    recipes = [];
  }
}


  void _addRecipeToCookbook() {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final availableRecipes = userProvider.userRecipes;
  selectedRecipes.clear();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {  // Renamed setState to setDialogState for clarity
          return AlertDialog(
            title: const Text("Add Recipes to Cookbook"),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: availableRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = availableRecipes[index];
                        final isSelected = selectedRecipes.contains(recipe);
                        
                        return CheckboxListTile(
                          value: isSelected,
                          onChanged: (bool? value) {
                            setDialogState(() {  // Use setDialogState for dialog updates
                              if (value == true) {
                                selectedRecipes.add(recipe);
                              } else {
                                selectedRecipes.remove(recipe);
                              }
                            });
                          },
                          title: Text(recipe['title'] ?? ''),
                         secondary: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              recipe['image'] ?? 'assets/images/default_recipe.jpg',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/default_recipe.jpg',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                ),
                onPressed: () {
                  if (selectedRecipes.isNotEmpty) {
                    userProvider.addRecipeToCookbook(widget.cookbookId, selectedRecipes);
                    
                    // Update the local state immediately
                    setState(() {
                      final updatedCookbook = userProvider.getCookbookById(widget.cookbookId);
                      if (updatedCookbook != null) {
                        recipes = List<Map<String, dynamic>>.from(updatedCookbook['recipes'] ?? []);
                      }
                    });

                    Navigator.pop(context);
                    
                    // Show confirmation
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Recipes added successfully')),
                    );
                  }
                },
                child: const Text("Add Selected"),
              ),
            ],
          );
        },
      );
    },
  );
}

  void _deleteRecipesFromCookbook() {
    selectedRecipes.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Delete Recipes from Cookbook"),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: recipes.length,
                        itemBuilder: (context, index) {
                          final recipe = recipes[index];
                          final isSelected = selectedRecipes.contains(recipe);
                          
                          return CheckboxListTile(
                            value: isSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  selectedRecipes.add(recipe);
                                } else {
                                  selectedRecipes.remove(recipe);
                                }
                              });
                            },
                            title: Text(recipe['title'] ?? ''),
                            secondary: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                recipe['image'] ?? 'assets/images/default_recipe.jpg',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    if (selectedRecipes.isNotEmpty) {
                      final userProvider = Provider.of<UserProvider>(context, listen: false);
                      // Find cookbook index
                      final cookbookIndex = userProvider.userCookbooks
                          .indexWhere((cookbook) => cookbook['id'] == widget.cookbookId);
                      
                      // Remove selected recipes
                      for (var recipe in selectedRecipes) {
                        final recipeIndex = recipes.indexOf(recipe);
                        if (recipeIndex != -1) {
                          userProvider.deleteRecipeFromCookbook(cookbookIndex, recipeIndex);
                        }
                      }
                      
                      setState(() {
                        recipes.removeWhere((recipe) => selectedRecipes.contains(recipe));
                      });
                      Navigator.pop(context);
                      // Refresh the page
                      setState(() {});
                    }
                  },
                  child: const Text("Delete Selected"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.black),
            onPressed: _addRecipeToCookbook,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.black),
            onPressed: _deleteRecipesFromCookbook,
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/cookbook-edit',
                arguments: {
                  'photo': photo,
                  'title': title,
                  'description': description,
                },
              ).then((result) {
                if (result != null) {
                  setState(() {
                    final updatedData = result as Map<String, dynamic>;
                    photo = updatedData['photo'] ?? photo;
                    title = updatedData['title'];
                    description = updatedData['description'];
                  });
                }
              });
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        photo,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/default_recipe.jpg',
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "All Recipes (${recipes.length})",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              recipe["image"] ?? "assets/images/default_recipe.jpg",
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/default_recipe.jpg',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          title: Text(
                            recipe["title"] ?? "No Title",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Row(
                            children: [
                              Text(recipe["time"] ?? "No Time"),
                              const SizedBox(width: 8),
                              const Icon(Icons.circle, size: 6, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(recipe["difficulty"] ?? "No Difficulty"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}