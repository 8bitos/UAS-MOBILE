import 'package:flutter/material.dart';

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
            Navigator.pop(context); // Navigate back to the previous page
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Section
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/images/profile_cover.png', // Replace with your cover photo
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: -40,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white, // Add a border effect with background
                  child: CircleAvatar(
                    radius: 48,
                    backgroundImage: AssetImage('assets/images/profile.png'), // Replace with your profile image
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          const Text(
            "Nararaya Kirana",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Rajin menabung dan suka memasak",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            "24 Followers · 8 Following",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          // Tabs for Posts, Reviews, and Liked Recipes
          Expanded(
            child: DefaultTabController(
              length: 3, // Now includes Liked Recipes
              child: Column(
                children: [
                  TabBar(
                    indicatorColor: Colors.orangeAccent,
                    labelColor: Colors.orangeAccent,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(text: "Posts"),
                      Tab(text: "Reviews"),
                      Tab(text: "Liked Recipes"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Posts Tab
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView(
                            children: [
                              _buildRecipePost(
                                image: 'assets/images/recipe_user1.jpg',
                                title: "Resep Ayam Kuah Santan Pedas Lezat",
                                author: "Nadia Putri",
                                likes: 130,
                                reviews: 103,
                              ),
                              const SizedBox(height: 16),
                              _buildRecipePost(
                                image: 'assets/images/recipe_user2.jpg',
                                title: "Resep Kare Ayam Kuah Pedas",
                                author: "Nadia Putri",
                                likes: 89,
                                reviews: 45,
                              ),
                            ],
                          ),
                        ),
                        // Reviews Tab
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView(
                            children: [
                              _buildUserReview(
                                postTitle: "Resep Ikan Bakar Bumbu Kecap",
                                reviewText: "This recipe was amazing! The flavor was spot on!",
                                rating: 4.5,
                                image: 'assets/images/recipe_user1.jpg',
                              ),
                              const SizedBox(height: 16),
                              _buildUserReview(
                                postTitle: "Resep Soto Ayam Segar",
                                reviewText: "Really enjoyed this recipe. It was easy to follow.",
                                rating: 4.0,
                                image: 'assets/images/recipe_user2.jpg',
                              ),
                            ],
                          ),
                        ),
                        // Liked Recipes Tab
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView(
                            children: [
                              _buildRecipePost(
                                image: 'assets/images/recipe_user1.jpg',
                                title: "Resep Mie Ayam Jamur",
                                author: "Aruni",
                                likes: 250,
                                reviews: 120,
                              ),
                              const SizedBox(height: 16),
                              _buildRecipePost(
                                image: 'assets/images/recipe_user2.jpg',
                                title: "Resep Nasi Goreng Jawa",
                                author: "Anjani",
                                likes: 320,
                                reviews: 190,
                              ),
                            ],
                          ),
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

  Widget _buildRecipePost({
    required String image,
    required String title,
    required String author,
    required int likes,
    required int reviews,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border, color: Colors.white),
                ),
              ),
            ],
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
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundImage: AssetImage('assets/images/profile.png'),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      author,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.favorite, size: 16, color: Colors.red),
                        const SizedBox(width: 4),
                        Text(
                          likes.toString(),
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(width: 16),
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

  Widget _buildUserReview({
    required String postTitle,
    required String reviewText,
    required double rating,
    required String image,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(image),
              radius: 25,
            ),
            title: Text(
              postTitle,
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
}
