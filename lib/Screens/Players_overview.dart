import 'package:flutter/material.dart';
import 'package:realturn_app/models/PlayerCard.dart';

class PlayerOverviewScreen extends StatefulWidget {
  final PlayerCard player;

  const PlayerOverviewScreen({Key? key, required this.player}) : super(key: key);

  @override
  State<PlayerOverviewScreen> createState() => _PlayerOverviewScreenState();
}

class _PlayerOverviewScreenState extends State<PlayerOverviewScreen>
    with SingleTickerProviderStateMixin {
  bool isSinglesSelected = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.index = 0; // Set Overview tab as default
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    //_buildStatusBar(),
                    _buildRankingHeader(),
                    _buildProfilePicture(),
                    _buildPlayerInfo(),
                  ],
                ),
              ),
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.black,
                automaticallyImplyLeading: false,
                flexibleSpace: _buildTabBar(),
              ),
            ];
          },
          body: Material(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildBioTab(),
                _buildMatchesTab(),
                _buildStatsTab(),
                _buildRankingTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildRankingHeader() {
    return Container(
      padding: const EdgeInsets.all(15),
      color: const Color(0xFF0066CC),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.arrow_back, color: Colors.white),
              SizedBox(width: 10),
              Text('RANKING',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const Text(
            '1',
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.white,
      child: Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(60),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerInfo() {
    return Container(
      padding: const EdgeInsets.all(15),
      color: const Color(0xFF0066CC),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hananny',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
            ),
          ),
          const Text(
            'Wanjiku',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Height',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    '5\' 11"',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '1.82m',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Age',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    '20',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Oct/22/2004',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Plays',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    'Right-Handed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Birthplace',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    'Mulago',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            'Current Coach',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.white,
            width: double.infinity,
            alignment: Alignment.center,
            child: const Text(
              'GODFREY MAX SEMUKAYA',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      indicatorColor: const Color(0xFF0066CC),
      indicatorWeight: 3,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white70,
      tabs: const [
        Tab(text: 'Overview'),
        Tab(text: 'Bio'),
        Tab(text: 'Matches'),
        Tab(text: 'Stats'),
        Tab(text: 'Ranking'),
      ],
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildRankingsSection(),
          _buildLatestMatchesSection(),
          _buildVideosSection(),
          _buildTitlesSection(),
        ],
      ),
    );
  }

  Widget _buildRankingsSection() {
    return Column(
      children: [
        _buildRankingRow('Current Ranking', widget.player.ranking?.toString() ?? 'N/A', isBlue: true),
        _buildRankingRow('Singles Title', '4', isBlue: true),
        _buildRankingRow('W/L Singles', '20/10', isBlue: true),
      ],
    );
  }

  Widget _buildRankingRow(String title, String value, {bool isBlue = false}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isBlue ? Colors.blue : Colors.black,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestMatchesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Latest Matches',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                'All matches',
                style: TextStyle(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Realturn tennis finals',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Semifinals',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'W.hananny ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '(1)',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Colors.grey),
                            right: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: const Text(
                          '6',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          '3',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        '-',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Text(
                              'N.shanitah ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              '(3)',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              color: Colors.grey[200],
                              child: const Text(
                                'won',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Colors.grey),
                            right: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: const Text(
                          '7',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          '6',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        '-',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVideosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Latest Player Videos',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 180,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  'https://via.placeholder.com/400x200',
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.error));
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.black54,
                  child: const Text(
                    'MBARARA TENNIS OPEN 20XX\nHANANNY VS ANGELLA\n4-0,4-0',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.all(8),
          color: Colors.black,
          child: const Center(
            child: Text(
              'Best of the best : Top plays from the inaugural RTT\n2023 RTT Finals',
              style: TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitlesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Titles',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Image.network(
                  'https://via.placeholder.com/40',
                  width: 40,
                  height: 40,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, size: 40);
                  },
                ),
              ),
              const Expanded(
                child: Text(
                  '2023,2024',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Win',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBioTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'More on Wanjiku',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Coached by Godfrey max semukaya.\nStarted playing when she was 6, her dad took her in several sports but she choose to play tennis. Has a sweet tooth and considers something sweet as a perfect present. She loves her mother\'s cooking.',
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 20),
            const Text(
              'Career Highlights',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'SINGLES (12):',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text('2020: Uganda Open Championship (Gold)'),
            const Text('2021: East African Tennis Invitational (Winner)'),
            const Text('2022: Makerere Invitational Classic (Winner)'),
            const Text('2023: Uganda tennis association (Winner)'),
            const SizedBox(height: 10),
            const Text(
              'Doubles (8):',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text('2019: Rwanda Doubles Open (Winner)'),
            const Text('2021: East Africa Doubles Masters (Champion)'),
            const Text('2022: Mid Grand Prix Doubles (Winner)'),
            const SizedBox(height: 10),
            const Text(
              'International Representation:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Represented Uganda in the African Tennis Confederation (ATC) tournaments, reaching the semi-finals twice.\nAchieved a career-high African regional ranking of #8 in 2023.',
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 10),
            const Text(
              'Playing Style:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Wanjiku hananny is celebrated for her fierce competitiveness and adaptability on the court. Her strong forehand and quick footwork make her a formidable opponent in singles matches, while her exceptional net play and teamwork shine in doubles competitions. She is particularly known for her performance under pressure, often turning matches with her mental toughness and tactical adjustments. Critics have praised her for being a trailblazer in Ugandan women\'s tennis, inspiring a new generation of players.',
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 10),
            const Text(
              'Philanthropy and Advocacy:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'She is also an advocate for better funding and infrastructure for women\'s sports in Uganda, working closely with local organizations and governmental bodies to improve access to tennis.',
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 10),
            const Text(
              'Future Aspirations:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Grace Akullo aims to break into the top 5 in African rankings and dreams of competing in Grand Slam tournaments. She is passionate about mentoring young Ugandan players and establishing a local tennis academy dedicated to developing tennis talent in Uganda.',
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchesTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTournamentSection(),
            _buildMatchTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsTab() {
    return SingleChildScrollView(
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
                StatBox(
                    title: 'Service Games\nwon', value: '50%', year: '2024'),
                StatBox(
                    title: 'Return Games\nwon', value: '40.0%', year: '2024'),
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
    );
  }

  Widget _buildRankingTab() {
    return SingleChildScrollView(
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
                _buildRankingBox(
                    "Currents", widget.player.ranking?.toString() ?? "1", ""),
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
                      Expanded(
                          flex: 1,
                          child: Text("Date",
                              style: TextStyle(fontSize: 14))),
                      Expanded(
                          flex: 2,
                          child: Text("Top Rank by year",
                              style: TextStyle(fontSize: 14))),
                      Expanded(
                          flex: 2,
                          child: Text("Year-end Ranking",
                              style: TextStyle(fontSize: 14))),
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

  TableRow _buildMatchRow(String round, String opponent, String oppRank,
      String result, List<String> scores, bool? isWin) {
    Color resultColor =
        isWin == null ? Colors.black : (isWin ? const Color(0xFF0066CC) : Colors.red);

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
              children: scores
                  .map((score) => Text(
                        score,
                        style: TextStyle(color: resultColor),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRankingBox(String title, String value, String date) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD0D0D0)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 20)),
          const Spacer(),
          Center(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 50,
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