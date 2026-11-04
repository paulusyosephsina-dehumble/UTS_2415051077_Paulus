import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

class ApiService {
  // Endpoint REST API Publik (GET)
  static const String apiUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<PostModel>> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        // Konversi setiap item JSON menjadi PostModel
        return jsonList.map((jsonItem) => PostModel.fromJson(jsonItem)).toList();
      } else {
        throw Exception('Gagal memuat data dari server (Code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }
}