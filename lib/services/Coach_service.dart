import 'dart:convert';
import 'package:http/http.dart' as http;

class CoachService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  /// Get all coaches
  static Future<List<dynamic>> getCoaches() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/coaches'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load coaches: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching coaches: $e');
    }
  }

  /// Get coach details and bio
  static Future<Map<String, dynamic>> getCoachDetails(int coachId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/coaches/$coachId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load coach details: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching coach details: $e');
    }
  }
}
