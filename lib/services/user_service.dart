import 'api_client.dart';

class UserService {
  UserService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> currentUser() async {
    final data = await _apiClient.get('/users/me', authenticated: true);
    return data['user'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> saveProfile({
    required String dateOfBirth,
    required String stateCode,
    required bool citizenshipAttested,
  }) async {
    final data = await _apiClient.post(
      '/users/profile',
      body: {
        'dateOfBirth': dateOfBirth,
        'stateCode': stateCode,
        'citizenshipAttested': citizenshipAttested,
      },
    );
    return data['user'] as Map<String, dynamic>;
  }
}
