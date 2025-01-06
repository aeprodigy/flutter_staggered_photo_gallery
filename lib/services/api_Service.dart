import 'dart:convert';

import 'package:picture_app/models/photo.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiKey =
      'NuqfPXmJ1LxqQTmWx35yQ8GSKSfl4KJaIKqc3HwQVy241PUKzGvw03WQ';
  static const String baseUrl = 'https://api.pexels.com/v1';

  static Future<List<Photo>> fetchPhotos(
      {int page = 1, int perPage = 15}) async {
    final url = Uri.parse('$baseUrl/curated?page=$page&per_page=$perPage');

    final response = await http.get(
      url,
      headers: {
        'Authorization': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data); // Debugging: Print API response
      
      final photos = (data['photos'] as List)
          .map((photo) => Photo.fromJson(photo))
          .toList();
      return photos;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
