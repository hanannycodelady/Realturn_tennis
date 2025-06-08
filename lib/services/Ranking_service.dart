import 'dart:convert';
import 'package:http/http.dart' as http;

class RankingService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  /// Get overall rankings
  static Future<List<dynamic>> getOverallRankings({
    String? category,
    String? gender,
  }) async {
    try {
      String url = '$baseUrl/rankings';
      List<String> queryParams = [];

      if (category != null) {
        queryParams.add('category=${Uri.encodeComponent(category)}');
      }
      if (gender != null) {
        queryParams.add('gender=${Uri.encodeComponent(gender)}');
      }

      if (queryParams.isNotEmpty) {
        url += '?${queryParams.join('&')}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load rankings: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching rankings: $e');
    }
  }

  /// Get player ranking history
  static Future<List<dynamic>> getPlayerRankingHistory(int playerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/rankings/player/$playerId/history'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load player ranking history: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching player ranking history: $e');
    }
  }

  /// Get rankings by tournament
  static Future<List<dynamic>> getTournamentRankings(int tournamentId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/rankings/tournament/$tournamentId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load tournament rankings: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching tournament rankings: $e');
    }
  }

  /// Get rankings by age group
  static Future<List<dynamic>> getAgeGroupRankings(String ageGroup) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/rankings/age-group/$ageGroup'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load age group rankings: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching age group rankings: $e');
    }
  }

  /// Get school rankings
  static Future<List<dynamic>> getSchoolRankings() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/rankings/schools'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load school rankings: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching school rankings: $e');
    }
  }
}
