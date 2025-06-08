import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  /// Process Mobile Money donation
  static Future<Map<String, dynamic>> processMobileMoneyDonation({
    required String phoneNumber,
    required double amount,
    required String provider, // e.g., 'mpesa', 'airtel'
    String? donorName,
    String? message,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/donations/mobile-money'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'phone_number': phoneNumber,
          'amount': amount,
          'provider': provider,
          'donor_name': donorName,
          'message': message,
          'payment_method': 'mobile_money',
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to process mobile money donation: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error processing mobile money donation: $e');
    }
  }

  /// Process Credit Card donation
  static Future<Map<String, dynamic>> processCreditCardDonation({
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
    required double amount,
    required String cardHolderName,
    String? message,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/donations/credit-card'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'card_number': cardNumber,
          'expiry_month': expiryMonth,
          'expiry_year': expiryYear,
          'cvv': cvv,
          'amount': amount,
          'card_holder_name': cardHolderName,
          'message': message,
          'payment_method': 'credit_card',
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to process credit card donation: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error processing credit card donation: $e');
    }
  }

  /// Process PayPal donation
  static Future<Map<String, dynamic>> processPayPalDonation({
    required String paypalEmail,
    required double amount,
    String? donorName,
    String? message,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/donations/paypal'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'paypal_email': paypalEmail,
          'amount': amount,
          'donor_name': donorName,
          'message': message,
          'payment_method': 'paypal',
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to process PayPal donation: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error processing PayPal donation: $e');
    }
  }

  /// Get donation history by payment method
  static Future<List<dynamic>> getDonationHistory(String paymentMethod) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/donations/history/$paymentMethod'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load donation history: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching donation history: $e');
    }
  }

  /// Verify payment status
  static Future<Map<String, dynamic>> verifyPaymentStatus(String transactionId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/donations/verify/$transactionId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to verify payment: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error verifying payment: $e');
    }
  }
}
