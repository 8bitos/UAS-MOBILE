import 'package:flutter/material.dart';
import 'package:uas_cookedex/provider/user_provider.dart';
import 'package:provider/provider.dart';

class RecipeSearchDelegate extends SearchDelegate {
  final List<String> recentSearches;
  final List<Map<String, String>> lastSeenRecipes;

  RecipeSearchDelegate({
    required this.recentSearches,
    required this.lastSeenRecipes,
  });

  // Leading icon in the AppBar
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () {
        close(context, null); // Close the search delegate
      },
    );
  }

  // Action icons in the AppBar
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.black),
        onPressed: () {
          query = ''; // Clear the search query
          showSuggestions(context); // Show suggestions after clearing
        },
      ),
    ];
  }

  // Suggestions view (when there's no search query or the query is cleared)
  @override
Widget buildSuggestions(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Searches Section
          const Text(
            "Recent Search",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (recentSearches.isEmpty)
            const Text(
              "No recent searches yet.",
              style: TextStyle(color: Colors.grey),
            )
          else
            Column(
              children: recentSearches.map((search) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    search,
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      recentSearches.remove(search); // Remove recent search
                      showSuggestions(context); // Refresh suggestions
                    },
                  ),
                  onTap: () {
                    query = search; // Use the tapped search term as the query
                    showResults(context); // Show results for this query
                  },
                );
              }).toList(),
            ),
          const SizedBox(height: 24),

          // Last Seen Recipes Section
          const Text(
            "Last Seen",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: lastSeenRecipes.map((recipe) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    recipe["image"]!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  recipe["title"]!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Row(
                  children: [
                    Text(recipe["time"]!),
                    const SizedBox(width: 8),
                    const Icon(Icons.circle, size: 6, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(recipe["difficulty"]!),
                  ],
                ),
                onTap: () {
                  close(context, null); // Close the search delegate
                  // Navigate to recipe detail page with the correct data
                  Navigator.pushNamed(
                    context,
                    '/recipe-detail',
                    arguments: {
                      "title": recipe["title"], // Dynamic title
                      "image": recipe["image"], // Dynamic image
                      "description": recipe["description"], // Dynamic description
                      "time": recipe["time"], // Dynamic time
                      "difficulty": recipe["difficulty"], // Dynamic difficulty
                      "likes": recipe["likes"] ?? 0, // Default to 0 if null
                      "reviews": recipe["reviews"] ?? 0, // Default to 0 if null
                      "ingredients": recipe["ingredients"] ?? [], // Pass ingredients
                      "steps": recipe["steps"] ?? [], // Pass steps
                    },
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    ),
  );
}


  // Search Results (When User Presses Search)
  @override
  Widget buildResults(BuildContext context) {
    final results = recentSearches
        .where((recipe) => recipe.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // Add the query to recent searches if it's not already present
    if (query.isNotEmpty && !recentSearches.contains(query)) {
      recentSearches.insert(0, query); // Add to the top of the list
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]),
          onTap: () {
            close(context, null); // Close search delegate
            // Navigate to recipe detail page
            Navigator.pushNamed(context, '/recipe-detail', arguments: results[index]);
          },
        );
      },
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Define recent searches and last seen recipes
  final List<String> _recentSearches = ["Sayur", "Ayam", "Gulai"];
  final List<Map<String, String>> _lastSeenRecipes = [
    {
      "image": "assets/images/recipe1.jpg",
      "title": "Resep Ayam Kuah Santan Pedas Lezat",
      "time": "40 min",
      "difficulty": "Easy",
    },
    {
      "image": "assets/images/recipe2.jpg",
      "title": "Sup Makaroni Daging Ayam Kampung",
      "time": "45 min",
      "difficulty": "Medium",
    },
    {
      "image": "assets/images/recipe3.jpg",
      "title": "Resep Ayam Geprek Jogja",
      "time": "30 min",
      "difficulty": "Easy",
    },
  ];
  
  // Function to handle bottom navigation bar taps
  void _onItemTapped(int index) {
    if (index == 1) {
      // If Search is tapped, show the search overlay
      showSearch(
        context: context,
        delegate: RecipeSearchDelegate(
          recentSearches: _recentSearches, // Pass recent searches
          lastSeenRecipes: _lastSeenRecipes, // Pass last seen recipes
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }
  
  void _addCookbook(BuildContext context) {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  String? title;
  String? description;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Add Cookbook"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Title"),
              onChanged: (value) {
                title = value;
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Description"),
              onChanged: (value) {
                description = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (title != null && description != null) {
                // Add to userProvider's userCookbooks list with an ID
                userProvider.addCookbook({
                  "id": DateTime.now().toString(), // Add unique ID
                  "image": "assets/cookbook/cookbook.jpg",
                  "title": title!,
                  "description": description!,
                  "recipes": [], // Initialize empty recipes array
                  "author": userProvider.name,
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text("Add"),
          ),
        ],
      );
    },
  );
}

 void _onFabClick(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Opsi Add Cookbook
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text("Add Cookbook"),
            onTap: () {
              Navigator.of(context).pop(); // Tutup bottom sheet
              _addCookbook(context); // Panggil fungsi untuk tambah cookbook
            },
          ),
          // Opsi Add Recipe
          ListTile(
            leading: const Icon(Icons.receipt),
            title: const Text("Add Recipe"),
            onTap: () {
              Navigator.of(context).pop(); // Tutup bottom sheet
              Navigator.pushNamed(context, '/add-recipe'); // Navigasi ke halaman tambah resep
            },
          ),
        ],
      );
    },
  );
}

 

  Widget _buildCategoryItem(String imagePath, String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  
    @override
    Widget build(BuildContext context) {
      final userProvider = Provider.of<UserProvider>(context);
      final recipes = userProvider.userRecipes; 
      final cookbooks = userProvider.userCookbooks; 

    
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
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/profile.png'),
                    radius: 25,
                  ),
                ),
                const SizedBox(width: 16),
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Hi ${userProvider.name}", // Dynamically display the user's name
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
                    );
                  },
                ),

                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: Colors.black),
                  iconSize: 28,
                  onPressed: () {
                    Navigator.pushNamed(context, '/notification');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ),

      // Properly closing SizedBo
      backgroundColor: Colors.white,
