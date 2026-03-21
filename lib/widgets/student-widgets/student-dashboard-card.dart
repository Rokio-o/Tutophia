import 'package:flutter/material.dart';

class StudentDashboardCard extends StatelessWidget {
  final String name;
  final String course;
  final int upcomingSessions;
  final int pendingBookings;
  final int newMaterials;
  final String? profileImagePath;

  const StudentDashboardCard({
    super.key,
    required this.name,
    required this.course,
    required this.upcomingSessions,
    required this.pendingBookings,
    required this.newMaterials,
    this.profileImagePath,
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
              Container(
                width: 75,
                height: 75,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: ClipOval(
                  child: profileImagePath != null
                      ? Image.asset(
                          profileImagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) =>
                              const Icon(Icons.person, size: 40),
                        )
                      : const Icon(Icons.person, size: 40),
                ),
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
                  const Text(
                    "Student",
                    style: TextStyle(color: Colors.white70),
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
              const SizedBox(width: 10),
              Expanded(
                child: _statCard(
                  pendingBookings.toString(),
                  "Pending\nBookings",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statCard(newMaterials.toString(), "New\nMaterials"),
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
