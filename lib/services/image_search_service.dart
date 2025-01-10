import 'package:dio/dio.dart';

class ImageSearchService {
  final Dio _dio = Dio();

  // Replace with your Unsplash API Key
  final String apiKey = 'B36bMhKMJ3IqRXj9z4r9ojVq22rrVBuVdJDWxidE-2g';

  Future<String?> fetchImageBasedOnTitle(String title) async {
    try {
      final response = await _dio.get(
        'https://api.unsplash.com/search/photos',
        queryParameters: {
          'query': title,
          'client_id': apiKey, // Unsplash API Key
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['results'].isNotEmpty) {
          return data['results'][0]['urls']['regular']; // Fetch the image URL
        }
      }
      return null;
    } catch (e) {
      print('Error fetching image: $e');
      return null;
    }
  }
}
