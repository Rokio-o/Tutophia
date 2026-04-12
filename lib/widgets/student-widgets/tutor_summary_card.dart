import 'package:flutter/material.dart';
import 'package:tutophia/widgets/profile-avatar.dart';

class TutorSummaryCard extends StatelessWidget {
  final String name;
  final String role;
  final String imagePath;

  const TutorSummaryCard({
    super.key,
    required this.name,
    required this.role,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    // Summary card used in booking details screen.
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF3B87A),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 79,
            height: 79,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade600,
              border: Border.all(color: Colors.black, width: 1.5),
            ),
            padding: const EdgeInsets.all(2),
            child: ProfileAvatar(
              size: 75,
              iconSize: 50,
              imageSource: imagePath,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
