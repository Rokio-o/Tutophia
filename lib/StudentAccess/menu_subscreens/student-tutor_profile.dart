import 'package:flutter/material.dart';
import '../models/tutor_data.dart';
import 'tutor_booking.dart';

class StudentTutorProfileScreen extends StatelessWidget {
  final TutorData tutor;

  const StudentTutorProfileScreen({super.key, required this.tutor});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xff3d6fa5);
    const Color beigeBackground = Color(0xFFFEF7F0);

    // Tutor profile screen.
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
        child: Column(
          children: [
            const Text(
              "PROFILE",
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black87, width: 1),
                image: tutor.imagePath.isNotEmpty
                    ? DecorationImage(
                        image: AssetImage(tutor.imagePath),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: tutor.imagePath.isEmpty
                  ? const Icon(Icons.person, size: 60, color: Colors.grey)
                  : null,
            ),

            const SizedBox(height: 15),

            Text(
              tutor.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Text(
              tutor.role,
              style: const TextStyle(fontSize: 14, color: primaryBlue),
            ),

            const SizedBox(height: 5),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tutor.rating,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.star, color: Colors.yellow, size: 16),
              ],
            ),

            Text(
              tutor.reviews.replaceAll(RegExp(r'[()]'), ''),
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: beigeBackground,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Column(
                children: [
                  const Text(
                    "Area of Specializations",
                    style: TextStyle(
                      color: primaryBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    tutor.subjects.join(", "),
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    tutor.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, height: 1.5),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Academic & Professional Credentials"),
                  _buildInfoRow("Department", tutor.department),
                  _buildInfoRow("Program", tutor.program),
                  _buildInfoRow("Year Level", tutor.yearLevel),
                  _buildInfoRow(
                    "Tutoring Experience",
                    tutor.tutoringExperience,
                  ),

                  const Divider(
                    height: 30,
                    thickness: 1,
                    color: Colors.black12,
                  ),

                  _buildSectionTitle("Tutoring Service"),
                  _buildInfoRow("Mode", tutor.mode),
                  _buildInfoRow("Session Duration", tutor.sessionDuration),
                  _buildInfoRow("Session Rate", tutor.sessionRate),

                  const Divider(
                    height: 30,
                    thickness: 1,
                    color: Colors.black12,
                  ),

                  _buildSectionTitle("Available Schedule"),
                  ...tutor.availableSchedule.map(
                    (schedule) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(schedule),
                    ),
                  ),

                  const Divider(
                    height: 30,
                    thickness: 1,
                    color: Colors.black12,
                  ),

                  _buildSectionTitle("Contact Information"),
                  _buildInfoRow("Email Address", tutor.email),
                  _buildInfoRow("Contact Number", tutor.contactNumber),
                  _buildInfoRow("Messenger", tutor.messenger),
                  _buildInfoRow("Instagram", tutor.instagram),
                  _buildInfoRow("Others", tutor.others),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Open booking form for this tutor.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        StudentTutorBookingScreen(tutor: tutor),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Book a Session",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xff3d6fa5),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Color(0xff3d6fa5)),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
