import 'package:flutter/material.dart';
import 'package:uas_cookedex/default_recipe.dart'; // Import the default recipes

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          "Community",
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
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/images/profile_cover.png',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: -50,
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
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
              children: const [
                Text(
                  "Nararaya Kirana",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Rajin menabung dan suka memasak",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  "24 Followers · 8 Following",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  // Tabs
                  TabBar(
                    indicatorColor: Colors.orangeAccent,
                    labelColor: Colors.orangeAccent,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(child: Text("Posts")),
                      Tab(child: Text("Reviews")),
                      Tab(child: Text("Liked Recipes")),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Posts Tab
                        ListView(
                          padding: const EdgeInsets.all(16),
                          children: List.generate(
                            // Filter userPostedRecipes by specific images
                            recipes
                                .where((recipe) => recipe["image"] == "assets/images/recipe_user1.jpg" ||
                                    recipe["image"] == "assets/images/recipe_user2.jpg")
                                .toList()
                                .length,
                            (index) {
                              final filteredRecipes = recipes
                                  .where((recipe) => recipe["image"] == "assets/images/recipe_user1.jpg" ||
                                      recipe["image"] == "assets/images/recipe_user2.jpg")
                                  .toList();
                              final recipe = filteredRecipes[index];
                              return Column(
                                children: [
                                  _buildUserPostCard(
                                    context: context,
                                    recipe: recipe,
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              );
                            },
                          ),
                        ),
                        // Reviews Tab
                        ListView(
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
                        ),
                        // Liked Recipes Tab
                        ListView(
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
                        ),
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

  // Widget to display user's posts (recipes)
  Widget _buildUserPostCard({
    required BuildContext context,
    required Map<String, dynamic> recipe,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/recipe-detail',
          arguments: recipe,
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                recipe['image'],
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
                    recipe['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe['description'],
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to display user reviews
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

  // Widget to display liked recipes
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
