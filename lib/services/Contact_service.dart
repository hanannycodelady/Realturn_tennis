import 'dart:convert';
import 'package:http/http.dart' as http;

class ContactService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  /// Submit contact form
  static Future<void> submitContactForm({
    required String name,
    required String email,
    required String subject,
    required String message,
    String? phone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/contact'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
          'email': email,
          'subject': subject,
          'message': message,
          if (phone != null) 'phone': phone,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to submit contact form: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error submitting contact form: $e');
    }
  }

  /// Get contact information
  static Future<Map<String, dynamic>> getContactInfo() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/contact-info'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load contact information: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching contact information: $e');
    }
  }

  /// Get FAQ list
  static Future<List<dynamic>> getFAQs() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/faqs'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load FAQs: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching FAQs: $e');
    }
  }
}
