import 'package:flutter/foundation.dart';
import '../models/kos_model.dart';
import '../repositories/kos_repository.dart';

class KosProvider with ChangeNotifier {
  final KosRepository _repository;

  KosProvider({KosRepository? repository})
      : _repository = repository ?? KosRepository();

  List<KosModel> _kosList = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  // Getters
  List<KosModel> get kosList => _kosList;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  /// Daftar kos yang sudah difilter berdasarkan kategori dan kata kunci pencarian
  List<KosModel> get filteredKosList {
    return _kosList.where((kos) {
      final matchesCategory = _selectedCategory == 'Semua' ||
          kos.type.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesQuery = _searchQuery.isEmpty ||
          kos.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          kos.address.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          kos.facilities.any((f) =>
              f.toLowerCase().contains(_searchQuery.toLowerCase()));
      return matchesCategory && matchesQuery;
    }).toList();
  }

  /// Rekomendasi kos untuk Dashboard (rating >= 4.5 & tersedia)
  List<KosModel> get recommendedKosList {
    return _kosList.where((k) => k.rating >= 4.5).take(4).toList();
  }

  /// Memuat katalog kos dari REST API / Repository
  Future<void> fetchKosCatalog() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _kosList = await _repository.getKosList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Gagal memuat data kos: $e';
      notifyListeners();
    }
  }

  /// Mengubah kategori filter ('Semua', 'Putra', 'Putri', 'Campur')
  void setCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  /// Mengatur kata kunci pencarian
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Mereset pencarian
  void clearSearch() {
    _searchQuery = '';
    _selectedCategory = 'Semua';
    notifyListeners();
  }
}
