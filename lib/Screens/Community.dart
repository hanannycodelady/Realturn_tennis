import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with TickerProviderStateMixin {
  late Future<List<dynamic>> _communitiesFuture;
  Timer? _refreshTimer;
  String _searchQuery = '';
  List<dynamic> _allCommunities = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _searchController;

  Future<List<dynamic>> getCommunities() async {
    try {
      final DatabaseReference ref = FirebaseDatabase.instance.ref('communities');
      final DataSnapshot snapshot = await ref.get();

      if (snapshot.exists) {
        final data = snapshot.value;
        if (data is Map) {
          List<dynamic> communities = data.values.map((community) {
            if (community is Map) {
              String extraDesc = community['extra_description'] ?? '';
              if (community['community_name'] == 'Bweyogere') {
                extraDesc = extraDesc.isEmpty 
                    ? 'courts are in good condition' 
                    : '$extraDesc. courts are in good condition';
              }
              return {
                'community_name': community['community_name'] ?? 'Unnamed Community',
                'community_description': community['description'] ?? 'No description',
                'community_image': community['community_image'] ?? null,
                'location': community['location'] ?? 'Unknown location',
                'extra_description': extraDesc,
              };
            }
            return null;
          }).where((item) => item != null).toList();
          _allCommunities = communities;
          return _filterCommunities();
        }
      }
      _allCommunities = [];
      return [];
    } catch (e) {
      print('Error fetching communities: $e');
      throw Exception('Failed to load communities from Firebase');
    }
  }

  List<dynamic> _filterCommunities() {
    if (_searchQuery.isEmpty) {
      return _allCommunities;
    }
    return _allCommunities.where((community) {
      final name = community['community_name'].toString().toLowerCase();
      final location = community['location'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || location.contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _communitiesFuture = getCommunities();
    _startPeriodicRefresh();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _searchController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
  }

  void _startPeriodicRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _communitiesFuture = getCommunities();
        });
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFE),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1976D2),
                    Color(0xFF2196F3),
                    Color(0xFF42A5F5),
                  ],
                ),
              ),
              child: FlexibleSpaceBar(
                centerTitle: true,
                title: const Text(
                  'Communities',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    letterSpacing: 0.5,
                  ),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1976D2),
                        Color(0xFF2196F3),
                        Color(0xFF42A5F5),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -40,
                        top: -40,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 15,
                        top: 25,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, 
                    color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    ModernSearchBar(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                          _communitiesFuture = Future.value(_filterCommunities());
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder<List<dynamic>>(
                      future: _communitiesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const LoadingWidget();
                        } else if (snapshot.hasError) {
                          return ErrorWidget(
                            onRetry: () {
                              setState(() {
                                _communitiesFuture = getCommunities();
                              });
                            },
                          );
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const EmptyStateWidget();
                        }

                        final communities = snapshot.data!;
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: communities.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final community = communities[index];
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300 + (index * 100)),
                              curve: Curves.easeOutBack,
                              child: ModernCommunityCard(
                                imageUrl: community['community_image'] ?? 
                                    'https://via.placeholder.com/400x200',
                                title: community['community_name'] ?? 'Unnamed Community',
                                description: community['community_description'] ?? 'No description',
                                location: community['location'] ?? 'Unknown location',
                                extraDescription: community['extra_description'] ?? '',
                                index: index,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ModernSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const ModernSearchBar({Key? key, required this.onChanged}) : super(key: key);

  @override
  _ModernSearchBarState createState() => _ModernSearchBarState();
}

class _ModernSearchBarState extends State<ModernSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2196F3).withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          elevation: 0,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.blue[50]!.withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: _isFocused 
                    ? const Color(0xFF2196F3) 
                    : Colors.grey[300]!,
                width: _isFocused ? 2 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: _isFocused 
                        ? const Color(0xFF2196F3) 
                        : Colors.grey[500],
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search communities by name or location...',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: widget.onChanged,
                      onTap: () {
                        setState(() => _isFocused = true);
                        _controller.forward();
                      },
                      onEditingComplete: () {
                        setState(() => _isFocused = false);
                        _controller.reverse();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ModernCommunityCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String location;
  final String extraDescription;
  final int index;

  const ModernCommunityCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.location,
    required this.extraDescription,
    required this.index,
  }) : super(key: key);

  @override
  _ModernCommunityCardState createState() => _ModernCommunityCardState();
}

class _ModernCommunityCardState extends State<ModernCommunityCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _elevationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _elevationAnimation = Tween<double>(begin: 4, end: 12).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _hoverController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _hoverController.forward(),
            onTapUp: (_) => _hoverController.reverse(),
            onTapCancel: () => _hoverController.reverse(),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2196F3).withOpacity(0.1),
                    blurRadius: _elevationAnimation.value,
                    offset: Offset(0, _elevationAnimation.value / 2),
                  ),
                ],
              ),
              child: Material(
                elevation: 0,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.blue[50]!.withOpacity(0.2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: Colors.blue[100]!.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Container(
                          height: 140,
                          width: double.infinity,
                          child: Image.network(
                            widget.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue[300]!,
                                      Colors.blue[400]!,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.groups_rounded,
                                    size: 32,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Color(0xFF1A1A1A),
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.location_on_rounded,
                                    color: Colors.blue[600],
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    widget.location,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.description,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (widget.extraDescription.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue[25],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.blue[100]!,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  widget.extraDescription,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build( context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * 3.14159,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.groups_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            'Loading communities...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const ErrorWidget({Key? key, required this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Failed to load communities',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your connection and try again',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Retry',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.groups_outlined,
                size: 50,
                color: Colors.blue[300],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No communities found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search criteria',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}