import '../models/dossier.dart';
import 'api_client.dart';

class DossierService {
  DossierService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<Dossier>> listDossiers() async {
    final data = await _apiClient.get('/dossiers');
    final dossiers = data['dossiers'] as List<dynamic>? ?? [];
    return dossiers
        .whereType<Map<String, dynamic>>()
        .map(Dossier.fromJson)
        .toList();
  }

  Future<Dossier> getDossier(String idOrSlug) async {
    final data = await _apiClient.get('/dossiers/$idOrSlug');
    return Dossier.fromJson(data['dossier'] as Map<String, dynamic>);
  }
}
