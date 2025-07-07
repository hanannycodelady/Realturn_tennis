import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:ui';

// Video model class to represent video data
class Video {
  final String id;
  final String embedUrl;
  final String videoUrl;
  final String videoDescription;
  final String videoDate;
  final int createdAt;
  final int updatedAt;
  final String thumbnailUrl;

  Video({
    required this.id,
    required this.embedUrl,
    required this.videoUrl,
    required this.videoDescription,
    required this.videoDate,
    required this.createdAt,
    required this.updatedAt,
    required this.thumbnailUrl,
  });

  factory Video.fromMap(String id, Map<dynamic, dynamic> map) {
    print('Parsing video ID: $id, data: $map');
    final videoUrl = map['video_url'] as String? ?? '';
    String thumbnailUrl = '';
    String embedUrl = map['embed_url'] as String? ?? '';
    if (videoUrl.contains('youtube.com/watch?v=') && videoUrl.split('v=').length > 1) {
      final videoId = videoUrl.split('v=')[1].split('&')[0];
      thumbnailUrl = 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
      if (embedUrl.isEmpty) {
        embedUrl = 'https://www.youtube.com/embed/$videoId';
      }
      print('Thumbnail URL for $id: $thumbnailUrl');
    } else {
      thumbnailUrl = 'https://via.placeholder.com/480x270.png?text=No+Thumbnail';
      print('Invalid video URL for $id: $videoUrl');
    }

    return Video(
      id: id,
      embedUrl: embedUrl,
      videoUrl: videoUrl,
      videoDescription: map['video_description'] as String? ?? 'No description',
      videoDate: map['video_date'] as String? ?? 'Unknown date',
      createdAt: (map['created_at'] as num?)?.toInt() ?? 0,
      updatedAt: (map['updated_at'] as num?)?.toInt() ?? 0,
      thumbnailUrl: thumbnailUrl,
    );
  }

  @override
  String toString() {
    return 'Video(id: $id, description: $videoDescription, date: $videoDate, thumbnail: $thumbnailUrl)';
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String embedUrl;

  const VideoPlayerScreen({Key? key, required this.embedUrl}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.embedUrl));
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.embedUrl.contains('youtube.com/embed/')) {
      return Scaffold(
        appBar: AppBar(title: const Text('Video Player')),
        body: const Center(child: Text('Invalid video URL')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Video Player')),
      body: WebViewWidget(controller: _controller),
    );
  }
}

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  List<Video> _videos = [];
  bool _isLoading = true;

  // Firebase Realtime Database reference
  final DatabaseReference _videosRef = FirebaseDatabase.instance.ref().child('videos');

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    testFirebase();
    _fetchVideos();
  }

  void testFirebase() async {
    try {
      final snapshot = await _videosRef.get();
      print('Test fetch: ${snapshot.value}');
    } catch (e) {
      print('Test fetch error: $e');
    }
  }

  void _fetchVideos() {
    _videosRef.onValue.listen((event) {
      print('Raw Firebase data: ${event.snapshot.value}');
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        List<Video> videos = [];

        data.forEach((key, value) {
          try {
            final video = Video.fromMap(key, value as Map<dynamic, dynamic>);
            print('Parsed video: ${video.toString()}');
            videos.add(video);
          } catch (e) {
            print('Error parsing video $key: $e');
          }
        });

        print('Videos count: ${videos.length}');
        setState(() {
          _videos = videos;
          _isLoading = false;
        });
      } else {
        print('No data in videos node');
        setState(() {
          _isLoading = false;
        });
      }
    }, onError: (error) {
      print('Firebase error: $error');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching videos: $error'),
          backgroundColor: Colors.red[700],
        ),
      );
    });
  }

  List<Video> get _filteredVideos {
    return _videos.where((video) => video.thumbnailUrl.isNotEmpty).toList();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: _buildModernAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E88E5),
              Colors.white,
            ],
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _videos.isEmpty
                ? const Center(child: Text('No videos available', style: TextStyle(color: Colors.white, fontSize: 18)))
                : FadeTransition(
                    opacity: _fadeAnimation,
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        const SliverToBoxAdapter(child: SizedBox(height: 100)),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                if (index >= _filteredVideos.length) return const SizedBox.shrink();
                                final video = _filteredVideos[index];
                                return _buildVideoCard(video, index);
                              },
                              childCount: _filteredVideos.length,
                            ),
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 50)),
                      ],
                    ),
                  ),
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'Videos',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1E88E5).withOpacity(0.95),
              Colors.transparent,
            ],
          ),
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoCard(Video video, int index) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: EnhancedVideoThumbnail(video: video),
          ),
        );
      },
    );
  }
}

class EnhancedVideoThumbnail extends StatefulWidget {
  final Video video;

  const EnhancedVideoThumbnail({Key? key, required this.video}) : super(key: key);

  @override
  State<EnhancedVideoThumbnail> createState() => _EnhancedVideoThumbnailState();
}

class _EnhancedVideoThumbnailState extends State<EnhancedVideoThumbnail>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic),
    );
    _glowAnimation = Tween<double>(begin: 0.2, end: 0.5).animate(
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
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onTapUp: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      onTapCancel: () {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      onTap: () {
        if (widget.video.embedUrl.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(embedUrl: widget.video.embedUrl),
            ),
          );
        }
      },
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E88E5).withOpacity(_glowAnimation.value),
                    blurRadius: 25,
                    spreadRadius: 2,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      // Background Image
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                            ),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: widget.video.thumbnailUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => const Center(
                              child: Icon(Icons.video_library, color: Colors.white, size: 60),
                            ),
                          ),
                        ),
                      ),
                      // Gradient Overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Play Button (appears on hover)
                      if (_isHovered)
                        Positioned.fill(
                          child: Center(
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF1E88E5).withOpacity(0.6),
                                    blurRadius: 15,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      // Content
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.video.videoDescription.isNotEmpty
                                      ? widget.video.videoDescription
                                      : 'No description available',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    height: 1.3,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        blurRadius: 4,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.video.videoDate.isNotEmpty
                                    ? widget.video.videoDate
                                    : 'Unknown date',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}