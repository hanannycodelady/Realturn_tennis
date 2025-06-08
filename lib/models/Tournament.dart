class Tournament {
  final String id;
  final String name;
  final String location;
  final String venue;
  final String category;
  final String surface;
  final String startDate;
  final String endDate;
  final int month;
  final String year;
  final String status;
  final String sponsorName;
  final String tournamentDirector;
  final String prizeMoney;
  final String prizeMoneyCurrency;
  final int drawSize;
  final String certificate;
  final String tournamentLogo;
  final String createdAt;
  final String updatedAt;

  Tournament({
    required this.id,
    required this.name,
    required this.location,
    required this.venue,
    required this.category,
    required this.surface,
    required this.startDate,
    required this.endDate,
    required this.month,
    required this.year,
    required this.status,
    required this.sponsorName,
    required this.tournamentDirector,
    required this.prizeMoney,
    required this.prizeMoneyCurrency,
    required this.drawSize,
    required this.certificate,
    required this.tournamentLogo,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create Tournament from Firebase data
  factory Tournament.fromMap(Map<dynamic, dynamic> map) {
    return Tournament(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      location: map['location']?.toString() ?? '',
      venue: map['venue']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      surface: map['surface']?.toString() ?? '',
      startDate: map['startDate']?.toString() ?? '',
      endDate: map['endDate']?.toString() ?? '',
      month: map['month'] is int ? map['month'] : int.tryParse(map['month']?.toString() ?? '0') ?? 0,
      year: map['year']?.toString() ?? '',
      status: map['status']?.toString() ?? '',
      sponsorName: map['sponsorName']?.toString() ?? '',
      tournamentDirector: map['tournamentDirector']?.toString() ?? '',
      prizeMoney: map['prizeMoney']?.toString() ?? '0',
      prizeMoneyCurrency: map['prizeMoneyCurrency']?.toString() ?? 'USD',
      drawSize: map['drawSize'] is int ? map['drawSize'] : int.tryParse(map['drawSize']?.toString() ?? '0') ?? 0,
      certificate: map['certificate']?.toString() ?? 'no',
      tournamentLogo: map['tournamentLogo']?.toString() ?? '',
      createdAt: map['createdAt']?.toString() ?? '',
      updatedAt: map['updatedAt']?.toString() ?? '',
    );
  }

  // Convert Tournament to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'venue': venue,
      'category': category,
      'surface': surface,
      'startDate': startDate,
      'endDate': endDate,
      'month': month,
      'year': year,
      'status': status,
      'sponsorName': sponsorName,
      'tournamentDirector': tournamentDirector,
      'prizeMoney': prizeMoney,
      'prizeMoneyCurrency': prizeMoneyCurrency,
      'drawSize': drawSize,
      'certificate': certificate,
      'tournamentLogo': tournamentLogo,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Computed properties for UI display
  String get dateRange {
    if (startDate.isEmpty || endDate.isEmpty) return 'Date TBD';
    
    try {
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);
      
      if (start.month == end.month) {
        return '${start.day}-${end.day} ${_getMonthName(start.month)}';
      } else {
        return '${start.day} ${_getMonthName(start.month)} - ${end.day} ${_getMonthName(end.month)}';
      }
    } catch (e) {
      return '$startDate - $endDate';
    }
  }

  String get surfaceImagePath {
    // Return tournament logo if available, otherwise default surface image
    if (tournamentLogo.isNotEmpty) {
      return tournamentLogo;
    }
    
    // Default surface images based on surface type
    switch (surface.toLowerCase()) {
      case 'hard':
        return 'https://via.placeholder.com/400x150/4285F4/FFFFFF?text=Hard+Court';
      case 'clay':
        return 'https://via.placeholder.com/400x150/FF9800/FFFFFF?text=Clay+Court';
      case 'grass':
        return 'https://via.placeholder.com/400x150/4CAF50/FFFFFF?text=Grass+Court';
      default:
        return 'https://via.placeholder.com/400x150/9E9E9E/FFFFFF?text=Tennis+Court';
    }
  }

  bool get isHard => surface.toLowerCase() == 'hard';

  String _getMonthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return month >= 1 && month <= 12 ? months[month] : '';
  }

  @override
  String toString() {
    return 'Tournament(id: $id, name: $name, location: $location, month: $month)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Tournament && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}