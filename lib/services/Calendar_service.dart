import 'dart:convert';
import 'package:http/http.dart' as http;

class CalendarService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  /// Get all calendar events
  static Future<List<dynamic>> getCalendarEvents({
    String? startDate,
    String? endDate,
    String? eventType,
  }) async {
    try {
      String url = '$baseUrl/calendar';
      List<String> queryParams = [];

      if (startDate != null) {
        queryParams.add('start_date=$startDate');
      }
      if (endDate != null) {
        queryParams.add('end_date=$endDate');
      }
      if (eventType != null) {
        queryParams.add('event_type=$eventType');
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
        throw Exception('Failed to load calendar events: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching calendar events: $e');
    }
  }

  /// Get upcoming events
  static Future<List<dynamic>> getUpcomingEvents({int? limit}) async {
    try {
      String url = '$baseUrl/calendar/upcoming';
      if (limit != null) {
        url += '?limit=$limit';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load upcoming events: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching upcoming events: $e');
    }
  }

  /// Get event details
  static Future<Map<String, dynamic>> getEventDetails(int eventId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/calendar/events/$eventId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load event details: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching event details: $e');
    }
  }

  /// Get events by category
  static Future<List<dynamic>> getEventsByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/calendar/category/$category'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load events by category: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching events by category: $e');
    }
  }

  /// Register for an event
  static Future<void> registerForEvent(int eventId, Map<String, dynamic> registrationData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/calendar/events/$eventId/register'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(registrationData),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to register for event: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error registering for event: $e');
    }
  }
}
