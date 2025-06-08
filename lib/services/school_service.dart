import 'dart:convert';
import 'package:http/http.dart' as http;

class SchoolService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static Future<List<dynamic>> getSchools() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/schools'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load schools: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load schools: $e');
    }
  }
}
