import 'package:flutter/material.dart';
import 'package:tutophia/TutorAccess/dashboard-tutor.dart';
import 'package:tutophia/widgets/tutor-widgets/student-profile-card.dart';
import 'package:tutophia/widgets/tutor-widgets/session-details-card.dart';
import 'package:tutophia/widgets/tutor-widgets/header-tutor-wdgt.dart';
import 'package:tutophia/TutorAccess/notification-tutor.dart';
import 'package:tutophia/TutorAccess/profile-tutor.dart';
import 'package:tutophia/widgets/tutor-widgets/bottom-navigation-tutor.dart';
import 'package:tutophia/TutorAccess/tutor-menu/session-requests-tutor.dart';
import 'package:tutophia/TutorAccess/tutor-menu/view-student-profile.dart';
import 'package:tutophia/data/student-data/booking_repository.dart';
import 'package:tutophia/models/student-model/booking_data.dart';

class SessionDetailsScreen extends StatefulWidget {
  final BookingData booking;

  const SessionDetailsScreen({super.key, required this.booking});

  @override
  State<SessionDetailsScreen> createState() => _SessionDetailsScreenState();
}

class _SessionDetailsScreenState extends State<SessionDetailsScreen> {
  int _selectedIndex = 0;
  bool _busy = false;

  Future<void> _markComplete() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await BookingRepository.instance.completeBooking(
        widget.booking.bookingId,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session marked as completed.')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to complete session: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _cancelSession() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await BookingRepository.instance.cancelBooking(
        widget.booking.bookingId,
        'tutor',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Session cancelled.')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to cancel session: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SessionRequestsScreen()),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderTutorWdgt.sessionRequests(),
              const SizedBox(height: 25),
              StudentProfileCard(
                name: booking.studentName,
                program: booking.studentProgram,
                studentId: booking.studentId,
                onViewProfile: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TutorStudentProfileScreen(
                      studentId: booking.studentId,
                      fallbackName: booking.studentName,
                      fallbackProgram: booking.studentProgram,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SessionRequestDetailsCard(
                date: _formatDate(booking.sessionDateTime),
                time:
                    '${_formatTime(booking.sessionDateTime)} to ${_formatTime(booking.endDateTime)}',
                duration: '${booking.durationMinutes} minutes',
                mode: booking.mode,
                location: booking.location.isEmpty
                    ? 'Not specified'
                    : booking.location,
                subject: booking.subject,
                subjectSubtitle: booking.topic.isEmpty
                    ? 'Not Limited'
                    : booking.topic,
                reason: booking.studentNotes,
              ),
              const SizedBox(height: 12),
              if (booking.meetingLink.trim().isNotEmpty)
                SelectableText(
                  'Meeting link: ${booking.meetingLink}',
                  style: const TextStyle(color: Colors.black87),
                ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _busy ? null : _markComplete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 18, 192, 24),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Mark Completed',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _busy ? null : _cancelSession,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 239, 28, 13),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        tabActions: [
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TutorDashboard()),
          ),
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TutorNotificationScreen()),
          ),
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TutorProfileScreen()),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime value) {
    return '${value.month}/${value.day}/${value.year}';
  }

  String _formatTime(DateTime value) {
    final hour = value.hour == 0
        ? 12
        : (value.hour > 12 ? value.hour - 12 : value.hour);
    final minute = value.minute.toString().padLeft(2, '0');
    final suffix = value.hour >= 12 ? 'pm' : 'am';
    return '$hour:$minute $suffix';
  }
}
