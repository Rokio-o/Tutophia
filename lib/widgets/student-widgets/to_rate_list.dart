import 'package:flutter/material.dart';

class FeedbackToRateList extends StatelessWidget {
  // List of items to display
  final List<Map<String, String>> items;

  // Callback when "Rate" is tapped
  final Function(Map<String, String>) onRateTap;

  const FeedbackToRateList({
    super.key,
    required this.items,
    required this.onRateTap,
  });

  @override
  Widget build(BuildContext context) {
    // Show message if no data
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

    // Display list of items
    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),

            // Card styling
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

            // Layout: Icon | Info | Rate button
            child: Row(
              children: [
                const Icon(Icons.account_circle, size: 48),

                const SizedBox(width: 14),

                // Takes remaining space
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['name'] ?? ''),
                      Text(item['role'] ?? ''),
                    ],
                  ),
                ),

                // Trigger rating action
                GestureDetector(
                  onTap: () => onRateTap(item),
                  child: const Text('Rate'),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
