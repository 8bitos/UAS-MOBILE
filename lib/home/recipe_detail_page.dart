import 'package:flutter/material.dart';
import 'package:uas_cookedex/services/recipe_service.dart';
import 'package:uas_cookedex/services/auth_service.dart';
import 'package:uas_cookedex/services/image_search_service.dart';

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
    _fetchImage();
  }

  Future<void> _fetchImage() async {
    final imageUrl = await _imageSearchService.fetchImageBasedOnTitle(widget.recipe['title']);
    setState(() {
      _imageUrl = imageUrl;
    });
  }

  Future<void> _toggleLike(int recipeId, bool isLiked) async {
    try {
      if (isLiked) {
        await _recipeService.unlikeRecipe(recipeId);
      } else {
        await _recipeService.likeRecipe(recipeId);
      }
      setState(() {
        widget.recipe['is_liked'] = !isLiked;
        widget.recipe['likes_count'] += isLiked ? -1 : 1;
      });
    } catch (e) {
      _showErrorSnackBar('Failed to toggle like: $e');
    }
  }

  Future<void> _toggleSave(int recipeId, bool isSaved) async {
    try {
      if (isSaved) {
        await _recipeService.unsaveRecipe(recipeId);
      } else {
        await _recipeService.saveRecipe(recipeId);
      }
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

  Future<void> _deleteComment(int commentId) async {
    try {
      await _recipeService.deleteComment(commentId);
      setState(() {
        _comments.removeWhere((comment) => comment['id'] == commentId);
      });
      _showErrorSnackBar('Comment deleted successfully.');
    } catch (e) {
      _showErrorSnackBar('Failed to delete comment: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    final bool isLiked = recipe['is_liked'] ?? false;
    final bool isSaved = recipe['is_saved'] ?? false;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Fungsi untuk memecah teks berdasarkan koma
    String formatText(String text) {
      return text.split(',').join(',\n');
    }

    // Calculate scaling factor based on screen width
    double scaleFactor = screenWidth < 360 ? 0.8 : screenWidth > 600 ? 1.2 : 1.0;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Gambar sebagai header
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _imageUrl != null
                  ? Image.network(
                      _imageUrl!,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Text(
                          "No Image Available",
                          style: TextStyle(fontSize: 16 * scaleFactor),
                        ),
                      ),
                    ),
            ),
          ),
          // Konten
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title dan Like/Save berada di atas Deskripsi
                  Text(
                    recipe['title'] ?? 'Untitled Recipe',
                    style: TextStyle(
                      fontSize: 28 * scaleFactor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start, // Agar Like/Save berada di kiri
                    children: [
                      // Like button
                      IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: isLiked ? Colors.orangeAccent : Colors.grey,
                        ),
                        onPressed: () => _toggleLike(recipe['id'], isLiked),
                      ),
                      Text('${recipe['likes_count']} Likes', style: TextStyle(fontSize: 14 * scaleFactor)),
                      // Save button
                      IconButton(
                        icon: Icon(
                          Icons.bookmark,
                          color: isSaved ? Colors.orangeAccent : Colors.grey,
                        ),
                        onPressed: () => _toggleSave(recipe['id'], isSaved),
                      ),
                      Text('${recipe['saved_by_count']} Saves', style: TextStyle(fontSize: 14 * scaleFactor)),
                    ],
                  ),
                  SizedBox(height: 16),
                  // TabBar untuk Intro, Ingredients, dan Steps
                  DefaultTabController(
                    length: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TabBar(
                          labelColor: Colors.orangeAccent,
                          indicatorColor: Colors.orangeAccent,
                          tabs: [
                            Tab(text: "Intro"),
                            Tab(text: "Ingredients"),
                            Tab(text: "Steps"),
                          ],
                        ),
                        SizedBox(height: 8),
                        Container(
                          height: 300,
                          child: TabBarView(
                            children: [
                              // Intro Tab
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  recipe['description'] ?? 'No description available.',
                                  style: TextStyle(fontSize: 16 * scaleFactor),
                                ),
                              ),
                              // Ingredients Tab
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  formatText(recipe['ingredients'] ?? 'No ingredients available.'),
                                  style: TextStyle(fontSize: 16 * scaleFactor),
                                ),
                              ),
                              // Steps Tab
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  formatText(recipe['steps'] ?? 'No steps available.'),
                                  style: TextStyle(fontSize: 16 * scaleFactor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  // Show reviews button wrapped in a card
                  Card(
                    margin: EdgeInsets.only(bottom: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Reviews (${_comments.length})',
                                style: TextStyle(
                                  fontSize: 18 * scaleFactor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _showReviews = !_showReviews;
                                  });
                                  if (!_showReviews) _fetchComments();
                                },
                                child: Text(
                                  'Read All',
                                  style: TextStyle(color: Colors.orangeAccent, fontSize: 14 * scaleFactor),
                                ),
                              ),
                            ],
                          ),
                          if (_showReviews) ...[
                            _isLoadingComments
                                ? Center(child: CircularProgressIndicator())
                                : Column(
                                    children: [
                                      ..._comments.map((comment) => Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0),
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              elevation: 2,
                                              child: Padding(
                                                padding: const EdgeInsets.all(12.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      comment['user']['name'] ?? 'Anonymous',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16 * scaleFactor,
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      comment['content'] ?? '',
                                                      style: TextStyle(
                                                        fontSize: 14 * scaleFactor,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.topRight,
                                                      child: IconButton(
                                                        icon: Icon(Icons.delete, color: Colors.orangeAccent),
                                                        onPressed: () {
                                                          _deleteComment(comment['id']);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Form untuk menambahkan komentar
                  TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      labelText: 'Add a comment',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send, color: Colors.orangeAccent),
                        onPressed: _addComment,
                      ),
                    ),
                    style: TextStyle(fontSize: 14 * scaleFactor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
