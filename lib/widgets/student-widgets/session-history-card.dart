import 'package:flutter/material.dart';
import 'package:tutophia/models/student-model/session-history-data.dart';

class SessionHistoryCard extends StatefulWidget {
  final SessionHistoryData data;

  const SessionHistoryCard({super.key, required this.data});

  @override
  State<SessionHistoryCard> createState() => _SessionHistoryCardState();
}

class _SessionHistoryCardState extends State<SessionHistoryCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xfffff8f2),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xffe0d6cc)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Collapsed header row ──
            Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffcccccc),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.tutorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      data.tutorRole,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      "Program: ${data.program}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      "Date Completed: ${data.dateCompleted}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // ── Expanded detail section ──
            if (_isExpanded) ...[
              const SizedBox(height: 16),
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffcccccc),
                ),
                child: const Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                data.tutorName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                data.tutorRole,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              Text(
                "Program: ${data.program}",
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              _detailRow("Mode:", data.mode),
              const SizedBox(height: 8),
              _detailRow("Subject:", data.subject),
              const SizedBox(height: 8),
              _detailRow("Date:", data.date),
              const SizedBox(height: 8),
              _detailRow("Session Duration:", data.sessionDuration),
              const SizedBox(height: 8),
              _detailRow("Time:", data.time),
              const SizedBox(height: 8),
              _detailRow("Fee:", data.fee),
            ],

            const SizedBox(height: 10),
            Text(
              _isExpanded ? "Click to Collapse" : "Click to expand",
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black38,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xfff4a24c),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xffe0e0e0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
