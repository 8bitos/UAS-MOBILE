import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas_cookedex/account/acc_setting.dart';
import 'package:uas_cookedex/services/recipe_service.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with SingleTickerProviderStateMixin {
  late RecipeService _recipeService;
  late TabController _tabController;

  List<dynamic> createdRecipes = [];
  List<dynamic> likedRecipes = [];
  List<dynamic> savedRecipes = [];
  List<dynamic> commentedRecipes = [];

  String? userName;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _recipeService = RecipeService();
    _tabController = TabController(length: 4, vsync: this);
    _fetchUserData();
    _fetchData();
  }

  // Fetch user data from shared preferences
  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'Loading...';
      userEmail = prefs.getString('user_email') ?? 'Loading...';
    });
  }

  _fetchData() async {
    try {
      createdRecipes = await _recipeService.getUserCreatedRecipes();
      likedRecipes = await _recipeService.getUserLikedRecipes();
      savedRecipes = await _recipeService.getUserSavedRecipes();
      commentedRecipes = await _recipeService.getUserCommentedRecipes();

      setState(() {});
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Widget _buildSection(String title, List<dynamic> recipes) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        var recipe = recipes[index];
        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          title: Text(recipe['title'],
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(recipe['description']),
          onTap: () {
            // Navigate to recipe details
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Page'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccSettingPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileSection(),
            const SizedBox(height: 20), // Space between profile and tabs
            SizedBox(
              height: 400, // Adjust height based on content
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSection('Liked Recipes', likedRecipes),
                  _buildSection('Saved Recipes', savedRecipes),
                  _buildSection('Commented Recipes', commentedRecipes),
                  _buildSection('Created Recipes', createdRecipes),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blueAccent,
            child: Text(
              userName?.isNotEmpty ?? false
                  ? userName![0].toUpperCase()
                  : '?', // First letter of the username
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            userName ?? "User Name",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            userEmail ?? "user@example.com",
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20), // Adding space between profile and tabs
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Liked'),
              Tab(text: 'Saved'),
              Tab(text: 'Commented'),
              Tab(text: 'Created'),
            ],
          ),
        ],
      ),
    );
  }
}
