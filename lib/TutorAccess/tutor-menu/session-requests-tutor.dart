import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutophia/TutorAccess/dashboard-tutor.dart';
import 'package:tutophia/TutorAccess/profile-tutor.dart';
import 'package:tutophia/TutorAccess/notification-tutor.dart';
import 'package:tutophia/TutorAccess/tutor-menu/view-session-request.dart';
import 'package:tutophia/widgets/tutor-widgets/session-card.dart';
import 'package:tutophia/widgets/tutor-widgets/bottom-navigation-tutor.dart';
import 'package:tutophia/widgets/tutor-widgets/header-tutor-wdgt.dart';
import 'package:tutophia/TutorAccess/tutor-menu/view-session-details.dart';
import 'package:tutophia/data/student-data/booking_repository.dart';
import 'package:tutophia/models/student-model/booking_data.dart';

class SessionRequestsScreen extends StatefulWidget {
  const SessionRequestsScreen({super.key});

  @override
  State<SessionRequestsScreen> createState() => _SessionRequestsScreenState();
}

class _SessionRequestsScreenState extends State<SessionRequestsScreen> {
  String _selectedTab = 'Requests';
  int _selectedIndex = 0;

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
    final tutorId = FirebaseAuth.instance.currentUser?.uid;

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
              const HeaderTutorWdgt.sessionRequests(),
              const SizedBox(height: 20),
              Row(
                children: [
                  _tabButton('Requests'),
                  const SizedBox(width: 12),
                  _tabButton('Approved'),
                ],
              ),
              const SizedBox(height: 20),
              if (tutorId == null)
                const Center(
                  child: Text('Please login to view requests.'),
                )
              else
                StreamBuilder<List<BookingData>>(
                  stream: BookingRepository.instance.watchTutorBookings(tutorId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error loading requests: ${snapshot.error}',
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      );
                    }

                    final all = snapshot.data ?? const <BookingData>[];
                    final pending = all
                        .where((b) => b.status == BookingData.statusPending)
                        .toList();
                    final approved = all
                        .where((b) => b.status == BookingData.statusApproved)
                        .toList();
                    final cancelled = all
                        .where((b) => b.status == BookingData.statusCancelled)
                        .toList();

                    if (_selectedTab == 'Requests') {
                      if (pending.isEmpty) {
                        return const Center(child: Text('No pending requests.'));
                      }

                      return Column(
                        children: pending
                            .map(
                              (s) => Padding(
                                padding: const EdgeInsets.only(bottom: 18),
                                child: RequestCard(
                                  name: s.studentName,
                                  course: s.studentProgram,
                                  buttonText: 'View Request',
                                  onButtonTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          SessionRequestDetailsScreen(
                                            booking: s,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      );
                    }

                    if (approved.isEmpty && cancelled.isEmpty) {
                      return const Center(child: Text('No approved sessions.'));
                    }

                    return Column(
                      children: [
                        ...approved.map(
                          (s) => Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: RequestCard(
                              name: s.studentName,
                              course: s.studentProgram,
                              buttonText: 'View Session Details',
                              onButtonTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SessionDetailsScreen(
                                    booking: s,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ...cancelled.map(
                          (s) => Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: CancelledRequestCard(
                              name: s.studentName,
                              course: s.studentProgram,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
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
