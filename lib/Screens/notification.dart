import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:realturn_app/Screens/home_screen.dart'; // Adjust import path as needed

// Enums
enum NotificationType {
  event,
  fundraising,
  tournament,
  payment,
  general,
}

enum NotificationPriority {
  low,
  medium,
  high,
}

// Notification Model
class NotificationModel {
  final String id;
  final String title;
  final String description;
  final String time;
  final String day;
  bool isRead;
  final NotificationType type;
  final NotificationPriority priority;
  final int timestamp;
  final int createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.day,
    required this.isRead,
    required this.type,
    required this.priority,
    required this.timestamp,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(String id, Map<dynamic, dynamic> data) {
    return NotificationModel(
      id: id,
      title: data['title']?.toString() ?? 'Untitled',
      description: data['description']?.toString() ?? '',
      time: data['time']?.toString() ?? '',
      day: data['day']?.toString() ?? '',
      isRead: data['isRead'] == true,
      type: _parseType(data['type']?.toString()),
      priority: _parsePriority(data['priority']?.toString()),
      timestamp: _parseTimestamp(data['timestamp']),
      createdAt: _parseTimestamp(data['created_at']),
    );
  }

  static int _parseTimestamp(dynamic value) {
    if (value is num) return value.toInt();
    return DateTime.now().millisecondsSinceEpoch;
  }

  static NotificationType _parseType(String? type) {
    switch (type?.toLowerCase()) {
      case 'event':
        return NotificationType.event;
      case 'fundraising':
        return NotificationType.fundraising;
      case 'tournament':
        return NotificationType.tournament;
      case 'payment':
        return NotificationType.payment;
      case 'general':
      default:
        return NotificationType.general;
    }
  }

