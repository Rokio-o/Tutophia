import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tutophia/data/student-data/tutor_repository.dart';
import 'package:tutophia/models/student-model/feedback_data.dart';
import 'package:tutophia/models/student-model/tutor_data.dart';
import 'package:tutophia/StudentAccess/menu-subscreens/tutor_booking.dart';
import 'package:tutophia/widgets/profile-avatar.dart';
import 'package:tutophia/widgets/student-widgets/reviews_list.dart';

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
              width: 124,
              height: 124,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black87, width: 1),
              ),
              padding: const EdgeInsets.all(2),
              child: ProfileAvatar(
                size: 120,
                iconSize: 60,
                imageSource: tutor.imagePath,
                userId: tutor.uid,
              ),
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
                    tutor.subjects.isEmpty
                        ? "No specialization provided yet"
                        : tutor.subjects.join(", "),
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
                  _buildEvidenceLinkRow(context),

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

                  _buildSectionTitle("Recent Reviews"),
                  FutureBuilder<List<ReviewData>>(
                    future: fetchRecentTutorReviews(tutor.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (snapshot.hasError) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: Text(
                            'Unable to load recent reviews right now.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        );
                      }

                      return FeedbackReviewsList(
                        reviews: snapshot.data ?? const <ReviewData>[],
                      );
                    },
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

      // ── Book a Session Button ──
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

  Widget _buildEvidenceLinkRow(BuildContext context) {
    final evidenceLink = tutor.portfolioLink.trim();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            flex: 2,
            child: Text(
              'Tutor Evidence Link',
              style: TextStyle(fontSize: 14, color: Color(0xff3d6fa5)),
            ),
          ),
          Expanded(
            flex: 3,
            child: evidenceLink.isEmpty
                ? const Text(
                    'Not provided',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  )
                : InkWell(
                    onTap: () => _openEvidenceLink(context, evidenceLink),
                    child: Text(
                      evidenceLink,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xff3d6fa5),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _openEvidenceLink(BuildContext context, String rawLink) async {
    final normalizedLink =
        rawLink.startsWith('http://') || rawLink.startsWith('https://')
        ? rawLink
        : 'https://$rawLink';
    final uri = Uri.tryParse(normalizedLink);

    if (uri == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The tutor evidence link is invalid.')),
      );
      return;
    }

    final didLaunch = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!didLaunch && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to open the tutor evidence link.'),
        ),
      );
    }
  }
}
