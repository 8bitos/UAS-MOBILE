import 'package:flutter/material.dart';
import 'package:uas_cookedex/services/recipe_service.dart';
import 'package:uas_cookedex/services/auth_service.dart';
import 'recipe_detail_page.dart'; // Import the detail page

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _recipeService = RecipeService();
  List<dynamic> _recipes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  void _loadRecipes() async {
    setState(() {
      _isLoading = true;
    });
    final recipes = await _recipeService.getRecipes();
    setState(() {
      _isLoading = false;
      _recipes = recipes;
    });
  }

  Future<void> _toggleLike(int recipeId, bool isLiked, int index) async {
    try {
      if (isLiked) {
        await _recipeService.unlikeRecipe(recipeId);
        setState(() {
          _recipes[index]['is_liked'] = false;
          _recipes[index]['likes_count'] -= 1;
        });
      } else {
        await _recipeService.likeRecipe(recipeId);
        setState(() {
          _recipes[index]['is_liked'] = true;
          _recipes[index]['likes_count'] += 1;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to toggle like: $e'),
      ));
    }
  }

  Future<void> _toggleSave(int recipeId, bool isSaved, int index) async {
    try {
      if (isSaved) {
        await _recipeService.unsaveRecipe(recipeId);
        setState(() {
          _recipes[index]['is_saved'] = false;
        });
      } else {
        await _recipeService.saveRecipe(recipeId);
        setState(() {
          _recipes[index]['is_saved'] = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to toggle save: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _recipes.length,
              itemBuilder: (ctx, index) {
                final recipe = _recipes[index];
                final bool isLiked = recipe['is_liked'] ?? false;
                final bool isSaved = recipe['is_saved'] ?? false;

                // Truncate description to 100 characters
                String truncatedDescription = recipe['description'];
                if (truncatedDescription.length > 100) {
                  truncatedDescription =
                      truncatedDescription.substring(0, 100) + '...';
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailPage(
                            recipe: recipe), // Navigate to detail page
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          recipe['image_url'] != null
                              ? Image.network(
                                  recipe['image_url'],
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : SizedBox.shrink(),
                          SizedBox(height: 10),
                          Text(
                            recipe['title'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'By: ${recipe['user']['name']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                              truncatedDescription), // Display truncated description
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _toggleLike(recipe['id'], isLiked, index);
                                    },
                                    child: Icon(
                                      Icons.favorite,
                                      color: isLiked ? Colors.red : Colors.grey,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text('${recipe['likes_count']} Likes'),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _showCommentDialog(recipe['id']);
                                    },
                                    child:
                                        Icon(Icons.comment, color: Colors.blue),
                                  ),
                                  SizedBox(width: 5),
                                  Text('${recipe['comments_count']} Comments'),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _toggleSave(recipe['id'], isSaved, index);
                                    },
                                    child: Icon(
                                      Icons.bookmark,
                                      color:
                                          isSaved ? Colors.green : Colors.grey,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text('${recipe['saved_by_count']} Saves'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showCommentDialog(int recipeId) {
    final TextEditingController _commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Comment'),
          content: TextField(
            controller: _commentController,
            decoration: InputDecoration(hintText: 'Write your comment here'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final comment = _commentController.text;
                if (comment.isNotEmpty) {
                  await _addComment(recipeId, comment);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addComment(int recipeId, String content) async {
    try {
      await _recipeService.addComment(recipeId, content);
      _loadRecipes();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to add comment: $e'),
      ));
    }
  }
}
