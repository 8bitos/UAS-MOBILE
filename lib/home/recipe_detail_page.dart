import 'package:flutter/material.dart';
import 'package:uas_cookedex/services/recipe_service.dart';
import 'package:uas_cookedex/services/auth_service.dart';
import 'package:uas_cookedex/services/image_search_service.dart'; // Import the image search service

class RecipeDetailPage extends StatefulWidget {
  final dynamic recipe;

  RecipeDetailPage({required this.recipe});

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  final RecipeService _recipeService = RecipeService();
  final AuthService _authService = AuthService();
  final ImageSearchService _imageSearchService = ImageSearchService();
  bool _showReviews = false;
  List<dynamic> _comments = [];
  final TextEditingController _commentController = TextEditingController();
  bool _isLoadingComments = false;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchImage(); // Fetch the image based on the recipe title
  }

  // Fetch image based on title
  Future<void> _fetchImage() async {
    final imageUrl = await _imageSearchService
        .fetchImageBasedOnTitle(widget.recipe['title']);
    setState(() {
      _imageUrl = imageUrl; // Set the fetched image URL
    });
  }

  // Like the recipe
  Future<void> _toggleLike(int recipeId, bool isLiked) async {
    try {
      if (isLiked) {
        // Unlike the recipe if already liked
        await _recipeService.unlikeRecipe(recipeId);
      } else {
        // Like the recipe if not already liked
        await _recipeService.likeRecipe(recipeId);
      }

      // After liking/unliking, update the UI
      setState(() {
        widget.recipe['is_liked'] = !isLiked;
        widget.recipe['likes_count'] += isLiked ? -1 : 1;
      });
    } catch (e) {
      _showErrorSnackBar('Failed to toggle like: $e');
    }
  }

  // Save the recipe
  Future<void> _toggleSave(int recipeId, bool isSaved) async {
    try {
      if (isSaved) {
        // Unsave the recipe if already saved
        await _recipeService.unsaveRecipe(recipeId);
      } else {
        // Save the recipe if not already saved
        await _recipeService.saveRecipe(recipeId);
      }

      // After saving/unsaving, update the UI
      setState(() {
        widget.recipe['is_saved'] = !isSaved;
        widget.recipe['saved_by_count'] += isSaved ? -1 : 1;
      });
    } catch (e) {
      _showErrorSnackBar('Failed to toggle save: $e');
    }
  }

  Future<void> _fetchComments() async {
    setState(() {
      _isLoadingComments = true;
    });
    try {
      final comments = await _recipeService.getComments(widget.recipe['id']);
      setState(() {
        _comments = comments;
      });
    } catch (e) {
      _showErrorSnackBar('Failed to load comments: $e');
    } finally {
      setState(() {
        _isLoadingComments = false;
      });
    }
  }

  Future<void> _addComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    try {
      await _recipeService.addComment(widget.recipe['id'], content);
      _commentController.clear();
      _showErrorSnackBar('Comment added successfully.');
      await _fetchComments();
    } catch (e) {
      _showErrorSnackBar('Failed to add comment: $e');
    }
  }

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
              // Recipe Image from Unsplash (or fallback if null)
              _imageUrl != null
                  ? Image.network(
                      _imageUrl!,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      'https://picsum.photos/250?image=0',
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              SizedBox(height: 16),
              Text(
                recipe['title'] ?? 'Untitled Recipe',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'By: ${recipe['user']['name'] ?? 'Unknown'}',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text(recipe['description'] ?? 'No description available.'),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: isLiked ? Colors.red : Colors.grey,
                    ),
                    onPressed: () => _toggleLike(recipe['id'], isLiked),
                  ),
                  Text('${recipe['likes_count']} Likes'),
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
              ElevatedButton(
                onPressed: () {
                  if (!_showReviews) _fetchComments();
                  setState(() {
                    _showReviews = !_showReviews;
                  });
                },
                child: Text(_showReviews ? 'Hide Reviews' : 'Show Reviews'),
              ),
              if (_showReviews) ...[
                SizedBox(height: 16),
                _isLoadingComments
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ..._comments.map((comment) => ListTile(
                                title: Text(comment['content'] ?? ''),
                                subtitle: Text(
                                    'By: ${comment['user']['name'] ?? 'Unknown'}'),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    // Add delete comment logic if needed
                                  },
                                ),
                              )),
                          TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              labelText: 'Add a comment',
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.send),
                                onPressed: _addComment,
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
