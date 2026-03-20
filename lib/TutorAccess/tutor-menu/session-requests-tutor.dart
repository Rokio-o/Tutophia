import 'package:flutter/material.dart';
import 'package:tutophia/TutorAccess/dashboard-tutor.dart';
import 'package:tutophia/TutorAccess/profile-tutor.dart';
import 'package:tutophia/TutorAccess/notification-tutor.dart';
import 'package:tutophia/TutorAccess/tutor-menu/view-session-request.dart';
import 'package:tutophia/widgets/tutor-widgets/session-card.dart';
import 'package:tutophia/widgets/tutor-widgets/bottom-navigation-tutor.dart';
import 'package:tutophia/widgets/tutor-widgets/header-tutor-wdgt.dart';
import 'package:tutophia/TutorAccess/tutor-menu/view-session-details.dart';

class SessionRequestsScreen extends StatefulWidget {
  const SessionRequestsScreen({super.key});

  @override
  State<SessionRequestsScreen> createState() => _SessionRequestsScreenState();
}

class _SessionRequestsScreenState extends State<SessionRequestsScreen> {
  String _selectedTab = 'Requests';
  int _selectedIndex = 0;

  final List<Map<String, String>> _requestStudents = [
    {'name': 'Student Name', 'course': 'Program'},
    {'name': 'Student Name', 'course': 'Program'},
  ];

  final List<Map<String, String>> _approvedStudents = [
    {'name': 'Student Name', 'course': 'Program'},
  ];

  final List<Map<String, String>> _cancelledStudents = [
    {'name': 'Student Name', 'course': 'Program'},
  ];

  Widget _tabButton(String label) {
    final bool selected = _selectedTab == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xffc6d3df) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xff9c6b6b)),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TutorDashboard()),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              const HeaderTutorWdgt.sessionRequests(),

              const SizedBox(height: 20),

              // ── Tab Buttons ──
              Row(
                children: [
                  _tabButton('Requests'),
                  const SizedBox(width: 12),
                  _tabButton('Approved'),
                ],
              ),

              const SizedBox(height: 20),

              // ── Requests Tab ──
              if (_selectedTab == 'Requests')
                ..._requestStudents.map(
                  (s) => Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: RequestCard(
                      name: s['name']!,
                      course: s['course']!,
                      buttonText: 'View Request',
                      onButtonTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SessionRequestDetailsScreen(),
                        ),
                      ),
                    ),
                  ),
                ),

              // ── Approved Tab ──
              if (_selectedTab == 'Approved') ...[
                ..._approvedStudents.map(
                  (s) => Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: RequestCard(
                      name: s['name']!,
                      course: s['course']!,
                      buttonText: 'View Session Details',
                      onButtonTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SessionDetailsScreen(),
                        ),
                      ),
                    ),
                  ),
                ),
                ..._cancelledStudents.map(
                  (s) => Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: CancelledRequestCard(
                      name: s['name']!,
                      course: s['course']!,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),

      // ── Bottom Navigation ──
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        tabActions: [
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TutorDashboard()),
          ),
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TutorNotificationScreen()),
          ),
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TutorProfileScreen()),
          ),
        ],
      ),
    );
  }
}
