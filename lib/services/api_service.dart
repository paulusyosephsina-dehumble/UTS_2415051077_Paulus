import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/kos_model.dart';

class ApiService {
  // REST API Endpoint publik hosted di repository GitHub KosFinder
  static const String apiUrl =
      'https://raw.githubusercontent.com/paulusyosephsina-dehumble/UTS_2415051077_Paulus/main/assets/data/kos_api.json';

  // Timeout durasi 5 detik agar responsif jika sinyal lambat
  static const Duration timeoutDuration = Duration(seconds: 5);

  /// Mengambil daftar kos dari REST API (GET)
  /// Dilengkapi fallback otomatis ke local asset jika jaringan offline / timeout
  Future<List<KosModel>> fetchKosList() async {
    try {
      final response = await http
          .get(Uri.parse(apiUrl))
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((item) => KosModel.fromJson(item)).toList();
      } else {
        // Jika server memberikan status code selain 200, fallback ke dataset lokal
        return await _loadFromLocalAsset();
      }
    } catch (_) {
      // Jika terjadi kesalahan jaringan atau offline, muat dataset lokal dengan aman
      return await _loadFromLocalAsset();
    }
  }

  /// Memuat dataset kos dari bundle asset lokal sebagai fallback aman
  Future<List<KosModel>> _loadFromLocalAsset() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/kos_api.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((item) => KosModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Gagal memuat katalog kos: $e');
    }
  }
}
