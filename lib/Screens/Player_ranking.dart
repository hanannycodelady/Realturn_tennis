import 'package:flutter/material.dart';
import 'package:realturn_app/models/PlayerCard.dart';

class PlayerRankScreen extends StatefulWidget {
  final PlayerCard player;
  final TabController tabController;

  const PlayerRankScreen({Key? key, required this.player, required this.tabController})
      : super(key: key);

  @override
  State<PlayerRankScreen> createState() => _PlayerRankScreenState();
}

class _PlayerRankScreenState extends State<PlayerRankScreen> {
  bool isSinglesSelected = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Status Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '19:02',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: const [
                    Icon(Icons.signal_cellular_4_bar, size: 16),
                    SizedBox(width: 5),
                    Icon(Icons.wifi, size: 16),
                    SizedBox(width: 5),
                    Icon(Icons.battery_full, size: 16),
                  ],
                ),
              ],
            ),
          ),
          // Blue Header Section
          Container(
            color: const Color(0xFF0066CC),
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => widget.tabController.animateTo(0), // Switch to Overview
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'RANKING',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  widget.player.ranking?.toString() ?? '1',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => isSinglesSelected = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        decoration: BoxDecoration(
                          color: isSinglesSelected ? Colors.white : const Color(0xFF005FCC),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text(
                          'Singles',
                          style: TextStyle(
                            color: isSinglesSelected ? Colors.black : Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => setState(() => isSinglesSelected = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        decoration: BoxDecoration(
                          color: !isSinglesSelected ? Colors.white : const Color(0xFF005FCC),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text(
                          'Doubles',
                          style: TextStyle(
                            color: !isSinglesSelected ? Colors.black : Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Profile Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: Color(0xFFD0D0D0),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          // Player Info Section
          Container(
            color: const Color(0xFF0066CC),
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.player.firstName,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  widget.player.lastName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Height',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          widget.player.height ?? "5' 11\"",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.player.height != null ? '1.82m' : 'Unknown',
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Age',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          widget.player.age ?? '20',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.player.birthDate ?? 'oct/22/2004',
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Plays',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          widget.player.plays ?? 'Right-Handed',
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Birthplace',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          widget.player.birthplace ?? 'Mulago',
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  'Current Coach',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.player.coach ?? 'GODFREY MAX SEMUKAYA',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          // Navigation Tabs
          Container(
            color: Colors.black,
            child: Row(
              children: [
                _buildNavTab("Overview", false),
                _buildNavTab("Bio", false),
                _buildNavTab("Matches", false),
                _buildNavTab("Stats", false),
                _buildNavTab("Ranking", true),
              ],
            ),
          ),
          // Rankings Grid
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.2,
                      children: [
                        _buildRankingBox("Currents", widget.player.ranking?.toString() ?? "1", ""),
                        _buildRankingBox("Highest singles", "1", "oct 10,2023"),
                        _buildRankingBox("Current doubles", "1", "2024"),
                        _buildRankingBox("Highest Doubles", "1", "feb 22,2023"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: const [
                              Expanded(flex: 1, child: Text("Date", style: TextStyle(fontSize: 14))),
                              Expanded(flex: 2, child: Text("Top Rank by year", style: TextStyle(fontSize: 14))),
                              Expanded(flex: 2, child: Text("Year-end Ranking", style: TextStyle(fontSize: 14))),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        _buildYearRow("2024", "1", ""),
                        _buildYearRow("2023", "2", "2"),
                        _buildYearRow("2022", "2", "3"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavTab(String title, bool isActive) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: isActive
              ? const Border(bottom: BorderSide(color: Colors.white, width: 3))
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildRankingBox(String title, String value, String date) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD0D0D0)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          Center(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0066CC),
              ),
            ),
          ),
          if (date.isNotEmpty)
            Center(
              child: Text(date, style: const TextStyle(fontSize: 12)),
            ),
        ],
      ),
    );
  }

  Widget _buildYearRow(String year, String topRank, String endRank) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD0D0D0)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(year, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 2,
            child: Text(
              topRank,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              endRank,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}