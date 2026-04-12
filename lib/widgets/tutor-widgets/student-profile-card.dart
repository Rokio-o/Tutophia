import 'package:flutter/material.dart';
import 'package:tutophia/widgets/profile-avatar.dart';

class StudentProfileCard extends StatelessWidget {
  final String name;
  final String program;
  final String? studentId;
  final String? profileImageSource;
  final VoidCallback? onViewProfile;

  const StudentProfileCard({
    super.key,
    required this.name,
    required this.program,
    this.studentId,
    this.profileImageSource,
    this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color.fromARGB(235, 255, 226, 195),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ProfileAvatar(
            size: 70,
            iconSize: 45,
            imageSource: profileImageSource,
            userId: studentId,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  program,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onViewProfile,
                  child: const Text(
                    "View Student Profile",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff3d6fa5),
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
