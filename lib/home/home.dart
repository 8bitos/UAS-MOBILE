import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> cookbooks = [
      {
        "image": "assets/images/cookbook1.jpg",
        "title": "Buku resep spesial antara",
        "description": "Keep it easy with these simple but delicious recipes.",
        "likes": "1.3k",
        "recipes": "7"
      },
      {
        "image": "assets/images/cookbook2.jpg",
        "title": "Buku resep Nusantara",
        "description": "Explore traditional recipes from all around Indonesia.",
        "likes": "800",
        "recipes": "12"
      },
    ];

    final List<Map<String, String>> communityRecipes = [
      {
        "image": "assets/images/recipe1.jpg",
        "title": "Resep Ayam Kuah Santan Pedas Lezat",
        "author": "Nadia Putri",
        "likes": "130",
        "reviews": "105 Reviews"
      },
      {
        "image": "assets/images/recipe2.jpg",
        "title": "Resep Garang Asem Ayam Kampung",
        "author": "Gayus Tri Pinjungwati",
        "likes": "150",
        "reviews": "103 Reviews"
      },
      {
        "image": "assets/images/recipe3.jpg",
        "title": "Penne ala Bolognese",
        "author": "Gayus Tri Pinjungwati",
        "likes": "124",
        "reviews": "43 Reviews"
      },
    ];

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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center, // Sejajarkan teks
                  children: const [
                    Text(
                      "Hi Nara",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
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

      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cookbooks Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Cookbooks",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 300,
                    child: PageView.builder(
                      controller: PageController(viewportFraction: 1.0),
                      itemCount: cookbooks.length,
                      itemBuilder: (context, index) {
                        final cookbook = cookbooks[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    child: Image.asset(
                                      cookbook["image"]!,
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
                                        cookbook["title"]!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        cookbook["description"]!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${cookbook["likes"]} Likes",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            "${cookbook["recipes"]} Recipes",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
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
                      },
                    ),
                  ),
                ],
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
                  ...communityRecipes.map((recipe) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            recipe["image"]!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe["title"]!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      "by ${recipe["author"]}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "${recipe["likes"]} Likes",
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
                    );
                  }).toList(),
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
        onPressed: () {
          // Add functionality for the button
        },
        backgroundColor: Colors.orangeAccent,
        child: const Icon(Icons.add, color: Colors.white),
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
            icon: Icon(Icons.favorite_outline, size: 28),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 28),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined, size: 28),
            label: "",
          ),
        ],
      ),
    );
  }
}
