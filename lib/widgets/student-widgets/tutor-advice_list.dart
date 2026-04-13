import 'package:flutter/material.dart';
import 'package:tutophia/models/student-model/feedback_data.dart';
import 'package:tutophia/widgets/profile-avatar.dart';

class TutorAdviceList extends StatelessWidget {
  final List<TutorAdviceData> adviceList;

  const TutorAdviceList({super.key, required this.adviceList});

  @override
  Widget build(BuildContext context) {
    if (adviceList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 40),
          child: Text(
            'No advice from tutors yet.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      children: adviceList.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 22),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Tutor info row ──
                Row(
                  children: [
                    ProfileAvatar(
                      size: 48,
                      iconSize: 28,
                      imageSource: item.imagePath,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.tutorName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          if (item.tutorRole != null)
                            Text(
                              item.tutorRole!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Advice label ──
                const Text(
                  'Tutor\'s Advice',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff3d6fa5),
                  ),
                ),

                const SizedBox(height: 10),

                // ── Advice content box ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  constraints: const BoxConstraints(minHeight: 96),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xff3d6fa5)),
                  ),
                  child: Text(
                    item.advice,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
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
