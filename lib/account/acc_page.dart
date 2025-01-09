import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';
import 'package:dio/dio.dart';

List<Map<String, dynamic>> userRecipes = [];

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String _selectedFilter = "All"; // Default filter: show all

  // Fetch user data from the API
  Future<void> fetchUserData() async {
    try {
      final dio = Dio();
      final response = await dio.get('http://localhost:8000/api/user-recipes');
      if (response.statusCode == 200) {
        setState(() {
          userRecipes = List<Map<String, dynamic>>.from(response.data);
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data when the page is loaded
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    // Filtered posts based on dropdown selection
    final filteredPosts = _selectedFilter == "All"
        ? userRecipes
        : userRecipes; // Modify if needed for more filters

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
          // Profile Header (without Edit button and profile image)
          Container(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: DropdownButton<String>(
                                value: _selectedFilter,
                                isExpanded: true,
                                items: const [
                                  DropdownMenuItem(
                                      value: "All", child: Text("All Posts")),
                                  DropdownMenuItem(
                                      value: "Recipes", child: Text("Recipes")),
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
    return const Center(
      child: Text('No reviews yet'),
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
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/recipe-detail',
            arguments: post // Pass all recipe data
            );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                post['image'],
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
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
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.comment, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          "$reviews Reviews",
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
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
