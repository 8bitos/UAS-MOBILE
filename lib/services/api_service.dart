import 'package:dio/dio.dart';

class UserService {
  final Dio _dio = Dio();
  final String baseUrl =
      'http://localhost:8000/api'; // Replace with your API URL

  // Fetch user data (recipes)
  Future<List<Map<String, dynamic>>> fetchUserRecipes(String token) async {
    try {
      final response = await _dio.get(
        '$baseUrl/recipes', // Replace with your recipes endpoint
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}
