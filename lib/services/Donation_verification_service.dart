import 'dart:convert';
import 'package:http/http.dart' as http;

class DonationVerificationService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  /// Request email verification code for donation
  static Future<Map<String, dynamic>> requestVerificationCode({
    required String email,
    required String paymentMethod,
    required double amount,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/donations/request-code'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'payment_method': paymentMethod,
          'amount': amount,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to request verification code: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error requesting verification code: $e');
    }
  }

  /// Verify donation code
  static Future<Map<String, dynamic>> verifyDonationCode({
    required String transactionId,
    required String verificationCode,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/donations/verify-code'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'transaction_id': transactionId,
          'verification_code': verificationCode,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to verify code: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error verifying code: $e');
    }
  }

  /// Resend verification code
  static Future<void> resendVerificationCode({
    required String transactionId,
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/donations/resend-code'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'transaction_id': transactionId,
          'email': email,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to resend verification code: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error resending verification code: $e');
    }
  }

  /// Check verification code status
  static Future<Map<String, dynamic>> checkVerificationStatus(
    String transactionId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/donations/verification-status/$transactionId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to check verification status: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error checking verification status: $e');
    }
  }
}
