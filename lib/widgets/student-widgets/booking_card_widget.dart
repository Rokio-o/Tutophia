import 'package:flutter/material.dart';
import 'package:tutophia/StudentAccess/menu-subscreens/my_booking_details.dart';
import 'package:tutophia/model/student-model/booking_data.dart';

class BookingCardWidget extends StatelessWidget {
  final BookingData booking;

  const BookingCardWidget({super.key, required this.booking});

  Color _getStatusColor(String status) {
    if (status == "APPROVED") {
      return const Color(0xFF2ECC71);
    } else if (status == "DECLINED") {
      return const Color(0xFFFF3B30);
    } else {
      return const Color(0xFF9EA3A8);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Booking card used in My Bookings screen.
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF3B87A),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade600,
              image: booking.imagePath.isNotEmpty
                  ? DecorationImage(
                      image: AssetImage(booking.imagePath),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: booking.imagePath.isEmpty
                ? const Icon(Icons.person, size: 50, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.tutorName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  booking.role,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      "Booking Status: ",
                      style: TextStyle(fontSize: 13, color: Colors.black),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(booking.status),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        booking.status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MyBookingDetailsScreen(booking: booking),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff3d6fa5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        elevation: 0,
                      ),
                      child: const Text(
                        "View Details",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
