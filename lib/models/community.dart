class Community {
  final String id;
  final String communityName;
  final String description;
  final String location;
  final String? communityImage;
  final int createdAt;
  final int updatedAt;

  Community({
    required this.id,
    required this.communityName,
    required this.description,
    required this.location,
    this.communityImage,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create Community from Firebase JSON
  factory Community.fromJson(String id, Map<String, dynamic> json) {
    return Community(
      id: id,
      communityName: json['community_name'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      communityImage: json['community_image'],
      createdAt: json['created_at'] ?? 0,
      updatedAt: json['updated_at'] ?? 0,
    );
  }

  // Convert Community to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'community_name': communityName,
      'description': description,
      'location': location,
      'community_image': communityImage,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Helper method to get formatted creation date
  DateTime get createdDate => DateTime.fromMillisecondsSinceEpoch(createdAt);
  
  // Helper method to get formatted update date
  DateTime get updatedDate => DateTime.fromMillisecondsSinceEpoch(updatedAt);

  // Helper method to get formatted creation date string
  String get formattedCreatedDate {
    final date = createdDate;
    return '${date.day}/${date.month}/${date.year}';
  }

  // Helper method to get formatted update date string
  String get formattedUpdatedDate {
    final date = updatedDate;
    return '${date.day}/${date.month}/${date.year}';
  }

  // Copy with method for easy updates
  Community copyWith({
    String? id,
    String? communityName,
    String? description,
    String? location,
    String? communityImage,
    int? createdAt,
    int? updatedAt,
  }) {
    return Community(
      id: id ?? this.id,
      communityName: communityName ?? this.communityName,
      description: description ?? this.description,
      location: location ?? this.location,
      communityImage: communityImage ?? this.communityImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Community{id: $id, communityName: $communityName, description: $description, location: $location, communityImage: $communityImage, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Community &&
        other.id == id &&
        other.communityName == communityName &&
        other.description == description &&
        other.location == location &&
        other.communityImage == communityImage &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        communityName.hashCode ^
        description.hashCode ^
        location.hashCode ^
        communityImage.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}