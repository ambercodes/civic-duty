import '../data/static_sandbox_data.dart';
import '../models/civic_ratification_record.dart';
import 'api_client.dart';

class CrrService {
  CrrService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<CivicRatificationRecord>> listRecords() async {
    try {
      final data = await _apiClient.get('/records');
      final records = data['records'] as List<dynamic>? ?? [];
      return records
          .whereType<Map<String, dynamic>>()
          .map(CivicRatificationRecord.fromJson)
          .toList();
    } catch (_) {
      return const [StaticSandboxData.record];
    }
  }

  Future<CivicRatificationRecord> getRecord(String slug) async {
    try {
      final data = await _apiClient.get('/records/$slug');
      return CivicRatificationRecord.fromJson(
        data['record'] as Map<String, dynamic>,
      );
    } catch (_) {
      return StaticSandboxData.recordBySlug(slug);
    }
  }
}
