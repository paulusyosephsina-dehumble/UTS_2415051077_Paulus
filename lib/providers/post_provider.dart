import 'package:flutter/foundation.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';

class PostProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  // State variabel
  List<PostModel> _posts = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Getter untuk diakses oleh UI
  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Fungsi untuk mengambil data dari API melalui Service
  Future<void> loadPosts() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); // Beritahu UI bahwa status sedang loading

    try {
      _posts = await _apiService.fetchPosts();
      _isLoading = false;
      notifyListeners(); // Beritahu UI data berhasil dimuat
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners(); // Beritahu UI terjadi error
    }
  }
}