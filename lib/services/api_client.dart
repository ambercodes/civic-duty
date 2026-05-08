import 'dart:convert';

import 'package:http/http.dart' as http;

import 'auth_service.dart';

class ApiClient {
  ApiClient({
    http.Client? httpClient,
    String? baseUrl,
    Future<String?> Function()? tokenProvider,
  }) : _httpClient = httpClient ?? http.Client(),
       _baseUrl =
           baseUrl ??
           const String.fromEnvironment('API_BASE_URL', defaultValue: '/api'),
       _tokenProvider = tokenProvider ?? AuthService().idToken;

  final http.Client _httpClient;
  final String _baseUrl;
  final Future<String?> Function()? _tokenProvider;

  Future<Map<String, dynamic>> get(
    String path, {
    bool authenticated = false,
  }) async {
    final response = await _httpClient.get(
      _uri(path),
      headers: await _headers(authenticated: authenticated),
    );
    return _decode(response);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Object? body,
    bool authenticated = true,
  }) async {
    final response = await _httpClient.post(
      _uri(path),
      headers: await _headers(authenticated: authenticated),
      body: jsonEncode(body ?? const <String, Object?>{}),
    );
    return _decode(response);
  }

  Uri _uri(String path) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    if (_baseUrl.startsWith('http')) {
      return Uri.parse('$_baseUrl$normalizedPath');
    }
    return Uri.parse('$_baseUrl$normalizedPath');
  }

  Future<Map<String, String>> _headers({required bool authenticated}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (authenticated) {
      final token = await _tokenProvider?.call();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Map<String, dynamic> _decode(http.Response response) {
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    if (decoded['ok'] == true) {
      return (decoded['data'] as Map<String, dynamic>?) ??
          const <String, dynamic>{};
    }

    final error = (decoded['error'] as Map<String, dynamic>?) ?? {};
    throw ApiException(
      code: (error['code'] ?? 'SERVER_ERROR').toString(),
      message: (error['message'] ?? 'Unexpected API error.').toString(),
      statusCode: response.statusCode,
    );
  }
}

class ApiException implements Exception {
  const ApiException({
    required this.code,
    required this.message,
    required this.statusCode,
  });

  final String code;
  final String message;
  final int statusCode;

  @override
  String toString() => '$code: $message';
}
