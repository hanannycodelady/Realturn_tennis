import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart'; // ADD THIS

class AuthService {
  final SharedPreferences _prefs;
  late final Dio _dio;
  final DatabaseReference _database = FirebaseDatabase.instance.ref(); // ADD THIS

  // Success messages
  static const String registerSuccess = 'Registration successful';
  static const String loginSuccess = 'Login successful';
  static const String logoutSuccess = 'Logged out successfully';
  static const String passwordResetSuccess = 'Password reset successful';

  // Error messages
  static const String networkError = 'Network error. Please check your connection.';
  static const String unexpectedError = 'An unexpected error occurred. Please try again.';
  static const String validationError = 'Validation failed';
  static const String invalidCredentials = 'Invalid credentials';

  // Base URL - Configured for local development
  final String _baseUrl = 'http://127.0.0.1:8000/api';

  AuthService(this._prefs) {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        //'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));

    // Add interceptors for logging and error handling
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add auth token if available
        final token = getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          // Token expired - attempt refresh if implemented
          await logout();
        }
        return handler.next(e);
      },
    ));

    // Add logger interceptor in debug mode
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: false,
      error: true,
    ));
  }

  // Client-side validation for registration
  Map<String, String>? validateRegisterData({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String contact,
  }) {
    final errors = <String, String>{};

    // First name validation
    if (firstName.isEmpty) {
      errors['first_name'] = 'First name is required';
    } else if (firstName.length < 2 || firstName.length > 255) {
      errors['first_name'] = 'First name must be between 2 and 255 characters';
    } else if (!RegExp(r'^[\p{L}\s-]+$', unicode: true).hasMatch(firstName)) {
      errors['first_name'] = 'First name can only contain letters, spaces, and hyphens';
    }

    // Last name validation
    if (lastName.isEmpty) {
      errors['last_name'] = 'Last name is required';
    } else if (lastName.length < 2 || lastName.length > 255) {
      errors['last_name'] = 'Last name must be between 2 and 255 characters';
    } else if (!RegExp(r'^[\p{L}\s-]+$', unicode: true).hasMatch(lastName)) {
      errors['last_name'] = 'Last name can only contain letters, spaces, and hyphens';
    }

    // Email validation
    if (email.isEmpty) {
      errors['email'] = 'Email address is required';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      errors['email'] = 'Invalid email format';
    }

    // Password validation
    if (password.isEmpty) {
      errors['password'] = 'Password is required';
    } else if (password.length < 6) {
      errors['password'] = 'Password must be at least 6 characters';
    }

    // Contact validation
    if (contact.isEmpty) {
      errors['contact'] = 'Contact number is required';
    } else {
      final digitsOnly = contact.replaceAll(RegExp(r'[^0-9+]'), '');
      
      // Validate international format
      if (!RegExp(r'^\+?\d{9,15}$').hasMatch(digitsOnly)) {
        errors['contact'] = 'Enter valid phone number (9-15 digits)';
      }
    }

    return errors.isEmpty ? null : errors;
  }

  // Register a new user
  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String contact,
  }) async {
    final validationErrors = validateRegisterData(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      contact: contact,
    );

    if (validationErrors != null) {
      return {
        'success': false,
        'message': validationError,
        'errors': validationErrors,
      };
    }

    try {
      final response = await _dio.post(
        '/register',
        data: {
          'First_name': firstName,
          'Last_name': lastName,
          'Email_address': email,
          'Password': password,
          'Contact': contact
        },
      );

      final responseData = response.data;

      if (response.statusCode == 201) {
        await _saveUserData(responseData);
        
        // ADD THIS: Save to Firebase after successful Laravel registration
        await _saveUserToFirebase(
          firstName: firstName,
          lastName: lastName,
          email: email,
          contact: contact,
          laravelUserId: responseData['user']?['id']?.toString(),
        );
        
        return {
          'success': true,
          'message': registerSuccess,
          'data': responseData,
        };
      } else if (response.statusCode == 422) {
        return _parseValidationErrors(response.data);
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Registration failed',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'message': unexpectedError,
      };
    }
  }

  // ADD THIS: New method to save user to Firebase
  Future<void> _saveUserToFirebase({
    required String firstName,
    required String lastName,
    required String email,
    required String contact,
    String? laravelUserId,
  }) async {
    try {
      // Use Laravel user ID as Firebase key if available, otherwise generate new key
      String firebaseUserId;
      if (laravelUserId != null && laravelUserId.isNotEmpty) {
        firebaseUserId = 'user_$laravelUserId'; // Prefix to ensure valid Firebase key
      } else {
        firebaseUserId = _database.child('users').push().key!;
      }
      
      // Prepare user data for Firebase
      Map<String, dynamic> firebaseUserData = {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'contact': contact,
        'laravelUserId': laravelUserId,
        'createdAt': ServerValue.timestamp,
        'updatedAt': ServerValue.timestamp,
        'platform': 'mobile_app',
      };

      // Save to Firebase Realtime Database under 'users' reference
      await _database.child('users').child(firebaseUserId).set(firebaseUserData);
      
      // Optionally save Firebase user ID to SharedPreferences for future use
      await _prefs.setString('firebase_user_id', firebaseUserId);
      
      print('User successfully saved to Firebase with ID: $firebaseUserId');
      
    } catch (e) {
      // Log the error but don't fail the registration process
      print('Error saving user to Firebase: $e');
      // You could also log this to a crash reporting service like Firebase Crashlytics
    }
  }

  // Client-side validation for login
  Map<String, String>? validateLoginData({
    required String email,
    required String password,
  }) {
    final errors = <String, String>{};

    if (email.isEmpty) {
      errors['email'] = 'Email address is required';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      errors['email'] = 'Invalid email format';
    }

    if (password.isEmpty) {
      errors['password'] = 'Password is required';
    }

    return errors.isEmpty ? null : errors;
  }

  // Login user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final validationErrors = validateLoginData(
      email: email,
      password: password,
    );

    if (validationErrors != null) {
      return {
        'success': false,
        'message': validationError,
        'errors': validationErrors,
      };
    }

    try {
      final response = await _dio.post(
        '/login',
        data: {
          'Email_address': email,
          'Password': password,
        },
      );

      final responseData = response.data;

      if (response.statusCode == 200) {
        await _saveUserData(responseData);
        return {
          'success': true,
          'message': loginSuccess,
          'data': responseData,
        };
      } else if (response.statusCode == 422) {
        return _parseValidationErrors(response.data);
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? invalidCredentials,
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'message': unexpectedError,
      };
    }
  }

  // Save user data to SharedPreferences
  Future<void> _saveUserData(Map<String, dynamic> data) async {
    try {
      if (data.containsKey('token')) {
        await _prefs.setString('auth_token', data['token']);
      }

      if (data.containsKey('user')) {
        final userData = data['user'];
        if (userData is Map<String, dynamic>) {
          await _prefs.setString('user_data', jsonEncode(userData));
          
          // Set individual fields for quick access
          await _prefs.setString('first_name', userData['first_name'] ?? '');
          await _prefs.setString('last_name', userData['last_name'] ?? '');
          await _prefs.setString('email', userData['email'] ?? '');
          await _prefs.setString('contact', userData['contact'] ?? '');
          await _prefs.setInt('user_id', userData['id'] ?? 0);
        }
      }
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _prefs.containsKey('auth_token');
  }

  // Get auth token
  String? getToken() {
    return _prefs.getString('auth_token');
  }

  // Get user data
  Map<String, dynamic>? getUserData() {
    try {
      final userDataString = _prefs.getString('user_data');
      if (userDataString != null) {
        return jsonDecode(userDataString) as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error parsing user data: $e');
    }
    return null;
  }

  // Get user's full name
  String getFullName() {
    final firstName = _prefs.getString('first_name') ?? '';
    final lastName = _prefs.getString('last_name') ?? '';
    return '$firstName $lastName'.trim();
  }

  // Get user email
  String getEmail() {
    return _prefs.getString('email') ?? '';
  }

  // Get user contact
  String getContact() {
    return _prefs.getString('contact') ?? '';
  }

  // Get user ID
  int getUserId() {
    return _prefs.getInt('user_id') ?? 0;
  }

  // ADD THIS: Get Firebase user ID
  String? getFirebaseUserId() {
    return _prefs.getString('firebase_user_id');
  }

  // Logout user
  Future<Map<String, dynamic>> logout() async {
    try {
      final token = getToken();
      if (token != null) {
        await _dio.post(
          '/logout',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
      }

      await _clearUserData();
      return {
        'success': true,
        'message': logoutSuccess,
      };
    } on DioException catch (e) {
      // Even if logout API fails, clear local data
      await _clearUserData();
      return _handleDioError(e);
    } catch (e) {
      await _clearUserData();
      return {
        'success': false,
        'message': unexpectedError,
      };
    }
  }

  // Clear user data from SharedPreferences
  Future<void> _clearUserData() async {
    await _prefs.remove('auth_token');
    await _prefs.remove('user_data');
    await _prefs.remove('first_name');
    await _prefs.remove('last_name');
    await _prefs.remove('email');
    await _prefs.remove('contact');
    await _prefs.remove('user_id');
    await _prefs.remove('firebase_user_id'); // ADD THIS
  }

  // Request password reset link
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final validationErrors = validateLoginData(email: email, password: 'dummy');
    
    if (validationErrors != null && validationErrors.containsKey('email')) {
      return {
        'success': false,
        'message': validationErrors['email']!,
      };
    }

    try {
      final response = await _dio.post(
        '/forgot-password',
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Password reset link sent to your email',
        };
      } else if (response.statusCode == 422) {
        return _parseValidationErrors(response.data);
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to send reset link',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'message': unexpectedError,
      };
    }
  }

  // Reset password with token
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String password,
    required String passwordConfirmation,
    required String token,
  }) async {
    if (password != passwordConfirmation) {
      return {
        'success': false,
        'message': 'Passwords do not match',
      };
    }

    try {
      final response = await _dio.post(
        '/reset-password',
        data: {
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'token': token,
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': passwordResetSuccess,
        };
      } else if (response.statusCode == 422) {
        return _parseValidationErrors(response.data);
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to reset password',
        };
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'message': unexpectedError,
      };
    }
  }

  // Helper method to handle Dio errors
  Map<String, dynamic> _handleDioError(DioException e) {
    if (e.response != null) {
      // Handle validation errors
      if (e.response?.statusCode == 422) {
        return _parseValidationErrors(e.response!.data);
      }

      // Handle other API errors
      final responseData = e.response!.data;
      if (responseData is Map && responseData.containsKey('message')) {
        return {
          'success': false,
          'message': responseData['message'],
        };
      }
    }

    // Handle network errors
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      return {
        'success': false,
        'message': networkError,
      };
    }

    // Default error
    return {
      'success': false,
      'message': e.message ?? unexpectedError,
    };
  }

  // Helper method to parse validation errors
  Map<String, dynamic> _parseValidationErrors(Map<String, dynamic> responseData) {
    final errors = <String, List<String>>{};
    final errorMessages = <String>[];

    if (responseData['errors'] != null) {
      final errorMap = responseData['errors'] as Map<String, dynamic>;
      errorMap.forEach((key, value) {
        if (value is List) {
          errors[key] = value.map((e) => e.toString()).toList();
          errorMessages.addAll(value.map((e) => '$key: $e'));
        } else if (value is String) {
          errors[key] = [value];
          errorMessages.add('$key: $value');
        }
      });
    }

    return {
      'success': false,
      'message': responseData['message'] ?? validationError,
      'errors': errors,
      'errorMessages': errorMessages,
    };
  }
}