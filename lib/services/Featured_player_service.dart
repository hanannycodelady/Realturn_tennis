import 'dart:convert';
import 'package:http/http.dart' as http;

class FeaturedPlayerService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  /// Get all featured players
  static Future<List<dynamic>> getFeaturedPlayers({String? gender}) async {
    try {
      String url = '$baseUrl/featured-players';
      if (gender != null) {
        url += '?gender=${Uri.encodeComponent(gender)}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load featured players: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching featured players: $e');
    }
  }

  /// Get featured player details
  static Future<Map<String, dynamic>> getFeaturedPlayerDetails(int playerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/featured-players/$playerId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load featured player details: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching featured player details: $e');
    }
  }

  /// Get featured player achievements
  static Future<List<dynamic>> getFeaturedPlayerAchievements(int playerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/featured-players/$playerId/achievements'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load featured player achievements: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching featured player achievements: $e');
    }
  }

  /// Get featured player media
  static Future<List<dynamic>> getFeaturedPlayerMedia(int playerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/featured-players/$playerId/media'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load featured player media: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching featured player media: $e');
    }
  }

  /// Get featured player interviews
  static Future<List<dynamic>> getFeaturedPlayerInterviews(int playerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/featured-players/$playerId/interviews'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load featured player interviews: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching featured player interviews: $e');
    }
  }
}
