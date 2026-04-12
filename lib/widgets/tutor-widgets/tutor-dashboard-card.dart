import 'package:flutter/material.dart';
import 'package:tutophia/widgets/profile-avatar.dart';

class TutorDashboardCard extends StatelessWidget {
  final String name;
  final String tutorType;
  final String course;
  final int upcomingSessions;
  final int bookingRequests;
  final String? profileImageSource;

  const TutorDashboardCard({
    super.key,
    required this.name,
    required this.tutorType,
    required this.course,
    required this.upcomingSessions,
    required this.bookingRequests,
    this.profileImageSource,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xfff4a24c),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // ── Profile Row ──
          Row(
            children: [
              ProfileAvatar(
                size: 75,
                iconSize: 40,
                imageSource: profileImageSource,
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    tutorType,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(course, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Stats Row ──
          Row(
            children: [
              Expanded(
                child: _statCard(
                  upcomingSessions.toString(),
                  "Upcoming\nSessions",
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _statCard(
                  bookingRequests.toString(),
                  "Booking\nRequests",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard(String number, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xff3d6fa5),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
