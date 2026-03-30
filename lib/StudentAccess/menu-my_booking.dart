import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutophia/data/student-data/booking_repository.dart';
import 'package:tutophia/models/student-model/booking_data.dart';
import 'package:tutophia/widgets/student-widgets/booking_card_widget.dart';
import 'package:tutophia/widgets/student-widgets/header-student-wgt.dart';
import 'package:tutophia/widgets/student-widgets/bottom-navigation-student.dart';
import 'package:tutophia/StudentAccess/notifications-student.dart';
import 'package:tutophia/StudentAccess/profile-student.dart';

class StudentBookingsScreen extends StatefulWidget {
  const StudentBookingsScreen({super.key});

  @override
  State<StudentBookingsScreen> createState() => _StudentBookingsScreenState();
}

class _StudentBookingsScreenState extends State<StudentBookingsScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

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
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const HeaderStudentWdgt.bookings(),
            ),
            const SizedBox(height: 20),
            if (uid == null)
              const Expanded(
                child: Center(
                  child: Text(
                    'Please log in to view bookings.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              )
            else
              Expanded(
                child: StreamBuilder<List<BookingData>>(
                  stream: BookingRepository.instance.watchStudentBookings(uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error loading bookings: ${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      );
                    }

                    final bookings = snapshot.data ?? const <BookingData>[];
                    if (bookings.isEmpty) {
                      return const Center(
                        child: Text(
                          'No bookings yet.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    return ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        _buildStatusSection(
                          title: 'Pending',
                          bookings: bookings
                              .where(
                                (b) => b.status == BookingData.statusPending,
                              )
                              .toList(),
                        ),
                        _buildStatusSection(
                          title: 'Approved',
                          bookings: bookings
                              .where(
                                (b) => b.status == BookingData.statusApproved,
                              )
                              .toList(),
                        ),
                        _buildStatusSection(
                          title: 'Cancelled',
                          bookings: bookings
                              .where(
                                (b) => b.status == BookingData.statusCancelled,
                              )
                              .toList(),
                        ),
                        _buildStatusSection(
                          title: 'Completed',
                          bookings: bookings
                              .where(
                                (b) => b.status == BookingData.statusCompleted,
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 12),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavStudent(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const StudentNotificationsScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StudentProfileScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _buildStatusSection({
    required String title,
    required List<BookingData> bookings,
  }) {
    if (bookings.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...bookings.map((booking) => BookingCardWidget(booking: booking)),
        const SizedBox(height: 8),
      ],
    );
  }
}
