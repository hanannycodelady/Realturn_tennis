import 'package:flutter/material.dart';
import 'package:realturn_app/Screens/Female_player.dart';

class MixedDoublesMenScreen extends StatefulWidget {
  const MixedDoublesMenScreen({super.key});

  @override
  _MixedDoublesMenScreenState createState() => _MixedDoublesMenScreenState();
}

class _MixedDoublesMenScreenState extends State<MixedDoublesMenScreen> {
  List<Map<String, String>> players = [
    {
      "image1": "assets/images/doubles1_player1.jpg",
      "image2": "assets/images/doubles1_player2.jpg",
      "player1Name": "Njeri",
      "player2Name": "Okton",
      "title": "Kenyan Njeri and Okton win RealTun Tennis end-of-year tournament 2020",
      "details": "Njeri and Okton are top-ranked Kenyan tennis players who won the RealTun Tennis end-of-year tournament in 2020.",
    },
    {
      "image1": "assets/images/doubles2_player1.jpg",
      "image2": "assets/images/doubles2_player2.jpg",
      "player1Name": "Wanjiru",
      "player2Name": "Mweehaki",
      "title": "Wanjiru and Mweehaki win RTT tour in Kenya Oct 24, 2023",
      "details": "Wanjiru and Mweehaki secured the RTT Tour title in Kenya on October 24, 2023.",
    },
    {
      "image1": "assets/images/doubles3_player1.jpg",
      "image2": "assets/images/doubles3_player2.jpg",
      "player1Name": "Hanamy",
      "player2Name": "Shanifah",
      "title": "Hanamy and Shanifah win Nov 23, 2020 RTT tours",
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
          .where((player) =>
              player["player1Name"]!.toLowerCase().contains(query.toLowerCase()) ||
              player["player2Name"]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "REAL TURN MIXED DOUBLES",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the back arrow color to white
        ),
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
                        style: const TextStyle(color: Color.fromARGB(255, 243, 241, 241), fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: "Search for player",
                          hintStyle: TextStyle(color: Color.fromARGB(179, 253, 247, 247)),
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Image.asset(
                            filteredPlayers[index]["image1"]!,
                            fit: BoxFit.cover,
                            height: 150,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Image.asset(
                            filteredPlayers[index]["image2"]!,
                            fit: BoxFit.cover,
                            height: 150,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.grey[300],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const FemalePlayer(name: '', image1: '', image2: '', details: '', playerName: null,),
                                    ),
                                  );
                                },
                                child: Text(
                                  filteredPlayers[index]["player1Name"]!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              const Text(
                                " & ",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const FemalePlayer(name: '', image1: '', image2: '', details: '', playerName: null,),
                                    ),
                                  );
                                },
                                child: Text(
                                  filteredPlayers[index]["player2Name"]!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            filteredPlayers[index]["title"]!.split(" ").skip(2).join(" "),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}