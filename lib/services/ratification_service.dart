import 'api_client.dart';

class RatificationService {
  RatificationService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<void> ratify(String dossierIdOrSlug) async {
    await _apiClient.post(
      '/dossiers/$dossierIdOrSlug/ratification',
      body: {'position': 'ratify'},
    );
  }

  Future<void> doNotRatify(String dossierIdOrSlug) async {
    await _apiClient.post(
      '/dossiers/$dossierIdOrSlug/ratification',
      body: {'position': 'do_not_ratify'},
    );
  }
}
