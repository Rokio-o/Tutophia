import 'package:flutter/material.dart';

class SessionRequestDetailsCard extends StatelessWidget {
  // Booking Information
  final String date;
  final String time;
  final String duration;
  final String mode;
  final String location;

  // Main Subject Target
  final String subject;
  final String subjectSubtitle;

  // Reason
  final String reason;

  const SessionRequestDetailsCard({
    super.key,
    required this.date,
    required this.time,
    required this.duration,
    required this.mode,
    required this.location,
    required this.subject,
    this.subjectSubtitle = "Not Limited",
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Booking Information ──
        const Text(
          "Booking Information",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff3d6fa5),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: _boxDecoration(),
          child: Column(
            children: [
              _infoRow("Date", date),
              _divider(),
              _infoRow("Time", time),
              _divider(),
              _infoRow("Duration", duration),
              _divider(),
              _infoRow("Mode", mode),
              _divider(),
              _infoRow("Location", location),
            ],
          ),
        ),

        const SizedBox(height: 25),

        // ── Main Subject Target ──
        const Text(
          "Main Subject Target",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff3d6fa5),
          ),
        ),
        Text(
          subjectSubtitle,
          style: const TextStyle(
            fontSize: 12,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 155, 155, 155),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: _boxDecoration(),
          child: Text(
            subject,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),

        const SizedBox(height: 25),

        // ── Reason ──
        const Text(
          "Reason",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff3d6fa5),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: _boxDecoration(),
          child: Text(
            reason,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  // ── Private helpers ──────────────────────────────────────────────────────────

  BoxDecoration _boxDecoration() => BoxDecoration(
    color: Colors.grey.shade50,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.grey.shade300),
  );

  Widget _infoRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    ),
  );

  Widget _divider() => Divider(color: Colors.grey.shade300, height: 1);
}
