import 'dart:convert';
import 'package:http/http.dart' as http;

class TicketService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  /// Get available tickets for an event
  static Future<List<dynamic>> getAvailableTickets(int eventId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/events/$eventId/tickets'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load available tickets: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching available tickets: $e');
    }
  }

  /// Purchase tickets
  static Future<Map<String, dynamic>> purchaseTickets({
    required int eventId,
    required List<Map<String, dynamic>> tickets,
    required Map<String, dynamic> customerInfo,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tickets/purchase'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'event_id': eventId,
          'tickets': tickets,
          'customer_info': customerInfo,
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to purchase tickets: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error purchasing tickets: $e');
    }
  }

  /// Get ticket details
  static Future<Map<String, dynamic>> getTicketDetails(String ticketId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tickets/$ticketId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load ticket details: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching ticket details: $e');
    }
  }

  /// Cancel ticket
  static Future<void> cancelTicket(String ticketId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tickets/$ticketId/cancel'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to cancel ticket: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error canceling ticket: $e');
    }
  }

  /// Get user's tickets
  static Future<List<dynamic>> getUserTickets() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/tickets'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load user tickets: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching user tickets: $e');
    }
  }

  /// Validate ticket
  static Future<Map<String, dynamic>> validateTicket(String ticketCode) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tickets/validate'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({'ticket_code': ticketCode}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to validate ticket: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error validating ticket: $e');
    }
  }
}
