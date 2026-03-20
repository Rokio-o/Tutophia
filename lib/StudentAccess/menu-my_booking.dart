import 'package:flutter/material.dart';
import 'package:tutophia/data/student-data/booking_repository.dart';
import 'package:tutophia/widgets/student-widgets/booking_card_widget.dart';

class StudentBookingsScreen extends StatefulWidget {
  const StudentBookingsScreen({super.key});

  @override
  State<StudentBookingsScreen> createState() => _StudentBookingsScreenState();
}

class _StudentBookingsScreenState extends State<StudentBookingsScreen> {
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
              child: Row(
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
}
