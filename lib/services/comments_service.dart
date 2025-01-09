import 'dart:convert';
import 'package:http/http.dart' as http;

class CommentService {
  final String _baseUrl =
      'http://localhost:8000/api'; // Replace with your API base URL

  // Fetch comments for a specific recipe by its ID
  Future<List<dynamic>> getComments(int recipeId) async {
    final url =
        '$_baseUrl/recipes/$recipeId/comments'; // Assuming you have this endpoint

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse the response body and return a list of comments
        final List<dynamic> comments = json.decode(response.body);
        return comments;
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      throw Exception('Failed to fetch comments: $e');
    }
  }

  // Add a comment to a specific recipe
  Future<void> addComment(int recipeId, String content) async {
    final url =
        '$_baseUrl/recipes/$recipeId/comments'; // Assuming you have this endpoint

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'content': content,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add comment');
      }
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }
}
