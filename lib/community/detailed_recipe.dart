import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_cookedex/default_recipe.dart';

class RecipeDetailPage extends StatelessWidget {
  const RecipeDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve recipe data from arguments or use fallback data
    final recipe = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? recipes[0];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.orangeAccent),
            onPressed: () {
              // Handle favorite action
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Recipe Image
                if (recipe["image"] != null)
                  Image.asset(
                    recipe["image"],
                    width: double.infinity,
                    height: constraints.maxHeight * 0.3, // 30% of the screen height
                    fit: BoxFit.cover,
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recipe Header
                      Row(
                        children: [
                          const Icon(Icons.book, size: 18, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "Cookbooks / ${recipe["title"]}",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis, // Prevent text overflow
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.orangeAccent),
                            onPressed: () {
                              // Handle add action
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        recipe["title"] ?? "No Title",
                        style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.favorite, color: Colors.red, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "${recipe["likes"] ?? 0}",
                            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            " | ${recipe["reviews"] ?? "0 Reviews"}",
                            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Time, Difficulty, Serves
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoColumn(Icons.timer, recipe["time"] ?? "N/A"),
                          _buildInfoColumn(Icons.star_border, recipe["difficulty"] ?? "N/A"),
                          _buildInfoColumn(Icons.restaurant, recipe["serves"] ?? "N/A"),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Reviews Section
                      Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 2,
                        child: Column(
                          children: [
                            ListTile(
                              leading: const CircleAvatar(
                                backgroundImage: AssetImage('assets/images/user1.jpg'),
                              ),
                              title: Text(
                                "Review by User",
                                style: GoogleFonts.poppins(),
                              ),
                              subtitle: const Text("This recipe is amazing!"),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/reviews',
                                    arguments: recipe['reviewsList'] ?? [],
                                  );
                                },
                                child: const Text(
                                  "READ ALL",
                                  style: TextStyle(color: Colors.orangeAccent),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Tab Section (Intro, Ingredients, Steps)
                      DefaultTabController(
                        length: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TabBar(
                              labelColor: Colors.orangeAccent,
                              unselectedLabelColor: Colors.grey,
                              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                              indicatorColor: Colors.orangeAccent,
                              tabs: const [
                                Tab(text: "Intro"),
                                Tab(text: "Ingredients"),
                                Tab(text: "Steps"),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 300,
                              child: TabBarView(
                                children: [
                                  // Intro Tab
                                  SingleChildScrollView(
                                    child: Text(
                                      recipe["description"] ?? "No Description Available",
                                      style: GoogleFonts.poppins(fontSize: 16, height: 1.5),
                                    ),
                                  ),
                                  // Ingredients Tab
                                  SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: List.generate(
                                        (recipe["ingredients"] as List<dynamic>).length,
                                        (index) => Row(
                                          children: [
                                            const Icon(Icons.circle, size: 8, color: Colors.orangeAccent),
                                            const SizedBox(width: 8),
                                            Text(
                                              recipe["ingredients"][index],
                                              style: GoogleFonts.poppins(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Steps Tab
                                  SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: List.generate(
                                        (recipe["steps"] as List<dynamic>).length,
                                        (index) => Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: Text(
                                            "${index + 1}. ${recipe["steps"][index]}",
                                            style: GoogleFonts.poppins(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
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
              ],
            ),
          );
        },
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
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/edit-recipe',
                  arguments: {"recipe": recipe},
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.orangeAccent),
              onPressed: () {
                final ingredients = (recipe["ingredients"] as List<dynamic>)
                    .map((item) => {"name": item, "checked": false})
                    .toList();
                Navigator.pushNamed(
                  context,
                  '/grocery-list',
                  arguments: ingredients,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Colors.orangeAccent, size: 20),
        const SizedBox(height: 8),
        Text(
          text,
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
