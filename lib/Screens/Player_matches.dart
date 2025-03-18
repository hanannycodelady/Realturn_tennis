import 'package:flutter/material.dart';

class PlayerMatchesScreen extends StatelessWidget {
  final TabController tabController;

  const PlayerMatchesScreen({Key? key, required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildStatusBar(),
            _buildHeader(),
            _buildProfileSection(),
            _buildPlayerInfo(),
            _buildCoachSection(),
            _buildTournamentSection(),
            _buildMatchTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      color: Colors.white,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('19:02', style: TextStyle(fontWeight: FontWeight.w500)),
          Row(
            children: [
              Icon(Icons.signal_cellular_4_bar, size: 16),
              SizedBox(width: 4),
              Icon(Icons.wifi, size: 16),
              SizedBox(width: 4),
              Icon(Icons.battery_full, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(15),
      color: const Color(0xFF0066CC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => tabController.animateTo(0), // Switch to Overview tab
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            'RANKING',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            '1',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Singles',
                    style: TextStyle(
                      color: Color(0xFF0066CC),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0066CC),
                    border: Border.all(color: Colors.white),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Doubles',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      color: const Color(0xFFE6E6E6),
      child: Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(50),
          ),
          child: CustomPaint(
            painter: ProfilePainter(),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerInfo() {
    return Container(
      padding: const EdgeInsets.all(15),
      color: const Color(0xFF0066CC),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hananny',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          Text(
            'Wanjiku',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Height',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '5\' 11"',
                      style: TextStyle(
                        color: Color(0xFFB3D9FF),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '1.82m',
                      style: TextStyle(
                        color: Color(0xFFB3D9FF),
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Plays',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Right-Handed',
                      style: TextStyle(
                        color: Color(0xFFB3D9FF),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Age',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '20',
                      style: TextStyle(
                        color: Color(0xFFB3D9FF),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'oct/22/2004',
                      style: TextStyle(
                        color: Color(0xFFB3D9FF),
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Birthplace',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Mulago',
                      style: TextStyle(
                        color: Color(0xFFB3D9FF),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            'Current Coach',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachSection() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      width: double.infinity,
      child: const Text(
        'GODFREY MAX SEMUKAYA',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTournamentSection() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: const Color(0xFFE6E6E6),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Real turn tennis',
            style: TextStyle(
              color: Color(0xFF0066CC),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Uganda open',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'lugogo tennis grounds',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                'may 25-june,2024',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF0066CC),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Prize money',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                '2000,0000 UGX',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                'Surface Clay',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            'Draws 128 M /48Q /32D',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchTable() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1.5),
        2: FlexColumnWidth(0.8),
        3: FlexColumnWidth(0.8),
        4: FlexColumnWidth(1.2),
      },
      border: TableBorder(
        horizontalInside: BorderSide(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      children: [
        _buildTableHeaderRow(),
        _buildMatchRow('Q', 'S.Namagembe', '3', 'L', ['6-7', '4-6'], false),
        _buildMatchRow('R16', 'N.A.Wanjiku', '2', 'W', ['6-2', '6-2'], true),
        _buildMatchRow('R32', 'H.mwehaki', '4', 'W', ['6-4', '6-3'], true),
        _buildMatchRow('R64', 'B.Na bweteme', '5', 'W', ['6-4', '6-3'], true),
        _buildMatchRow('R127', '-', '-', '-', ['Bye'], null),
      ],
    );
  }

  TableRow _buildTableHeaderRow() {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Rd',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Opp.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Opp R',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'W/L',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Scores',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildMatchRow(String round, String opponent, String oppRank, String result, List<String> scores, bool? isWin) {
    Color resultColor = isWin == null ? Colors.black : (isWin ? const Color(0xFF0066CC) : Colors.red);

    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              round,
              style: const TextStyle(color: Color(0xFF0066CC)),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(opponent),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(oppRank),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              result,
              style: TextStyle(color: resultColor),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: scores.map((score) {
                return Text(
                  score,
                  style: TextStyle(color: resultColor),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class ProfilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFFE6E6E6)
      ..style = PaintingStyle.fill;

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = size.width / 4;

    canvas.drawCircle(Offset(centerX, centerY - radius / 2), radius, paint);
    canvas.drawRect(
      Rect.fromLTWH(centerX - radius, centerY, radius * 2, radius),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}