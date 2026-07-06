import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:movie_verse_app/core/constants/tmdb_token.dart';

class ApiService {
  static const String _baseUrl = 'https://api.themoviedb.org/3/';
  static const String _accessToken = tmdbAccessToken;

  final Dio _dio;

  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_accessToken',
          },
        ),
      );

  Future<Map<String, dynamic>> get({
    required String endPoint,
    Map<String, dynamic>? query,
    Duration? receiveTimeout,
    Duration? connectTimeout,
  }) async {
    final response = await _dio.get(
      endPoint,
      queryParameters: query,
      options: _buildOptions(
        receiveTimeout: receiveTimeout,
        connectTimeout: connectTimeout,
      ),
    );
    return _normalizeMapResponse(response.data);
  }

  Options _buildOptions({Duration? receiveTimeout, Duration? connectTimeout}) {
    return Options(
      receiveTimeout: receiveTimeout,
      connectTimeout: connectTimeout,
    );
  }

  Map<String, dynamic> _normalizeMapResponse(dynamic data) {
    if (data == null) return {};
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is String) {
      final trimmed = data.trim();
      if (trimmed.isEmpty) return {};
      final parsed = jsonDecode(trimmed);
      if (parsed is Map) return Map<String, dynamic>.from(parsed);
    }
    throw FormatException('Unexpected API response shape: ${data.runtimeType}');
  }
}