  static NotificationPriority _parsePriority(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'high':
        return NotificationPriority.high;
      case 'medium':
        return NotificationPriority.medium;
      case 'low':
      default:
        return NotificationPriority.low;
    }
  }

  Color getTypeColor() {
    switch (type) {
      case NotificationType.event:
        return const Color(0xFF6366F1); // Indigo
      case NotificationType.fundraising:
        return const Color(0xFF10B981); // Emerald
      case NotificationType.tournament:
        return const Color(0xFF8B5CF6); // Violet
      case NotificationType.payment:
        return const Color(0xFF06B6D4); // Cyan
      case NotificationType.general:
        return const Color(0xFF64748B); // Slate
    }
  }

  LinearGradient getTypeGradient() {
    switch (type) {
      case NotificationType.event:
        return const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case NotificationType.fundraising:
        return const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case NotificationType.tournament:
        return const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case NotificationType.payment:
        return const LinearGradient(
          colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case NotificationType.general:
        return const LinearGradient(
          colors: [Color(0xFF64748B), Color(0xFF475569)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  IconData getTypeIcon() {
    switch (type) {
      case NotificationType.event:
        return Icons.calendar_today_rounded;
      case NotificationType.fundraising:
        return Icons.favorite_rounded;
      case NotificationType.tournament:
        return Icons.emoji_events_rounded;
      case NotificationType.payment:
        return Icons.account_balance_wallet_rounded;
      case NotificationType.general:
        return Icons.notifications_rounded;
    }
  }

  String getTypeLabel() {
    switch (type) {
      case NotificationType.event:
        return 'EVENT';
      case NotificationType.fundraising:
        return 'FUNDRAISING';
      case NotificationType.tournament:
        return 'TOURNAMENT';
      case NotificationType.payment:
        return 'PAYMENT';
      case NotificationType.general:
        return 'GENERAL';
    }
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseReference notificationsRef =
        FirebaseDatabase.instance.ref('notifications');

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 24,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 18,
            ),
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const HomeScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              _showFilterBottomSheet(context);
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: notificationsRef.orderByChild('timestamp').limitToLast(50).onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }

          if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString(), notificationsRef);
          }

          final data = snapshot.data?.snapshot.value;
          List<NotificationModel> notifications = [];

          if (data != null && data is Map<dynamic, dynamic>) {
            notifications = data.entries
                .map((entry) => NotificationModel.fromMap(
                    entry.key as String, entry.value as Map<dynamic, dynamic>))
                .toList()
              ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
          }

          if (notifications.isEmpty) {
            return _buildEmptyState();
          }

          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  _buildHeaderSection(notifications, notificationsRef),
                  Expanded(
                    child: NotificationList(notifications: notifications),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
            SizedBox(height: 24),
            Text(
              'Loading notifications...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error, DatabaseReference ref) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Failed to load notifications',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  setState(() {});
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF667EEA),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 64,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'No notifications yet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'re all caught up! Check back later.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(
      List<NotificationModel> notifications, DatabaseReference ref) {
    final unreadCount = notifications.where((n) => !n.isRead).length;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: unreadCount > 0
                            ? const Color(0xFF6366F1).withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$unreadCount unread',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: unreadCount > 0
                              ? const Color(0xFF6366F1)
                              : Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${notifications.length} total',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (unreadCount > 0)
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () async {
                    HapticFeedback.lightImpact();
                    try {
                      await ref.update({
                        for (var notif in notifications) '${notif.id}/isRead': true,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('All notifications marked as read'),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to mark all as read: $error'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.done_all, size: 16, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Mark all read',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Filter & Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),
            const Text('Filter options coming soon...'),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class NotificationList extends StatefulWidget {
  final List<NotificationModel> notifications;
  const NotificationList({super.key, required this.notifications});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      widget.notifications.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 600 + (index * 100)),
        vsync: this,
      ),
    );

    _animations = _controllers
        .map((controller) => Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut)))
        .toList();

    // Start animations with staggered delay
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 50), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseReference notificationsRef =
        FirebaseDatabase.instance.ref('notifications');

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      itemCount: widget.notifications.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        if (index >= _animations.length) return const SizedBox.shrink();
        
        final notification = widget.notifications[index];

        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - _animations[index].value)),
              child: Opacity(
                opacity: _animations[index].value,
                child: _buildNotificationCard(notification, notificationsRef),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNotificationCard(
      NotificationModel notification, DatabaseReference ref) {
    return GestureDetector(
      onTap: () async {
        HapticFeedback.selectionClick();
        if (!notification.isRead) {
          setState(() {
            notification.isRead = true;
          });
          try {
            await ref.child(notification.id).update({'isRead': true});
          } catch (error) {
            setState(() {
              notification.isRead = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to mark as read: $error')),
            );
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: !notification.isRead
              ? Border.all(color: notification.getTypeColor().withOpacity(0.3))
              : null,
          boxShadow: [
            BoxShadow(
              color: !notification.isRead
                  ? notification.getTypeColor().withOpacity(0.15)
                  : Colors.black.withOpacity(0.06),
              blurRadius: !notification.isRead ? 20 : 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Gradient background for unread notifications
            if (!notification.isRead)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        notification.getTypeColor().withOpacity(0.05),
                        notification.getTypeColor().withOpacity(0.02),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon with gradient background
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: !notification.isRead
                          ? notification.getTypeGradient()
                          : LinearGradient(
                              colors: [
                                Colors.grey[100]!,
                                Colors.grey[200]!,
                              ],
                            ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: !notification.isRead
                          ? [
                              BoxShadow(
                                color: notification.getTypeColor().withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            notification.getTypeIcon(),
                            color: !notification.isRead
                                ? Colors.white
                                : Colors.grey[600],
                            size: 24,
                          ),
                        ),
                        if (!notification.isRead &&
                            notification.priority == NotificationPriority.high)
                          Positioned(
                            top: 2,
                            right: 2,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFEF4444).withOpacity(0.5),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Type badge and unread indicator
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: notification.getTypeColor().withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                notification.getTypeLabel(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: notification.getTypeColor(),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const Spacer(),
                            if (!notification.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  gradient: notification.getTypeGradient(),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: notification.getTypeColor().withOpacity(0.5),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Title
                        Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: !notification.isRead
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: !notification.isRead
                                ? Colors.black87
                                : const Color(0xFF64748B),
                            height: 1.3,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Description
                        Text(
                          notification.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: !notification.isRead
                                ? const Color(0xFF475569)
                                : const Color(0xFF94A3B8),
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16),
                        // Time and priority
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.access_time_rounded,
                                    size: 12,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${notification.day} • ${notification.time}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600],
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (notification.priority != NotificationPriority.low)
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: notification.priority == NotificationPriority.high
                                        ? const Color(0xFFEF4444).withOpacity(0.1)
                                        : const Color(0xFFFFA500).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    notification.priority == NotificationPriority.high
                                        ? 'HIGH'
                                        : 'MEDIUM',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: notification.priority == NotificationPriority.high
                                          ? const Color(0xFFEF4444)
                                          : const Color(0xFFFFA500),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}