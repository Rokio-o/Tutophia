import 'package:flutter/material.dart';

class StudentApplicationCard extends StatelessWidget {
  final String name;
  final String course;
  final String image;
  final bool hasImage;
  final String status; // 'pending' | 'approved' | 'rejected'
  final VoidCallback onViewTap;

  const StudentApplicationCard({
    super.key,
    required this.name,
    required this.course,
    required this.onViewTap,
    this.image = '',
    this.hasImage = false,
    this.status = 'pending',
  });

  // Card background based on status
  Color get _cardColor {
    switch (status) {
      case 'approved':
        return const Color.fromARGB(235, 195, 230, 210); // soft green
      case 'rejected':
        return const Color.fromARGB(235, 197, 195, 193); // grey
      default:
        return const Color.fromARGB(235, 255, 226, 195); // peach (pending)
    }
  }

  // Button color based on status
  Color get _buttonColor {
    switch (status) {
      case 'approved':
        return const Color(0xFF2E7D32); // dark green
      case 'rejected':
        return const Color(0xFFEF1C0D); // red
      default:
        return const Color(0xFF3D6FA5); // blue (pending)
    }
  }

  // Button label based on status
  String get _buttonLabel {
    switch (status) {
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      default:
        return 'View Application';
    }
  }

  // Avatar — greyscale when rejected
  Widget _buildAvatar() {
    Widget avatarChild = hasImage && image.isNotEmpty
        ? ClipOval(
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) =>
                  const Icon(Icons.person, size: 45, color: Colors.grey),
            ),
          )
        : const Icon(Icons.person, size: 45, color: Colors.grey);

    final circleAvatar = Container(
      width: 70,
      height: 70,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: avatarChild,
    );

    if (status == 'rejected') {
      return ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]),
        child: circleAvatar,
      );
    }

    return circleAvatar;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              _buildAvatar(),

              const SizedBox(width: 15),

              // Name + Course
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: status == 'rejected'
                            ? Colors.black45
                            : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Student',
                      style: TextStyle(
                        fontSize: 12,
                        color: status == 'rejected'
                            ? Colors.black38
                            : const Color(0xFF3D6FA5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      course,
                      style: TextStyle(
                        fontSize: 13,
                        color: status == 'rejected'
                            ? Colors.black38
                            : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // Action button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              // Only tappable when pending
              onPressed: status == 'pending' ? onViewTap : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _buttonColor,
                disabledBackgroundColor: _buttonColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: status == 'pending' ? 2 : 0,
              ),
              child: Text(
                _buttonLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
