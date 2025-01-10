import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uas_cookedex/home/chatbotspage.dart';
import 'package:uas_cookedex/home/create_recipe.dart';
import 'package:uas_cookedex/services/recipe_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'recipe_detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _recipeService = RecipeService();
  List<dynamic> _recipes = [];
  List<dynamic> _filteredRecipes = [];
  bool _isLoading = false;
  int _selectedIndex = 0;
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadRecipes();
    _loadSortPreference();
  }

  Future<void> _loadSortPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSortOption = prefs.getString('sort_option');
    if (savedSortOption != null) {
      _onSortSelected(savedSortOption);
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'User';
    });
  }

  void _loadRecipes() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final recipes = await _recipeService.getRecipes(page: 0);
      setState(() {
        _isLoading = false;
        _recipes = recipes;
        _filteredRecipes = recipes;
      });

      if (_currentSortOption.isNotEmpty) {
        _onSortSelected(_currentSortOption);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load recipes: $e'),
      ));
    }
  }

  Future<void> _refreshRecipes() async {
    setState(() {
      _recipes.clear();
    });
    _loadRecipes();
    if (_filteredRecipes.isNotEmpty) {
      _onSortSelected(_currentSortOption);
    }
  }

  String _currentSortOption = 'Latest-Newest';

  void _onSearchChanged(String query) {
    setState(() {
      _filteredRecipes = _recipes
          .where((recipe) =>
              recipe['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onSearchButtonPressed() {
    setState(() {
      _isSearching = !_isSearching;
    });
    if (!_isSearching) {
      _searchController.clear();
      _filteredRecipes = _recipes;
    }
  }

  Future<void> _onSortSelected(String option) async {
    setState(() {
      _currentSortOption = option;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('sort_option', option);

    switch (option) {
      case 'A-Z':
        _filteredRecipes.sort((a, b) =>
            a['title'].toLowerCase().compareTo(b['title'].toLowerCase()));
        break;
      case 'Z-A':
        _filteredRecipes.sort((a, b) =>
            b['title'].toLowerCase().compareTo(a['title'].toLowerCase()));
        break;
      case 'Latest-Newest':
        _filteredRecipes.sort((a, b) => DateTime.parse(a['created_at'])
            .compareTo(DateTime.parse(b['created_at'])));
        break;
      case 'Newest-Latest':
        _filteredRecipes.sort((a, b) => DateTime.parse(b['created_at'])
            .compareTo(DateTime.parse(a['created_at'])));
        break;
      case 'Most-Liked':
        _filteredRecipes
            .sort((a, b) => b['likes_count'].compareTo(a['likes_count']));
        break;
      case 'Least-Liked':
        _filteredRecipes
            .sort((a, b) => a['likes_count'].compareTo(b['likes_count']));
        break;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/account');
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        _userName != null && _userName!.isNotEmpty
                            ? _userName![0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _userName ?? "Hi User",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        "What are you cooking today?",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      _isSearching ? Icons.cancel : Icons.search,
                      color: Colors.black,
                    ),
                    iconSize: 28,
                    onPressed: _onSearchButtonPressed,
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.sort, color: Colors.black),
                    onSelected: _onSortSelected,
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                          value: 'A-Z', child: Text('Sort A-Z')),
                      const PopupMenuItem(
                          value: 'Z-A', child: Text('Sort Z-A')),
                      const PopupMenuItem(
                          value: 'Latest-Newest',
                          child: Text('Sort Latest-Newest')),
                      const PopupMenuItem(
                          value: 'Newest-Latest',
                          child: Text('Sort Newest-Latest')),
                      const PopupMenuItem(
                          value: 'Most-Liked', child: Text('Sort Most Liked')),
                      const PopupMenuItem(
                          value: 'Least-Liked',
                          child: Text('Sort Least Liked')),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: _isLoading && _recipes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshRecipes,
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  // Home Page
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_isSearching)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: TextField(
                                controller: _searchController,
                                onChanged: _onSearchChanged,
                                decoration: const InputDecoration(
                                  labelText: 'Search recipes...',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.search),
                                ),
                              ),
                            ),
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
                          ..._filteredRecipes.map((recipe) {
                            final bool isLiked = recipe['is_liked'] ?? false;
                            final String createdAt =
                                recipe['created_at'] != null
                                    ? DateFormat('d MMMM yyyy').format(
                                        DateTime.parse(recipe['created_at'])
                                            .toLocal())
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
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
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
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                  // Chatbot Page
                  ChatbotsPage(),
                ],
              ),
            ),
      floatingActionButton: _selectedIndex == 0 // Hide button on chatbot page
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateRecipePage()),
                ).then((reload) {
                  if (reload == true) {
                    setState(() {
                      _loadRecipes();
                    });
                  }
                });
              },
              backgroundColor: Colors.orangeAccent,
              child: const Icon(Icons.add),
            )
          : null,
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
            icon: Icon(Icons.chat, size: 28),
            label: "",
          ),
        ],
      ),
    );
  }
}
