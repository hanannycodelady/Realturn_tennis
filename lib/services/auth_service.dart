import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final SharedPreferences _prefs;
  late final Dio _dio;
  
  // Base URL - Configured for Android emulator
  final String _baseUrl = 'http://127.0.0.1:8000/api'; 
  
  AuthService(this._prefs) {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));
    
    // Add logging interceptor for debugging
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  // Register a new user
  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String contact,
  }) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {
          'First_name': firstName,
          'Last_name': lastName,
          'Email_address': email,
          'Password': password,
          'Contact': contact,
        },
      );
      
      final responseData = response.data;
      
      // Check if registration was successful
      if (response.statusCode == 201 && responseData['success'] == true) {
        // Store user data and token
        await _saveUserData(responseData);
        return {
          'success': true,
          'message': responseData['message'] ?? 'Registration successful',
        };
      } else if (response.statusCode == 422) {
        // Validation errors
        List<String> errorMessages = [];
        if (responseData['errors'] != null) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          errors.forEach((key, value) {
            if (value is List) {
              errorMessages.addAll(value.map((e) => e.toString()));
            }
          });
        }
        
        return {
          'success': false,
          'message': responseData['message'] ?? 'Validation failed',
          'errorMessages': errorMessages,
        };
      } else {
        // Other errors
        return {
          'success': false,
          'message': responseData['message'] ?? 'Registration failed',
        };
      }
    } on DioException catch (e) {
      print('Registration Error: ${e.message}');
      print('*** Request ***');
      print('uri: ${e.requestOptions.uri}');
      print('method: ${e.requestOptions.method}');
      print('responseType: ${e.requestOptions.responseType}');
      print('followRedirects: ${e.requestOptions.followRedirects}');
      print('persistentConnection: ${e.requestOptions.persistentConnection}');
      print('connectTimeout: ${e.requestOptions.connectTimeout}');
      print('sendTimeout: ${e.requestOptions.sendTimeout}');
      print('receiveTimeout: ${e.requestOptions.receiveTimeout}');
      print('receiveDataWhenStatusError: ${e.requestOptions.receiveDataWhenStatusError}');
      print('extra: ${e.requestOptions.extra}');
      print('headers:');
      e.requestOptions.headers.forEach((key, value) {
        print(' $key: $value');
      });
      print('data:');
      print(e.requestOptions.data);
      
      if (e.response != null) {
        print('*** Response ***');
        print('statusCode: ${e.response!.statusCode}');
        print('data: ${e.response!.data}');
      } else {
        print('*** DioException ***:');
        print('uri: ${e.requestOptions.uri}');
        print('DioException [${e.type}]: ${e.message}');
      }
      
      String errorMessage = 'Network error. Please check your connection.';
      
      if (e.response != null) {
        // We have a response from the server with an error
        final responseData = e.response!.data;
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Cannot connect to the server. Please check server is running.';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout. Please try again.';
      }
      
      return {
        'success': false,
        'message': errorMessage,
      };
    } catch (e) {
      print('Registration Error: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.',
      };
    }
  }

  // Login user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'Email_address': email,
          'Password': password,
        },
      );
      
      final responseData = response.data;
      
      // Check if login was successful
      if (response.statusCode == 200 && responseData['success'] == true) {
        // Store user data and token
        await _saveUserData(responseData);
        return {
          'success': true,
          'message': responseData['message'] ?? 'Login successful',
        };
      } else {
        // Login failed
        return {
          'success': false,
          'message': responseData['message'] ?? 'Invalid credentials',
        };
      }
    } on DioException catch (e) {
      print('Login Error: ${e.message}');
      
      String errorMessage = 'Network error. Please check your connection.';
      
      if (e.response != null) {
        // We have a response from the server with an error
        final responseData = e.response!.data;
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
      }
      
      return {
        'success': false,
        'message': errorMessage,
      };
    } catch (e) {
      print('Login Error: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.',
      };
    }
  }

  // Save user data to SharedPreferences
  Future<void> _saveUserData(Map<String, dynamic> data) async {
    if (data.containsKey('token')) {
      await _prefs.setString('auth_token', data['token']);
    }
    
    if (data.containsKey('user')) {
      final userData = data['user'];
      if (userData is Map<String, dynamic>) {
        await _prefs.setString('user_data', jsonEncode(userData));
        
        // For convenience, also store individual fields
        if (userData.containsKey('First_name')) {
          await _prefs.setString('first_name', userData['First_name']);
        }
        if (userData.containsKey('Last_name')) {
          await _prefs.setString('last_name', userData['Last_name']);
        }
        if (userData.containsKey('Email_address')) {
          await _prefs.setString('email', userData['Email_address']);
        }
        if (userData.containsKey('Contact')) {
          await _prefs.setString('contact', userData['Contact']);
        }
        if (userData.containsKey('id')) {
          await _prefs.setInt('user_id', userData['id']);
        }
      }
    }
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _prefs.containsKey('auth_token');
  }

  // Get current user token
  String? getToken() {
    return _prefs.getString('auth_token');
  }

  // Get current user data
  Map<String, dynamic>? getUserData() {
    final userDataString = _prefs.getString('user_data');
    if (userDataString != null) {
      return jsonDecode(userDataString) as Map<String, dynamic>;
    }
    return null;
  }

  // Get user's full name
  String getFullName() {
    final firstName = _prefs.getString('first_name') ?? '';
    final lastName = _prefs.getString('last_name') ?? '';
    return '$firstName $lastName'.trim();
  }

  // Logout user
  Future<void> logout() async {
    try {
      final token = getToken();
      if (token != null) {
        // Call logout API endpoint if needed
        await _dio.post(
          '/logout',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );
      }
    } catch (e) {
      print('Logout API error: $e');
    } finally {
      // Clear stored preferences
      await _prefs.remove('auth_token');
      await _prefs.remove('user_data');
      await _prefs.remove('first_name');
      await _prefs.remove('last_name');
      await _prefs.remove('email');
      await _prefs.remove('contact');
      await _prefs.remove('user_id');
    }
  }
}