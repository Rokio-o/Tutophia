import 'package:flutter/material.dart';
import 'package:tutophia/model/student-model/booking_data.dart';
import 'package:tutophia/widgets/student-widgets/tutor_summary_card.dart';

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "BOOKINGS",
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff3d6fa5),
                        ),
                      ),
                      Text(
                        "Learn Smarter. Achieve Greater",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  Image.asset(
                    "assets/images/tutophia-logo-white-outline.png",
                    height: 60,
                    width: 60,
                    errorBuilder: (context, error, stackTrace) => CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      radius: 25,
                      child: const Icon(
                        Icons.school,
                        color: Color(0xfff4a24c),
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),

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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notification",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
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
