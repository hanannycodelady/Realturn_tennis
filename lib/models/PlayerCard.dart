class PlayerCard {
  final String firstName;
  final String lastName;
  final String? height;
  final String? age;
  final String? birthDate;
  final String? plays;
  final String? birthplace;
  final String? coach;
  final String? image; // Maps to playerImage from API
  final String? title;
  final String? details;
  final String? country;
  final int? ranking;
  final int? points;
  final String flagUrl; // Maps to flagUrl from API
  final String nationality;
  final String? gender;

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
    required this.flagUrl,
    required this.nationality,
    this.gender,
  });

  String get fullName => '$firstName $lastName';
  String? get coachName => coach;
  String? get playerImage => image;

  /// Convert JSON into a `PlayerCard` object based on the API response.
  factory PlayerCard.fromJson(Map<String, dynamic> json) {
    const String baseUrl = 'http://127.0.0.1:8000'; // Replace with actual base URL

    return PlayerCard(
      firstName: json['first_name'] ?? '',
      lastName: json['second_name'] ?? '',
      height: json['height'],
      age: json['age'],
      birthDate: json['birth_date'],
      plays: json['plays'],
      birthplace: json['birthplace'],
      coach: json['coach'],
      image: json['player_image'] != null
          ? '$baseUrl/storage/${json['player_image']}'
          : null,
      title: json['title'],
      details: json['details'],
      country: json['nationality'] ?? json['country'],
      ranking: json['ranking'] != null ? int.tryParse(json['ranking'].toString()) : null,
      points: json['points'] != null ? int.tryParse(json['points'].toString()) : null,
      flagUrl: json['flag_image'] != null
          ? '$baseUrl/storage/${json['flag_image']}'
          : '', // default to empty string if null
      nationality: json['nationality'] ?? '',
      gender: json['gender'] ?? 'unknown',
    );
  }

  /// Convert Firebase JSON into a `PlayerCard` object
  factory PlayerCard.fromFirebaseJson(Map<String, dynamic> json) {
    return PlayerCard(
      firstName: json['first_name'] ?? '',
      lastName: json['second_name'] ?? '',
      height: json['height']?.toString(),
      age: json['age']?.toString(),
      birthDate: json['date_of_birth'],
      plays: json['plays'],
      birthplace: json['birthplace'],
      coach: json['coach_name'],
      image: json['player_image'],
      title: json['title'],
      details: json['details'],
      country: json['nationality'],
      ranking: json['ranking'] != null ? int.tryParse(json['ranking'].toString()) : null,
      points: json['points'] != null ? double.tryParse(json['points'].toString())?.toInt() : null,
      flagUrl: json['flag_image'] ?? '',
      nationality: json['nationality'] ?? '',
      gender: json['gender'],
    );
  }

  /// Convert a list of JSON objects into a list of `PlayerCard` objects.
  static List<PlayerCard> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PlayerCard.fromJson(json)).toList();
  }

  /// Convert a list of Firebase JSON objects into a list of `PlayerCard` objects.
  static List<PlayerCard> fromFirebaseJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PlayerCard.fromFirebaseJson(json)).toList();
  }

  /// Convert PlayerCard to Map for Firebase
  Map<String, dynamic> toFirebaseJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'height': height,
      'age': age,
      'birthDate': birthDate,
      'plays': plays,
      'birthplace': birthplace,
      'coach': coach,
      'image': image,
      'title': title,
      'details': details,
      'country': country,
      'ranking': ranking,
      'points': points,
      'flagUrl': flagUrl,
      'nationality': nationality,
      'gender': gender,
    };
  }
}