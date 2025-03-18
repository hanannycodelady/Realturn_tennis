import 'package:flutter/material.dart';
import 'package:realturn_app/Screens/home_screen.dart';


class NotificationScreen extends StatelessWidget {
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Real turn projects',
      'description': 'Grab your equipment for the next coming event a lot of amazing experience',
      'time': '9:41 AM',
      'day': 'Monday',
      'opened': false,
    },
    {
      'title': 'Fundraising for our community courts',
      'description': 'Give a hand to make someone happy by raising money for the community courts',
      'time': '10:15 AM',
      'day': 'Tuesday',
      'opened': true,
    },
  ];

   NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
      ),
      body: NotificationList(notifications: notifications),
    );
  }
}

class NotificationList extends StatelessWidget {
  final List<Map<String, dynamic>> notifications;
  const NotificationList({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 5,
                  offset: const Offset(-3, 0),
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundImage: const AssetImage('assets/logo.png'), 
              backgroundColor: notifications[index]['opened'] ? Colors.grey : Colors.red,
            ),
          ),
          title: Text(
            notifications[index]['title']!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: notifications[index]['opened'] ? Colors.black : Colors.red,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notifications[index]['description']!),
              Text('${notifications[index]['day']} - ${notifications[index]['time']}', style: const TextStyle(color: Colors.grey)),
            ],
          ),
        );
      },
    );
  }
}
