import '../models/kos_model.dart';
import '../services/api_service.dart';

class KosRepository {
  final ApiService _apiService;

  KosRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Mengambil katalog kos dari data source (REST API / local fallback)
  Future<List<KosModel>> getKosList() async {
    return await _apiService.fetchKosList();
  }
}
