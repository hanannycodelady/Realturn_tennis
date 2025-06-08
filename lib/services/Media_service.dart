import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class MediaService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  /// Upload video
  static Future<Map<String, dynamic>> uploadVideo({
    required File videoFile,
    required String title,
    required String description,
    required String category,
    String? playerId,
    String? tournamentId,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl/media/videos');
      var request = http.MultipartRequest('POST', uri);

      // Add video file
      var videoStream = http.ByteStream(videoFile.openRead());
      var length = await videoFile.length();
      var multipartFile = http.MultipartFile(
        'video',
        videoStream,
        length,
        filename: videoFile.path.split('/').last,
        contentType: MediaType('video', 'mp4'),
      );
      request.files.add(multipartFile);

      // Add other fields
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['category'] = category;
      if (playerId != null) request.fields['player_id'] = playerId;
      if (tournamentId != null) request.fields['tournament_id'] = tournamentId;

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        return json.decode(responseData)['data'];
      } else {
        throw Exception('Failed to upload video: $responseData');
      }
    } catch (e) {
      throw Exception('Error uploading video: $e');
    }
  }

  /// Upload gallery image
  static Future<Map<String, dynamic>> uploadGalleryImage({
    required File imageFile,
    required String title,
    String? description,
    String? category,
    String? playerId,
    String? tournamentId,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl/media/gallery');
      var request = http.MultipartRequest('POST', uri);

      // Add image file
      var imageStream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile(
        'image',
        imageStream,
        length,
        filename: imageFile.path.split('/').last,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);

      // Add other fields
      request.fields['title'] = title;
      if (description != null) request.fields['description'] = description;
      if (category != null) request.fields['category'] = category;
      if (playerId != null) request.fields['player_id'] = playerId;
      if (tournamentId != null) request.fields['tournament_id'] = tournamentId;

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        return json.decode(responseData)['data'];
      } else {
        throw Exception('Failed to upload image: $responseData');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  /// Get videos by category
  static Future<List<dynamic>> getVideos({
    String? category,
    String? playerId,
    String? tournamentId,
  }) async {
    try {
      String url = '$baseUrl/media/videos';
      List<String> queryParams = [];

      if (category != null) {
        queryParams.add('category=${Uri.encodeComponent(category)}');
      }
      if (playerId != null) {
        queryParams.add('player_id=$playerId');
      }
      if (tournamentId != null) {
        queryParams.add('tournament_id=$tournamentId');
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
        throw Exception('Failed to load videos: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching videos: $e');
    }
  }

  /// Get gallery images
  static Future<List<dynamic>> getGalleryImages({
    String? category,
    String? playerId,
    String? tournamentId,
  }) async {
    try {
      String url = '$baseUrl/media/gallery';
      List<String> queryParams = [];

      if (category != null) {
        queryParams.add('category=${Uri.encodeComponent(category)}');
      }
      if (playerId != null) {
        queryParams.add('player_id=$playerId');
      }
      if (tournamentId != null) {
        queryParams.add('tournament_id=$tournamentId');
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
        throw Exception('Failed to load gallery images: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching gallery images: $e');
    }
  }

  /// Delete media item
  static Future<void> deleteMediaItem(String mediaId, String type) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/media/$type/$mediaId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete media item: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting media item: $e');
    }
  }

  /// Update media item details
  static Future<Map<String, dynamic>> updateMediaDetails(
    String mediaId,
    String type,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/media/$type/$mediaId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(updates),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to update media details: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating media details: $e');
    }
  }
}