body: SingleChildScrollView(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: 300,
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            final cookbooks = userProvider.userCookbooks;
            return cookbooks.isEmpty 
            ? const Center(
                child: Text(
                  "No cookbooks yet. Create one!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              )
            : PageView.builder(
              controller: PageController(viewportFraction: 0.9),
              physics: const BouncingScrollPhysics(),
              itemCount: cookbooks.length,
              itemBuilder: (context, index) {
                final cookbook = cookbooks[index];
                return GestureDetector(
                  onTap: () {
                    // Double check that ID exists before navigating
                    if (cookbook['id'] != null) {
                      Navigator.pushNamed(
                        context,
                        '/cookbook-detail',
                        arguments: {
                          'title': cookbook['title'] ?? 'Untitled',
                          'description': cookbook['description'] ?? 'No description',
                          'photo': cookbook['image'] ?? "assets/images/cookbook1.jpg",
                          'cookbookId': cookbook['id'],
                        },
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: Image.asset(
                                cookbook["image"] ?? "assets/images/cookbook1.jpg",
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cookbook["title"] ?? "No Title",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  cookbook["description"] ?? "No Description",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.book_outlined,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "${(cookbook['recipes'] as List?)?.length ?? 0} Recipes",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "By ${cookbook['author'] ?? 'Unknown'}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),

            
            // Community Recipes Section
            Padding(
              padding: const EdgeInsets.only(top: 43.0, left: 16.0, right: 16.0),
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
                  const SizedBox(height: 16),
                  ...recipes.map((communityRecipe) {
                    // Find the corresponding recipe in the full recipes list by matching titles
                    final matchingRecipe = recipes.firstWhere(
                      (recipe) => recipe['title'] == communityRecipe['title'], // Match by title
                      orElse: () => {}, // Fallback in case no match is found
                    );

                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/recipe-detail',
                          arguments: matchingRecipe, // Pass the matched recipe
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              communityRecipe["image"]!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    communityRecipe["title"]!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        "by ${communityRecipe["author"]}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        "${communityRecipe["likes"]} Likes",
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/community-recipes');
                    },
                    child: const Text(
                      "See All Recipes by Community",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Category Section
            Padding(
              padding: const EdgeInsets.only(top: 43.0, left: 24.0, right: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Category",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 80.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildCategoryItem('assets/images/category1.jpg', 'Seasonal'),
                          _buildCategoryItem('assets/images/category2.jpg', 'Cakes'),
                          _buildCategoryItem('assets/images/category3.jpg', 'Everyday'),
                          _buildCategoryItem('assets/images/category4.jpg', 'Drinks'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _onFabClick(context),
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

