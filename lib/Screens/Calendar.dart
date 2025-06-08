
// import 'package:flutter/material.dart';

// class Calendar extends StatefulWidget {
//   const Calendar({Key? key}) : super(key: key);

//   @override
//   _CalendarState createState() => _CalendarState();
// }

// class _CalendarState extends State<Calendar> {
//   final Map<String, bool> _expandedMonths = {};

//   final List<MonthData> _tournaments = [
//     // [Keeping the tournament data unchanged]
//     MonthData(
//       month: 'December, 2024',
//       count: 3,
//       events: [
//         EventData(name: 'ATP Finals', location: 'Turin, Italy', dates: 'Dec 8-15'),
//         EventData(name: 'Davis Cup Finals', location: 'Malaga, Spain', dates: 'Dec 19-24'),
//         EventData(name: 'United Cup', location: 'Perth & Sydney, Australia', dates: 'Dec 27-Jan 5'),
//       ],
//     ),
//     // ... [Rest of the tournament data remains the same]
//   ];

//   void _toggleMonth(String month) {
//     setState(() {
//       _expandedMonths[month] = !(_expandedMonths[month] ?? false);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Row(
//           children: [
//             const Text(
//               'TOURNAMENTS',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(width: 8),
//             const Text(
//               '|',
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(width: 8),
//             Row(
//               children: [
//                 const Text(
//                   'Calendar',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(width: 4),
//                 const Icon(
//                   Icons.arrow_drop_down,
//                   size: 20,
//                   color: Colors.white,
//                 ),
//               ],
//             ),
//           ],
//         ),
//         backgroundColor: const Color.fromARGB(255, 23, 140, 250),
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Container(
//               color: Colors.white,
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       decoration: InputDecoration(
//                         hintText: 'Search events',
//                         prefixIcon: const Icon(Icons.search),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(4.0),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(vertical: 0),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         for (var month in _tournaments) {
//                           _expandedMonths[month.month] = true;
//                         }
//                       });
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       foregroundColor: Colors.white,
//                     ),
//                     child: const Text('Open All'),
//                   ),
//                   const SizedBox(width: 8),
//                   ElevatedButton.icon(
//                     onPressed: () {},
//                     icon: const Icon(Icons.download),
//                     label: const Text('2025-26 Calendar PDF'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       foregroundColor: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _tournaments.length,
//                 itemBuilder: (context, index) {
//                   final month = _tournaments[index];
//                   final isExpanded = _expandedMonths[month.month] ?? false;

//                   return Column(
//                     children: [
//                       InkWell(
//                         onTap: () => _toggleMonth(month.month),
//                         child: Container(
//                           color: Colors.white,
//                           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 children: [
//                                   Text(
//                                     month.month,
//                                     style: const TextStyle(fontWeight: FontWeight.w500),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   Text(
//                                     '(${month.count} events)',
//                                     style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                                   ),
//                                 ],
//                               ),
//                               Icon(
//                                 isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
//                                 color: Colors.grey[700],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       if (isExpanded)
//                         Container(
//                           color: Colors.grey[50],
//                           padding: const EdgeInsets.all(16.0),
//                           child: ListView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             itemCount: month.events.length,
//                             itemBuilder: (context, eventIndex) {
//                               final event = month.events[eventIndex];
//                               return Container(
//                                 margin: const EdgeInsets.only(bottom: 12.0),
//                                 padding: const EdgeInsets.only(left: 12.0),
//                                 decoration: BoxDecoration(
//                                   border: Border(
//                                     left: BorderSide(color: Colors.blue[600]!, width: 4.0),
//                                   ),
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       event.name,
//                                       style: const TextStyle(fontWeight: FontWeight.w500),
//                                     ),
//                                     const SizedBox(height: 2),
//                                     Text(
//                                       '${event.location} • ${event.dates}',
//                                       style: TextStyle(
//                                         color: Colors.grey[700],
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       Divider(height: 1, thickness: 1, color: Colors.grey[300]),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MonthData {
//   final String month;
//   final int count;
//   final List<EventData> events;

//   MonthData({required this.month, required this.count, required this.events});
// }

// class EventData {
//   final String name;
//   final String location;
//   final String dates;

//   EventData({required this.name, required this.location, required this.dates});
// }