import 'api_client.dart';

class ParticipationService {
  ParticipationService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<void> confirmRead(String dossierIdOrSlug) async {
    await _apiClient.post('/dossiers/$dossierIdOrSlug/read-confirmation');
  }

  Future<void> respondToProvision({
    required String provisionId,
    required String position,
  }) async {
    await _apiClient.post(
      '/provisions/$provisionId/response',
      body: {'position': position},
    );
  }
}
