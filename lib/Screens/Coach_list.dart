import 'package:flutter/material.dart';
import 'package:realturn_app/Screens/Female_player.dart';
import 'package:realturn_app/Screens/Male_players.dart';

class CoachListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> coaches = [
    {
      "name": "LEANDRO AFINI",
      "country": "BRA",
      "flag": "🇧🇷",
      "image": "assets/coach1.jpg",
      "currentlyCoaching": "L. Shymanovich",
      "playerFlag": "",
      "previouslyCoached": 2,
      "playerGender": "female"
    },
    {
      "name": "ADRIANO ALBANESI",
      "country": "ITA",
      "flag": "🇮🇹",
      "image": "assets/coach2.jpg",
      "currentlyCoaching": "",
      "playerFlag": "",
      "previouslyCoached": 2,
      "playerGender": ""
    },
    {
      "name": "THOMAS ALM",
      "country": "SWE",
      "flag": "🇸🇪",
      "image": "assets/coach3.jpg",
      "currentlyCoaching": "M. Navarro Oliva",
      "playerFlag": "🇲🇽",
      "previouslyCoached": 5,
      "playerGender": "male"
    },
    {
      "name": "A. APOSTU-EFREMOV",
      "country": "ROU",
      "flag": "🇷🇴",
      "image": "assets/coach4.jpg",
      "currentlyCoaching": "A. Todoni",
      "playerFlag": "🇷🇴",
      "previouslyCoached": 6,
      "playerGender": "female"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Coach List"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: ListView.builder(
        itemCount: coaches.length,
        itemBuilder: (context, index) {
          final coach = coaches[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(coach["image"]),
            ),
            title: Text(
              "${coach["name"]} \n${coach["flag"]} ${coach["country"]}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Currently Coaching: ${coach["currentlyCoaching"]}"),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Previously Coached"),
                CircleAvatar(
                  backgroundColor: Colors.purple,
                  child: Text(
                    "${coach["previouslyCoached"]}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CoachDetailsScreen(coach: coach),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CoachDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> coach;
  CoachDetailsScreen({required this.coach});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(coach["name"])),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(coach["image"]),
              radius: 50,
            ),
            SizedBox(height: 10),
            Text(coach["name"], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("Country: ${coach["flag"]} ${coach["country"]}"),
            if (coach["currentlyCoaching"].isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => coach["playerGender"] == "male"
                          ? MalePlayer(playerName: coach["currentlyCoaching"], name: '', image1: '', details: '', image2: '',)
                          : FemalePlayer(playerName: coach["currentlyCoaching"], name: '', image1: '', image2: '', details: '',),
                    ),
                  );
                },
                child: Text(
                  "Currently Coaching: ${coach["currentlyCoaching"]} ${coach["playerFlag"]}",
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
            Text("Previously Coached: ${coach["previouslyCoached"]}"),
          ],
        ),
      ),
    );
  }
}
