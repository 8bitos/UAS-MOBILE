import 'package:flutter/material.dart';
import 'package:uas_cookedex/services/recipe_service.dart';
import 'package:uas_cookedex/services/auth_service.dart';
import 'package:dio/dio.dart';

class RecipeDetailPage extends StatefulWidget {
  final dynamic recipe;

  RecipeDetailPage({required this.recipe});

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  final RecipeService _recipeService = RecipeService();
  final AuthService _authService = AuthService();
  final TextEditingController _commentController = TextEditingController();
  List<dynamic> _comments = [];

  @override
  void initState() {
    super.initState();
    _loadComments(widget.recipe['id']);
  }

  // Fetch the comments for a specific recipe
  Future<void> _loadComments(int recipeId) async {
    try {
      final response = await Dio().get(
        'http://localhost:8000/api/recipes/$recipeId/comments',
      );
      setState(() {
        _comments = response.data;
      });
    } catch (e) {
      _showErrorSnackBar('Failed to load comments: ${e.toString()}');
    }
  }

  // Like the recipe
  Future<void> _toggleLike(int recipeId, bool isLiked) async {
    try {
      if (isLiked) {
        await _recipeService.unlikeRecipe(recipeId);
      } else {
        await _recipeService.likeRecipe(recipeId);
      }
      setState(() {
        widget.recipe['is_liked'] = !isLiked;
      });
    } catch (e) {
      _showErrorSnackBar(e.toString());
    }
  }

  // Save the recipe
  Future<void> _toggleSave(int recipeId, bool isSaved) async {
    try {
      if (isSaved) {
        await _recipeService.unsaveRecipe(recipeId);
      } else {
        await _recipeService.saveRecipe(recipeId);
      }
      setState(() {
        widget.recipe['is_saved'] = !isSaved;
      });
    } catch (e) {
      _showErrorSnackBar(e.toString());
    }
  }

  // Add a comment
  Future<void> _addComment(int recipeId) async {
    final comment = _commentController.text;
    if (comment.isNotEmpty) {
      try {
        await Dio().post(
          'http://localhost:8000/api/recipes/$recipeId/comments',
          data: {'content': comment},
        );
        _loadComments(recipeId);
        _commentController.clear();
      } catch (e) {
        _showErrorSnackBar('Failed to add comment: ${e.toString()}');
      }
    }
  }

  // Show error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    final bool isLiked = recipe['is_liked'] ?? false;
    final bool isSaved = recipe['is_saved'] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['title'] ?? 'Untitled Recipe'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Image.network(
                recipe['image_url'] ?? 'https://picsum.photos/250?image=0',
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),
              // Recipe Title
              Text(
                recipe['title'] ?? 'Untitled Recipe',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              // Recipe Author
              Text(
                'By: ${recipe['user']['name'] ?? 'Unknown'}',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 16),
              // Recipe Description
              Text(
                recipe['description'] ?? 'No description available.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              // Ingredients
              Text(
                'Ingredients:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                recipe['ingredients'] ?? 'No ingredients listed.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              // Steps
              Text(
                'Steps:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                recipe['steps'] ?? 'No steps available.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              // Like, Comment, Save buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Like Button
                  IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: isLiked ? Colors.red : Colors.grey,
                    ),
                    onPressed: () => _toggleLike(recipe['id'], isLiked),
                  ),
                  Text('${recipe['likes_count']} Likes'),
                  // Comment Button
                  IconButton(
                    icon: Icon(Icons.comment, color: Colors.blue),
                    onPressed: () {},
                  ),
                  Text('${recipe['comments_count']} Comments'),
                  // Save Button
                  IconButton(
                    icon: Icon(
                      Icons.bookmark,
                      color: isSaved ? Colors.green : Colors.grey,
                    ),
                    onPressed: () => _toggleSave(recipe['id'], isSaved),
                  ),
                  Text('${recipe['saved_by_count']} Saves'),
                ],
              ),
              SizedBox(height: 16),
              // Comments Section
              Text(
                'Comments:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _comments[index]['content'],
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
              // Comment Input Box
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () => _addComment(recipe['id']),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
