import 'package:firebase_database/firebase_database.dart';
import 'package:realturn_app/models/community.dart';

class CommunityService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Get all communities
  Future<List<Community>> getAllCommunities() async {
    try {
      final snapshot = await _database.child('communities').get();
      
      if (snapshot.exists) {
        final communitiesData = snapshot.value as Map<dynamic, dynamic>;
        
        return communitiesData.entries.map((entry) {
          final id = entry.key as String;
          final data = Map<String, dynamic>.from(entry.value as Map);
          return Community.fromJson(id, data);
        }).toList();
      }
      
      return [];
    } catch (e) {
      print('Error fetching communities: $e');
      return [];
    }
  }

  // Get a specific community by ID
  Future<Community?> getCommunityById(String id) async {
    try {
      final snapshot = await _database.child('communities').child(id).get();
      
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return Community.fromJson(id, data);
      }
      
      return null;
    } catch (e) {
      print('Error fetching community: $e');
      return null;
    }
  }

  // Listen to communities changes (real-time updates)
  Stream<List<Community>> getCommunitiesStream() {
    return _database.child('communities').onValue.map((event) {
      if (event.snapshot.exists) {
        final communitiesData = event.snapshot.value as Map<dynamic, dynamic>;
        
        return communitiesData.entries.map((entry) {
          final id = entry.key as String;
          final data = Map<String, dynamic>.from(entry.value as Map);
          return Community.fromJson(id, data);
        }).toList();
      }
      
      return <Community>[];
    });
  }

  // Add a new community
  Future<String?> addCommunity(Community community) async {
    try {
      final newRef = _database.child('communities').push();
      await newRef.set(community.toJson());
      return newRef.key;
    } catch (e) {
      print('Error adding community: $e');
      return null;
    }
  }

  // Update an existing community
  Future<bool> updateCommunity(String id, Community community) async {
    try {
      await _database.child('communities').child(id).update(community.toJson());
      return true;
    } catch (e) {
      print('Error updating community: $e');
      return false;
    }
  }

  // Delete a community
  Future<bool> deleteCommunity(String id) async {
    try {
      await _database.child('communities').child(id).remove();
      return true;
    } catch (e) {
      print('Error deleting community: $e');
      return false;
    }
  }

  // Search communities by name or location
  Future<List<Community>> searchCommunities(String query) async {
    try {
      final communities = await getAllCommunities();
      
      return communities.where((community) {
        return community.communityName.toLowerCase().contains(query.toLowerCase()) ||
               community.location.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      print('Error searching communities: $e');
      return [];
    }
  }
}