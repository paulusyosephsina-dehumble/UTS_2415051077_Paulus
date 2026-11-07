import '../models/saved_kos_model.dart';
import '../services/database_service.dart';

class SavedKosRepository {
  final DatabaseService _databaseService;

  SavedKosRepository({DatabaseService? databaseService})
      : _databaseService = databaseService ?? DatabaseService();

  /// Mengambil semua kos tersimpan (Read)
  Future<List<SavedKosModel>> getSavedKos() async {
    return await _databaseService.getAllSavedKos();
  }

  /// Menambahkan kos tersimpan (Create)
  Future<int> saveKos(SavedKosModel item) async {
    return await _databaseService.insertSavedKos(item);
  }

  /// Memperbarui kos tersimpan (Update)
  Future<int> updateKos(SavedKosModel item) async {
    return await _databaseService.updateSavedKos(item);
  }

  /// Menghapus kos tersimpan (Delete)
  Future<int> removeKos(int id) async {
    return await _databaseService.deleteSavedKos(id);
  }

  /// Memeriksa status tersimpan
  Future<bool> checkIsSaved(int kosId) async {
    return await _databaseService.isKosSaved(kosId);
  }
}
