import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class FootballApi {
  FootballApi({required String token})
      : _dio = Dio(BaseOptions(
          baseUrl: kIsWeb
              ? 'http://localhost/football_proxy'
              : 'https://api.football-data.org/v4',
          headers: kIsWeb ? null : {'X-Auth-Token': token},
        ));

  final Dio _dio;

  Future<List<dynamic>> getMatches({
    required String competitionCode,
    String? status,
    int? limit,
  }) async {
    if (kIsWeb) {
      final res = await _dio.get(
        '/matches.php',
        queryParameters: {
          'competition': competitionCode,
          if (status != null) 'status': status,
          if (limit != null) 'limit': limit,
        },
      );
      return (res.data['matches'] as List);
    }

    final res = await _dio.get(
      '/competitions/$competitionCode/matches',
      queryParameters: {
        if (status != null) 'status': status,
        if (limit != null) 'limit': limit,
      },
    );
    return (res.data['matches'] as List);
  }

  Future<Map<String, dynamic>> getStandings({
    required String competitionCode,
  }) async {
    if (kIsWeb) {
      final res = await _dio.get(
        '/standings.php',
        queryParameters: {'competition': competitionCode},
      );
      return (res.data as Map<String, dynamic>);
    }

    final res = await _dio.get('/competitions/$competitionCode/standings');
    return (res.data as Map<String, dynamic>);
  }
}
