import 'package:dio/dio.dart';
import 'auth_service.dart';

class RecipeService {
  final Dio _dio = Dio();
  final AuthService _authService = AuthService();

  // Fetch the list of recipes
  Future<List<dynamic>> getRecipes() async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('Token not found. Please log in again.');
    }

    final response = await _dio.get(
      'http://localhost:8000/api/recipes',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    return response.data;
  }

  // Like a specific recipe
  Future<void> likeRecipe(int recipeId) async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('Token not found. Please log in again.');
    }

    await _dio.post(
      'http://localhost:8000/api/recipes/$recipeId/like',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }

  // Unlike a specific recipe
  Future<void> unlikeRecipe(int recipeId) async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('Token not found. Please log in again.');
    }

    await _dio.delete(
      'http://localhost:8000/api/recipes/$recipeId/like',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }

  // Save a specific recipe
  Future<void> saveRecipe(int recipeId) async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('Token not found. Please log in again.');
    }

    await _dio.post(
      'http://localhost:8000/api/recipes/$recipeId/save',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }

  // Unsave a specific recipe
  Future<void> unsaveRecipe(int recipeId) async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('Token not found. Please log in again.');
    }

    await _dio.delete(
      'http://localhost:8000/api/recipes/$recipeId/save',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }

  // Add a comment to a recipe
  Future<void> addComment(int recipeId, String content) async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('Token not found. Please log in again.');
    }

    await _dio.post(
      'http://localhost:8000/api/recipes/$recipeId/comments',
      data: {'content': content},
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }
}
