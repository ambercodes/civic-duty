import 'api_client.dart';
import '../models/user_profile.dart';

class UserService {
  UserService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<UserProfile> currentUser() async {
    final data = await _apiClient.get('/users/me', authenticated: true);
    return UserProfile.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<UserProfile> saveProfile({
    required String displayAlias,
    required int birthYear,
    required String stateCode,
    required bool citizenshipAttested,
  }) async {
    final data = await _apiClient.post(
      '/users/profile',
      body: {
        'displayAlias': displayAlias,
        'birthYear': birthYear,
        'stateCode': stateCode,
        'citizenshipAttested': citizenshipAttested,
      },
    );
    return UserProfile.fromJson(data['user'] as Map<String, dynamic>);
  }
}
