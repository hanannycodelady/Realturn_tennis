import 'dart:convert';
import 'package:http/http.dart' as http;

class MixedDoublesService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  /// Get all mixed doubles pairs
  static Future<List<dynamic>> getMixedDoublesPairs() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/mixed-doubles'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load mixed doubles pairs: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching mixed doubles pairs: $e');
    }
  }

  /// Get mixed doubles rankings
  static Future<List<dynamic>> getMixedDoublesRankings() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/mixed-doubles/rankings'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load mixed doubles rankings: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching mixed doubles rankings: $e');
    }
  }

  /// Get mixed doubles pair details
  static Future<Map<String, dynamic>> getMixedDoublesPairDetails(int pairId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/mixed-doubles/$pairId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load mixed doubles pair details: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching mixed doubles pair details: $e');
    }
  }

  /// Get mixed doubles tournament history
  static Future<List<dynamic>> getMixedDoublesTournamentHistory(int pairId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/mixed-doubles/$pairId/tournaments'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load tournament history: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching tournament history: $e');
    }
  }

  /// Get mixed doubles statistics
  static Future<Map<String, dynamic>> getMixedDoublesStats(int pairId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/mixed-doubles/$pairId/statistics'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load mixed doubles statistics: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching mixed doubles statistics: $e');
    }
  }

  /// Get featured mixed doubles pairs
  static Future<List<dynamic>> getFeaturedMixedDoublesPairs() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/mixed-doubles/featured'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load featured pairs: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching featured pairs: $e');
    }
  }
}
