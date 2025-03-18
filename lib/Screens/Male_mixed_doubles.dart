import 'package:flutter/material.dart';

class MixedDoublesMenScreen extends StatefulWidget {
  const MixedDoublesMenScreen({super.key});

  @override
  _MixedDoublesMenScreenState createState() => _MixedDoublesMenScreenState();
}

class _MixedDoublesMenScreenState extends State<MixedDoublesMenScreen> {
  List<Map<String, String>> players = [
    {
      "image": "assets/images/doubles1.jpg",
      "title": "Kenyan Njeri and Okton win RealTun Tennis end-of-year tournament 2020",
      "name": "Njeri & Okton",
      "details": "Njeri and Okton are top-ranked Kenyan tennis players who won the RealTun Tennis end-of-year tournament in 2020.",
    },
    {
      "image": "assets/images/doubles2.jpg",
      "title": "Wanjiru and Mweehaki win RTT tour in Kenya Oct 24, 2023",
      "name": "Wanjiru & Mweehaki",
      "details": "Wanjiru and Mweehaki secured the RTT Tour title in Kenya on October 24, 2023.",
    },
    {
      "image": "assets/images/doubles3.jpg",
      "title": "Hanamy and Shanifah win Nov 23, 2020 RTT tours",
      "name": "Hanamy & Shanifah",
      "details": "Hanamy and Shanifah won the RTT Tour event on November 23, 2020, showcasing great skill and teamwork.",
    },
  ];

  List<Map<String, String>> filteredPlayers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredPlayers = players;
  }

  void _filterPlayers(String query) {
    setState(() {
      filteredPlayers = players
          .where((player) => player["name"]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "REAL TURN MIXED DOUBLES MALE",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _filterPlayers,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: "Search for player",
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: filteredPlayers.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerOverviewScreen(
                          name: filteredPlayers[index]["name"]!,
                          image: filteredPlayers[index]["image"]!,
                          details: filteredPlayers[index]["details"]!,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        filteredPlayers[index]["image"]!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 150,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.grey[300],
                        child: Text(
                          filteredPlayers[index]["title"]!,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PlayerOverviewScreen extends StatelessWidget {
  final String name;
  final String image;
  final String details;

  const PlayerOverviewScreen({super.key, 
    required this.name,
    required this.image,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(image, width: double.infinity, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 20),
            Text(
              name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              details,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
