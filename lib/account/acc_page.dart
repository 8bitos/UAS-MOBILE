import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';
import 'package:uas_cookedex/default_recipe.dart'; // Import untuk dummy recipes
import 'package:uas_cookedex/dummy_cookbook.dart'; // Import untuk dummy cookbooks
import 'dart:io';

List<Map<String, dynamic>> userCookbooks = [];
List<Map<String, dynamic>> userRecipes = [];

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String profileImage = "assets/images/profile.png";
  String coverImage = "assets/images/profile_cover.png";

  String _selectedFilter = "All"; // Default filter: show all

   void _showDeleteDialog(BuildContext context, Map<String, dynamic> post, {required bool isCookbook}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Delete ${isCookbook ? "Cookbook" : "Recipe"}"),
        content: Text("Are you sure you want to delete this ${isCookbook ? "cookbook" : "recipe"}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              if (isCookbook) {
                userProvider.deleteCookbook(post);
              } else {
                userProvider.deleteRecipe(post);
              }
              
              Navigator.of(context).pop();
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${post["title"]} has been deleted.'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      );
    },
  );
}
  
  // fungsi nambah kukbuk
  void _addCookbook(Map<String, dynamic> newCookbook) {
    setState(() {
      userCookbooks.add(newCookbook); // Tambah ke daftar cookbooks user
    });
  }

  // funksi nambah resep bru
  void _addRecipe(Map<String, dynamic> newRecipe) {
    setState(() {
      userRecipes.add(newRecipe); // Tambah ke daftar recipes user
    });
  }

  // Funksi dilit kukbuk
  void deleteCookbook(BuildContext context, Map<String, dynamic> cookbook) {
  setState(() {
    userCookbooks.remove(cookbook); 
  });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${cookbook["title"]} has been deleted.'),
          duration: const Duration(seconds: 2),
        ),
      );
    }

  //FUnksi dilit resep
  void deleteRecipe(BuildContext context, Map<String, dynamic> recipe) {
    setState(() {
      userRecipes.remove(recipe); 
    });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${recipe["title"]} has been deleted.'),
          duration: const Duration(seconds: 2),
        ),
      );
    }

  // Function to edit profile
  void _editProfile() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    Navigator.pushNamed(
      context,
      '/edit-profile',
      arguments: {
        'name': userProvider.name,
        'bio': userProvider.bio,
        'profileImage': profileImage,
        'coverImage': coverImage,
      },
    ).then((updatedData) {
      if (updatedData != null && updatedData is Map<String, dynamic>) {
        userProvider.updateName(updatedData['name']);
        userProvider.updateBio(updatedData['bio']);
        setState(() {
          profileImage = updatedData['profileImage'];
          coverImage = updatedData['coverImage'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    // post cmpur "All"
     final combinedPosts = [
  ...Provider.of<UserProvider>(context).userCookbooks,
  ...Provider.of<UserProvider>(context).userRecipes
];
      ListView.builder(
        itemCount: combinedPosts.length,
        itemBuilder: (context, index) {
          final post = combinedPosts[index];
          return Card(
            child: ListTile(
              title: Text(post['title']),
              subtitle: Text(post.containsKey('author')
                  ? "Cookbook: ${post['description']}"
                  : "Recipe: ${post['description']}"),
            ),
          );
        },
      );

    // Filtered posts based on dropdown selection
    final filteredPosts = _selectedFilter == "All"
    ? [...userProvider.userCookbooks, ...userProvider.userRecipes]
    : _selectedFilter == "Cookbooks"
        ? userProvider.userCookbooks
        : userProvider.userRecipes;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Account",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/acc-setting');
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Profile Header
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Cover Image
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: coverImage.contains('assets/images')
                        ? AssetImage(coverImage) as ImageProvider
                        : FileImage(File(coverImage)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Profile Picture
              Positioned(
                bottom: -55,
                left: MediaQuery.of(context).size.width / 2 - 50,
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: profileImage.contains('assets/images')
                        ? AssetImage(profileImage) as ImageProvider
                        : FileImage(File(profileImage)),
                  ),
                ),
              ),
              // Edit Profile Button
              Positioned(
                bottom: 5,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.orangeAccent,
                      width: 2,
                    ),
                  ),
                  child: IconButton(
                    onPressed: _editProfile,
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.orangeAccent,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          // User Info Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    return Column(
                      children: [
                        Text(
                          userProvider.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userProvider.bio,
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // TabBar
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const TabBar(
                    indicatorColor: Colors.orangeAccent,
                    labelColor: Colors.orangeAccent,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(child: Text("Posts")),
                      Tab(child: Text("Reviews")),
                      Tab(child: Text("Liked Recipes")),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Posts Tab
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: DropdownButton<String>(
                                value: _selectedFilter,
                                isExpanded: true,
                                items: const [
                                  DropdownMenuItem(value: "All", child: Text("All Posts")),
                                  DropdownMenuItem(value: "Cookbooks", child: Text("Cookbooks")),
                                  DropdownMenuItem(value: "Recipes", child: Text("Recipes")),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedFilter = value!;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: filteredPosts.length,
                                itemBuilder: (context, index) {
                                  final post = filteredPosts[index];
                                  return _buildPostCard(post);
                                },
                              ),
                            ),
                          ],
                        ),
                        // Reviews Tab
                        _buildReviewsTab(),
                        // Liked Recipes Tab
                        _buildLikedRecipesTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildUserReview(
          recipeTitle: "Resep Ikan Bakar Bumbu Kecap",
          reviewText: "This recipe was amazing! Flavorful and easy to make.",
          rating: 4.5,
          image: 'assets/images/recipe_user1.jpg',
        ),
        const SizedBox(height: 16),
        _buildUserReview(
          recipeTitle: "Resep Soto Ayam Segar",
          reviewText: "The broth was so refreshing and flavorful!",
          rating: 4.0,
          image: 'assets/images/recipe_user2.jpg',
        ),
      ],
    );
  }

  Widget _buildLikedRecipesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildRecipeCard(
          image: 'assets/images/recipe_user1.jpg',
          title: "Resep Mie Ayam Jamur",
          likes: 250,
          reviews: 120,
        ),
        const SizedBox(height: 16),
        _buildRecipeCard(
          image: 'assets/images/recipe_user2.jpg',
          title: "Resep Nasi Goreng Jawa",
          likes: 320,
          reviews: 190,
        ),
      ],
    );
  }

 Widget _buildPostCard(dynamic post) {
  final bool isCookbook = post.containsKey('author') && post.containsKey('recipes');
  
  if (isCookbook) {
    // If the post is a cookbook
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/cookbook-detail',
          arguments: {
            'title': post['title'],
            'description': post['description'],
            'photo': post['image'],
            'cookbookId': post['id'],
          },
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                post['image'],
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            // Details Section (with Trash Icon)
            ListTile(
              title: Text(post['title']),
              subtitle: Text("By ${post['author']}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteDialog(context, post, isCookbook: true),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                post['description'],
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  } else {
    // If the post is a recipe
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/recipe-detail',
          arguments: post  // Pass all recipe data
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                post['image'],
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            // Details Section (with Trash Icon)
            ListTile(
              title: Text(post['title']),
              subtitle: Text(post['description']),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteDialog(context, post, isCookbook: false),
              ),
            ),
            // Add Time and Difficulty for recipes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Icon(Icons.timer, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(post['time'] ?? 'N/A'),
                  SizedBox(width: 16),
                  Icon(Icons.bar_chart, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(post['difficulty'] ?? 'N/A'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

  Widget _buildUserReview({
    required String recipeTitle,
    required String reviewText,
    required double rating,
    required String image,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(image),
              radius: 25,
            ),
            title: Text(
              recipeTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < rating.toInt() ? Icons.star : Icons.star_border,
                  color: Colors.orangeAccent,
                  size: 16,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              reviewText,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard({
    required String image,
    required String title,
    required int likes,
    required int reviews,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              image,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.favorite, size: 16, color: Colors.red),
                        const SizedBox(width: 4),
                        Text(
                          likes.toString(),
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.comment, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          "$reviews Reviews",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
