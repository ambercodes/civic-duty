import '../models/foundational_concern.dart';
import 'api_client.dart';

class ConcernService {
  ConcernService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<FoundationalConcern>> listConcerns() async {
    final data = await _apiClient.get('/concerns');
    return _readConcernList(data);
  }

  Future<List<FoundationalConcern>> listArchive() async {
    final data = await _apiClient.get('/concerns/archive');
    return _readConcernList(data);
  }

  Future<FoundationalConcern> getConcern(String idOrSlug) async {
    final data = await _apiClient.get('/concerns/$idOrSlug');
    return FoundationalConcern.fromJson(
      data['concern'] as Map<String, dynamic>,
    );
  }

  Future<ConcernThresholdStatus> getThreshold(String idOrSlug) async {
    final data = await _apiClient.get('/concerns/$idOrSlug/threshold');
    return ConcernThresholdStatus.fromJson(
      data['threshold'] as Map<String, dynamic>,
    );
  }

  Future<FoundationalConcern> submitConcern({
    required Map<String, Object?> body,
  }) async {
    final data = await _apiClient.post('/concerns', body: body);
    return FoundationalConcern.fromJson(
      data['concern'] as Map<String, dynamic>,
    );
  }

  Future<void> signalConcern(String idOrSlug) async {
    await _apiClient.post(
      '/concerns/$idOrSlug/signal',
      body: {
        'viewedSummary': true,
        'viewedScope': true,
        'viewedEvidence': true,
        'confirmedSignalMeaning': true,
      },
    );
  }

  List<FoundationalConcern> _readConcernList(Map<String, dynamic> data) {
    return (data['concerns'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(FoundationalConcern.fromJson)
        .toList();
  }
}
