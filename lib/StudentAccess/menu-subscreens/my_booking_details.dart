import 'package:flutter/material.dart';
import 'package:tutophia/models/student-model/booking_data.dart';
import 'package:tutophia/widgets/student-widgets/tutor_summary_card.dart';
import 'package:tutophia/widgets/student-widgets/header-student-wgt.dart';
import 'package:tutophia/widgets/student-widgets/bottom-navigation-student.dart';

class MyBookingDetailsScreen extends StatelessWidget {
  final BookingData booking;

  const MyBookingDetailsScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    const Color labelBlue = Color(0xff2A84D0);

    // Screen showing complete booking details.
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Bookings Header ──
              const HeaderStudentWdgt.bookings(),

              const SizedBox(height: 20),

              TutorSummaryCard(
                name: booking.tutorName,
                role: booking.role,
                imagePath: booking.imagePath,
              ),

              const SizedBox(height: 30),

              const Text(
                "Booking Information",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),

              const SizedBox(height: 20),

              _buildInfoRow("Date:", booking.date, labelBlue),
              _buildInfoRow("Time:", booking.time, labelBlue),
              _buildInfoRow("Duration:", booking.duration, labelBlue),
              _buildInfoRow("Mode:", booking.mode, labelBlue),
              _buildInfoRow("Location:", booking.location, labelBlue),
              _buildInfoRow(
                "Subject Target:",
                booking.subjectTarget,
                labelBlue,
              ),

              const SizedBox(height: 10),

              Text(
                "Reason:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: labelBlue,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                booking.reason,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 30),

              Text(
                "Booking Status:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: labelBlue,
                ),
              ),

              const SizedBox(height: 10),

              _buildLargeStatusBanner(booking.status),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),

      // ── Bottom Navigation ──
      bottomNavigationBar: BottomNavStudent(currentIndex: 0, onTap: (_) {}),
    );
  }

  // Reusable row for booking details.
  Widget _buildInfoRow(String label, String value, Color labelColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: labelColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  // Large colored status banner.
  Widget _buildLargeStatusBanner(String status) {
    Color bannerColor;

    if (status == "APPROVED") {
      bannerColor = const Color(0xFF2ECC71);
    } else if (status == "DECLINED") {
      bannerColor = const Color(0xFFFF3B30);
    } else {
      bannerColor = const Color(0xFF9EA3A8);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: bannerColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        status,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
