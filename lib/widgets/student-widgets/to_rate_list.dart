import 'package:flutter/material.dart';
import 'package:tutophia/models/student-model/feedback_data.dart';
import 'package:tutophia/widgets/profile-avatar.dart';

class FeedbackToRateList extends StatelessWidget {
  final List<ToRateData> items;
  final Function(ToRateData) onRateTap;

  const FeedbackToRateList({
    super.key,
    required this.items,
    required this.onRateTap,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 40),
          child: Text(
            'No tutors to rate.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xfff7f1eb),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                ProfileAvatar(
                  size: 48,
                  iconSize: 28,
                  imageSource: item.imagePath,
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        item.role,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                // Rate button
                GestureDetector(
                  onTap: () => onRateTap(item),
                  child: const Text(
                    'Rate',
                    style: TextStyle(
                      color: Color(0xff3d6fa5),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xff3d6fa5),
                      decorationThickness: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
