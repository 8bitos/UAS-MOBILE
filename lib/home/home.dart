import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting
import 'package:uas_cookedex/home/create_recipe.dart';
import 'package:uas_cookedex/services/recipe_service.dart';
import 'package:uas_cookedex/services/auth_service.dart';
import 'recipe_detail_page.dart'; // Import the detail page

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _recipeService = RecipeService();
  List<dynamic> _recipes = [];
  bool _isLoading = false;
  int _selectedIndex = 0;
  int _currentPage = 1; // Track current page for pagination
  bool _allRecipesLoaded = false; // Flag to check if all recipes are loaded
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadRecipes(page: _currentPage);

    // Set up scroll controller to detect when the user reaches the bottom
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_allRecipesLoaded) {
        _loadRecipes(
            page:
                _currentPage + 1); // Load next page when scrolled to the bottom
      }
    });
  }

  // Function to load recipes from the API
  void _loadRecipes({int page = 1}) async {
    if (_isLoading || _allRecipesLoaded)
      return; // Prevent multiple API calls and avoid loading if all data is loaded
    setState(() {
      _isLoading = true;
    });
    final recipes = await _recipeService.getRecipes(page: page);

    if (recipes.isNotEmpty) {
      setState(() {
        _isLoading = false;
        _recipes.addAll(recipes); // Add new recipes to the list
        _currentPage = page; // Update the current page
        if (recipes.length < 10) {
          // If fewer than 10 recipes are loaded, mark it as the last page
          _allRecipesLoaded = true;
        }
      });
    } else {
      setState(() {
        _isLoading = false;
        _allRecipesLoaded =
            true; // Mark all recipes loaded if no data is returned
      });
    }
  }

  // Function to handle pull-to-refresh
  Future<void> _refreshRecipes() async {
    setState(() {
      _recipes.clear(); // Clear current list of recipes
      _currentPage = 1; // Reset page to 1
      _allRecipesLoaded = false; // Reset the flag for reloading
    });
    _loadRecipes(page: _currentPage); // Reload the first page of recipes
  }

  // Function to toggle like status of a recipe
  Future<void> _toggleLike(int recipeId, bool isLiked, int index) async {
    try {
      if (isLiked) {
        await _recipeService.unlikeRecipe(recipeId);
        setState(() {
          _recipes[index]['is_liked'] = false;
          _recipes[index]['likes_count'] -= 1;
        });
      } else {
        await _recipeService.likeRecipe(recipeId);
        setState(() {
          _recipes[index]['is_liked'] = true;
          _recipes[index]['likes_count'] += 1;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to toggle like: $e'),
      ));
    }
  }

  // Function to toggle save status of a recipe
  Future<void> _toggleSave(int recipeId, bool isSaved, int index) async {
    try {
      if (isSaved) {
        await _recipeService.unsaveRecipe(recipeId);
        setState(() {
          _recipes[index]['is_saved'] = false;
        });
      } else {
        await _recipeService.saveRecipe(recipeId);
        setState(() {
          _recipes[index]['is_saved'] = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to toggle save: $e'),
      ));
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: _isLoading && _recipes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshRecipes, // Add pull-to-refresh functionality
              child: SingleChildScrollView(
                controller: _scrollController, // Add scroll controller
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Featured Community Recipes",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Get lots of recipe inspiration from the community",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      ..._recipes.map((recipe) {
                        final bool isLiked = recipe['is_liked'] ?? false;
                        final bool isSaved = recipe['is_saved'] ?? false;
                        final String createdAt = recipe['created_at'] != null
                            ? DateFormat('d MMMM yyyy').format(
                                DateTime.parse(recipe['created_at']).toLocal())
                            : 'Unknown date';

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeDetailPage(
                                  recipe: recipe,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                recipe['image_url'] != null
                                    ? Image.network(
                                        recipe['image_url'],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 200,
                                      )
                                    : const SizedBox.shrink(),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        recipe['title'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text(
                                            'by ${recipe['user']['name']}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                              '${recipe['likes_count']} Likes'),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Created on: $createdAt',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      _isLoading
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateRecipePage()),
          );
        },
        backgroundColor: Colors.orangeAccent,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 28),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 28),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, size: 28),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month, size: 28),
            label: "",
          ),
        ],
      ),
    );
  }
}
