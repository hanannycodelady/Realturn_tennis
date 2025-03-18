
class PlayerCard {
  final String firstName; // For bio screen
  final String lastName;  // For bio screen
  final String? height;   // For bio screen
  final String? age;      // For bio screen
  final String? birthDate;// For bio screen
  final String? plays;    // For bio screen
  final String? birthplace;// For bio screen
  final String? coach;    // For bio screen
  final String? image;    // For female players
  final String? title;    // For female players
  final String? details;  // For female players
  final String? country;  // For male players
  final int? ranking;     // For male players
  final int? points;      // For male players

  PlayerCard({
    required this.firstName,
    required this.lastName,
    this.height,
    this.age,
    this.birthDate,
    this.plays,
    this.birthplace,
    this.coach,
    this.image,
    this.title,
    this.details,
    this.country,
    this.ranking,
    this.points,
  });

  String get fullName => '$firstName $lastName';

  get name => null;
}