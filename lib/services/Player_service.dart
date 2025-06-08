import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:realturn_app/models/PlayerCard.dart';

class PlayerService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  /// Get all players with optional gender filter
  static Future<List<PlayerCard>> getPlayers({String? gender}) async {
    try {
      String url = '$baseUrl/players';
      if (gender != null) {
        url += '?gender=${Uri.encodeComponent(gender)}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'] ?? jsonResponse;
        return PlayerCard.fromJsonList(data);
      } else {
        throw Exception('Failed to load players: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching players: $e');
    }
  }

  static Future<List<PlayerCard>> getFemalePlayers() async {
    return getPlayers(gender: 'female');
  }

  static Future<List<PlayerCard>> getMalePlayers() async {
    return getPlayers(gender: 'male');
  }

  /// Get a specific player by ID
  static Future<PlayerCard> getPlayer(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/players/$id'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return PlayerCard.fromJson(jsonResponse['data'] ?? jsonResponse);
      } else {
        throw Exception('Failed to load player: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching player: $e');
    }
  }

  /// Search players by name or nationality
  static Future<List<PlayerCard>> searchPlayers(String query, {String? gender}) async {
    try {
      String url = '$baseUrl/players/search?query=${Uri.encodeComponent(query)}';
      if (gender != null) {
        url += '&gender=${Uri.encodeComponent(gender)}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'] ?? jsonResponse;
        return PlayerCard.fromJsonList(data);
      } else {
        throw Exception('Failed to search players: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error searching players: $e');
    }
  }

  /// Get top ranked players (limited to a specific count)
  static Future<List<PlayerCard>> getTopPlayers({int count = 10, String? gender}) async {
    try {
      List<PlayerCard> players = await getPlayers(gender: gender);

      // Use .take(count).toList() to avoid errors
      return players.take(count).toList();
    } catch (e) {
      throw Exception('Error fetching top players: $e');
    }
  }

  /// Get player statistics
  static Future<Map<String, dynamic>> getPlayerStats(int playerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/players/$playerId/stats'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load player stats: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching player stats: $e');
    }
  }

  /// Get player matches history
  static Future<List<dynamic>> getPlayerMatches(int playerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/players/$playerId/matches'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load player matches: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching player matches: $e');
    }
  }

  /// Get player tournaments
  static Future<List<dynamic>> getPlayerTournaments(int playerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/players/$playerId/tournaments'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load player tournaments: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching player tournaments: $e');
    }
  }

  /// Create a new player
  static Future<PlayerCard> createPlayer(Map<String, dynamic> playerData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/players'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(playerData),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return PlayerCard.fromJson(jsonResponse['data']);
      } else {
        throw Exception('Failed to create player: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating player: $e');
    }
  }

  /// Create a new player with image
  static Future<PlayerCard> createPlayerWithImage(Map<String, dynamic> playerData, String imagePath) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/players'));
      
      // Add player data
      request.fields.addAll(
        playerData.map((key, value) => MapEntry(key, value.toString()))
      );

      // Add image file
      if (imagePath.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath('playerImage', imagePath)
        );
      }

      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
      });

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return PlayerCard.fromJson(jsonResponse['data']);
      } else {
        throw Exception('Failed to create player: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating player: $e');
    }
  }

  /// Get player bio data
  static Future<Map<String, dynamic>> getPlayerBio(int playerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/players/$playerId/bio'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      } else {
        throw Exception('Failed to load player bio: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching player bio: $e');
    }
  }

  /// Get player matches with pagination
  static Future<List<dynamic>> getPlayerMatchesWithPagination(int playerId, {int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/players/$playerId/matches?page=$page'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load player matches: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching player matches: $e');
    }
  }

  /// Get player statistics including win/loss records
  static Future<Map<String, dynamic>> getPlayerStatistics(int playerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/players/$playerId/statistics'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      } else {
        throw Exception('Failed to load player statistics: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching player statistics: $e');
    }
  }

  /// Get player rankings history
  static Future<List<dynamic>> getPlayerRankingsHistory(int playerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/players/$playerId/rankings'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      } else {
        throw Exception('Failed to load player rankings: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching player rankings: $e');
    }
  }
}
