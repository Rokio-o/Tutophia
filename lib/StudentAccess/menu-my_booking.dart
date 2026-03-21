import 'package:flutter/material.dart';
import 'package:tutophia/data/student-data/booking_repository.dart';
import 'package:tutophia/widgets/student-widgets/booking_card_widget.dart';
import 'package:tutophia/widgets/student-widgets/header-student-wgt.dart';
import 'package:tutophia/widgets/student-widgets/bottom-navigation-student.dart';

class StudentBookingsScreen extends StatefulWidget {
  const StudentBookingsScreen({super.key});

  @override
  State<StudentBookingsScreen> createState() => _StudentBookingsScreenState();
}

class _StudentBookingsScreenState extends State<StudentBookingsScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Screen that displays all student bookings.
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
              // ── Bookings Header ──
              child: const HeaderStudentWdgt.bookings(),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: activeBookings.isEmpty
                  ? const Center(
                      child: Text(
                        "No bookings yet.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: activeBookings.length,
                      itemBuilder: (context, index) {
                        return BookingCardWidget(
                          booking: activeBookings[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // ── Bottom Navigation ──
      bottomNavigationBar: BottomNavStudent(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
