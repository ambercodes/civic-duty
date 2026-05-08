import 'api_client.dart';

class MethodologyService {
  MethodologyService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> health() {
    return _apiClient.get('/health');
  }
}
