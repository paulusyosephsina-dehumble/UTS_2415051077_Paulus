import 'package:flutter/foundation.dart';
import '../models/kos_model.dart';
import '../models/saved_kos_model.dart';
import '../repositories/saved_kos_repository.dart';

class SavedKosProvider with ChangeNotifier {
  final SavedKosRepository _repository;

  SavedKosProvider({SavedKosRepository? repository})
      : _repository = repository ?? SavedKosRepository();

  List<SavedKosModel> _savedKosList = [];
  bool _isLoading = false;
  String _errorMessage = '';
  final Set<int> _savedKosIds = {};

  // Getters
  List<SavedKosModel> get savedKosList => _savedKosList;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  int get totalSavedCount => _savedKosList.length;

  /// Memeriksa apakah suatu kos sudah disimpan di database
  bool isSaved(int kosId) => _savedKosIds.contains(kosId);

  /// Memuat data kos tersimpan dari SQLite Database (Read)
  Future<void> loadSavedKos() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _savedKosList = await _repository.getSavedKos();
      _savedKosIds.clear();
      for (final item in _savedKosList) {
        _savedKosIds.add(item.kosId);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Gagal memuat favorit dari database: $e';
      notifyListeners();
    }
  }

  /// Menambahkan kos baru ke Database (Create)
  Future<bool> addSavedKos(SavedKosModel item) async {
    try {
      final insertedId = await _repository.saveKos(item);
      if (insertedId > 0) {
        await loadSavedKos();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Gagal menyimpan kos: $e';
      notifyListeners();
      return false;
    }
  }

  /// Memperbarui catatan atau rating kos di Database (Update)
  Future<bool> updateSavedKos(SavedKosModel item) async {
    try {
      final rowsAffected = await _repository.updateKos(item);
      if (rowsAffected > 0) {
        await loadSavedKos();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Gagal memperbarui data kos: $e';
      notifyListeners();
      return false;
    }
  }

  /// Menghapus kos dari Database (Delete)
  Future<bool> deleteSavedKos(int id, int? kosId) async {
    try {
      final rowsAffected = await _repository.removeKos(id);
      if (rowsAffected > 0) {
        if (kosId != null) {
          _savedKosIds.remove(kosId);
        }
        await loadSavedKos();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Gagal menghapus data kos: $e';
      notifyListeners();
      return false;
    }
  }

  /// Toggle simpan / hapus langsung dari tombol Love di Card atau Detail
  Future<bool> toggleSaveKos(KosModel kos, {String note = '', double rating = 5.0}) async {
    if (isSaved(kos.id)) {
      // Hapus dari favorit
      final item = _savedKosList.firstWhere(
        (element) => element.kosId == kos.id,
        orElse: () => SavedKosModel(
          id: -1,
          studentId: '2415051077',
          kosId: kos.id,
          kosName: kos.name,
          address: kos.address,
          price: kos.price,
          type: kos.type,
          note: '',
          rating: 5.0,
          createdAt: '',
        ),
      );
      if (item.id != null && item.id! > 0) {
        return await deleteSavedKos(item.id!, kos.id);
      }
      return false;
    } else {
      // Tambah ke favorit
      final newItem = SavedKosModel(
        studentId: '2415051077',
        kosId: kos.id,
        kosName: kos.name,
        address: kos.address,
        price: kos.price,
        type: kos.type,
        note: note.isEmpty ? 'Disimpan dari rekomendasi katalog kos.' : note,
        rating: rating,
        createdAt: DateTime.now().toIso8601String(),
      );
      return await addSavedKos(newItem);
    }
  }
}
