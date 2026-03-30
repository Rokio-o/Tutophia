import 'package:flutter/material.dart';
import 'package:tutophia/data/student-data/booking_repository.dart';
import 'package:tutophia/models/student-model/booking_data.dart';
import 'package:tutophia/widgets/student-widgets/tutor_summary_card.dart';
import 'package:tutophia/widgets/student-widgets/header-student-wgt.dart';
import 'package:tutophia/widgets/student-widgets/bottom-navigation-student.dart';

class MyBookingDetailsScreen extends StatefulWidget {
  final BookingData booking;

  const MyBookingDetailsScreen({super.key, required this.booking});

  @override
  State<MyBookingDetailsScreen> createState() => _MyBookingDetailsScreenState();
}

class _MyBookingDetailsScreenState extends State<MyBookingDetailsScreen> {
  bool _updating = false;

  Future<void> _cancelAsStudent() async {
    if (_updating) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _updating = true);
    try {
      await BookingRepository.instance.cancelBooking(
        widget.booking.bookingId,
        'student',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking cancelled.')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel booking: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _updating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color labelBlue = Color(0xff2A84D0);
    final booking = widget.booking;

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
              const HeaderStudentWdgt.bookings(),
              const SizedBox(height: 20),
              TutorSummaryCard(
                name: booking.tutorName,
                role: booking.tutorType,
                imagePath: booking.tutorImagePath,
              ),
              const SizedBox(height: 30),
              const Text(
                'Booking Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 20),
              _buildInfoRow('Date:', _formatDate(booking.sessionDateTime), labelBlue),
              _buildInfoRow(
                'Time:',
                '${_formatTime(booking.sessionDateTime)} to ${_formatTime(booking.endDateTime)}',
                labelBlue,
              ),
              _buildInfoRow(
                'Duration:',
                '${booking.durationMinutes} minutes',
                labelBlue,
              ),
              _buildInfoRow('Mode:', booking.mode, labelBlue),
              _buildInfoRow('Location:', booking.location, labelBlue),
              _buildInfoRow('Subject Target:', booking.subject, labelBlue),
              _buildInfoRow('Topic:', booking.topic, labelBlue),
              _buildInfoRow(
                'Total Price:',
                'PHP ${booking.totalPrice.toStringAsFixed(2)}',
                labelBlue,
              ),
              const SizedBox(height: 10),
              Text(
                'Reason:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: labelBlue,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                booking.studentNotes,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Booking Status:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: labelBlue,
                ),
              ),
              const SizedBox(height: 10),
              _buildLargeStatusBanner(booking.status),
              const SizedBox(height: 24),
              if (booking.status == BookingData.statusPending ||
                  booking.status == BookingData.statusApproved)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updating ? null : _cancelAsStudent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _updating
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Cancel Booking',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavStudent(currentIndex: 0, onTap: (_) {}),
    );
  }

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

  Widget _buildLargeStatusBanner(String status) {
    Color bannerColor;

    if (status == BookingData.statusApproved) {
      bannerColor = const Color(0xFF2ECC71);
    } else if (status == BookingData.statusCancelled) {
      bannerColor = const Color(0xFFFF3B30);
    } else if (status == BookingData.statusCompleted) {
      bannerColor = const Color(0xFF2A84D0);
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
        status.toUpperCase(),
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

  String _formatDate(DateTime value) {
    return '${value.month}/${value.day}/${value.year}';
  }

  String _formatTime(DateTime value) {
    final hour = value.hour == 0 ? 12 : (value.hour > 12 ? value.hour - 12 : value.hour);
    final minute = value.minute.toString().padLeft(2, '0');
    final suffix = value.hour >= 12 ? 'pm' : 'am';
    return '$hour:$minute $suffix';
  }
}
