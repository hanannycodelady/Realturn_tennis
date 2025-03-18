import 'package:flutter/material.dart';

class StatsPage extends StatelessWidget {
  final TabController tabController;

  const StatsPage({Key? key, required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: const [
                    StatBox(title: 'Ranking', value: '1', subtitle: 'Singles'),
                    StatBox(title: 'Match Played', value: '20', year: '2024'),
                    StatBox(title: 'Aces', value: '90', year: '2024'),
                    StatBox(title: 'Service Games\nwon', value: '50%', year: '2024'),
                    StatBox(title: 'Return Games\nwon', value: '40.0%', year: '2024'),
                    StatBox(title: '1st Serve won', value: '25%', year: '2024'),
                  ],
                ),
              ),
              const StatsSection(
                title: 'Serving stats',
                stats: [
                  {'title': 'Double Faults', 'value': '150%'},
                  {'title': '1st serve %', 'value': '39.0%'},
                  {'title': '2nd serve won', 'value': '30.0%'},
                  {'title': 'Break points saved', 'value': '20.0%'},
                  {'title': 'Service point won', 'value': '10.0%'},
                  {'title': 'Service Games Played', 'value': '20.0%'},
                ],
              ),
              const StatsSection(
                title: 'Return stats',
                stats: [
                  {'title': 'Return points won', 'value': '39.0%'},
                  {'title': '1st Return Points won %', 'value': '60.0%'},
                  {'title': '2nd Return Points won %', 'value': '50.0%'},
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class StatBox extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final String? year;

  const StatBox({
    Key? key,
    required this.title,
    required this.value,
    this.subtitle,
    this.year,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: const TextStyle(fontSize: 12),
            ),
          if (year != null)
            Text(
              year!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
        ],
      ),
    );
  }
}

class StatsSection extends StatelessWidget {
  final String title;
  final List<Map<String, String>> stats;

  const StatsSection({
    Key? key,
    required this.title,
    required this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...stats.map((stat) => DetailStat(
                title: stat['title']!,
                value: stat['value']!,
              )),
        ],
      ),
    );
  }
}

class DetailStat extends StatelessWidget {
  final String title;
  final String value;

  const DetailStat({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}