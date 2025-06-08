import 'dart:convert';
import 'package:http/http.dart' as http;

class DoublesService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  /// Get all doubles pairs
  static Future<List<dynamic>> getDoublesPairs({String? category}) async {
    try {
      String url = '$baseUrl/doubles';
      if (category != null) {
        url += '?category=${Uri.encodeComponent(category)}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load doubles pairs: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching doubles pairs: $e');
    }
  }

  /// Get mixed doubles pairs
  static Future<List<dynamic>> getMixedDoublesPairs() async {
    return getDoublesPairs(category: 'mixed');
  }

  /// Get doubles rankings
  static Future<List<dynamic>> getDoublesRankings({String? category}) async {
    try {
      String url = '$baseUrl/doubles/rankings';
      if (category != null) {
        url += '?category=${Uri.encodeComponent(category)}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load doubles rankings: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching doubles rankings: $e');
    }
  }

  /// Get doubles pair details
  static Future<Map<String, dynamic>> getDoublesPairDetails(int pairId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/doubles/$pairId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load doubles pair details: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching doubles pair details: $e');
    }
  }
}
