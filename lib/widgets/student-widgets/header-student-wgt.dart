import 'package:flutter/material.dart';

class HeaderStudentWdgt extends StatelessWidget {
  final String title;
  final String subtitle;
  final String logoAsset;
  final double logoHeight;

  const HeaderStudentWdgt({
    super.key,
    required this.title,
    required this.subtitle,
    this.logoAsset = "assets/images/tutophia-logo-white-outline.png",
    this.logoHeight = 60,
  });

  // ── Named constructors for each student screen ──

  const HeaderStudentWdgt.dashboard({Key? key})
    : this(
        key: key,
        title: "DASHBOARD",
        subtitle: "Learn Smarter. Achieve Greater",
      );

  const HeaderStudentWdgt.bookings({Key? key})
    : this(
        key: key,
        title: "BOOKINGS",
        subtitle: "Learn Smarter. Achieve Greater",
      );

  const HeaderStudentWdgt.findTutors({Key? key})
    : this(
        key: key,
        title: "FIND TUTORS",
        subtitle: "Find the right tutor for your learning goals",
      );

  const HeaderStudentWdgt.feedback({Key? key})
    : this(
        key: key,
        title: "FEEDBACK",
        subtitle: "Review tutor advice and put your rating",
      );

  const HeaderStudentWdgt.sessionMaterials({Key? key})
    : this(
        key: key,
        title: "SESSION MATERIALS",
        subtitle: "Access materials shared by your tutors",
      );

  const HeaderStudentWdgt.booking({Key? key})
    : this(
        key: key,
        title: "BOOKING",
        subtitle: "Fill in the details to book a session",
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3d6fa5),
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
            ],
          ),
        ),
        Image.asset(
          logoAsset,
          height: logoHeight,
          errorBuilder: (c, e, s) => const Icon(Icons.school, size: 35),
        ),
      ],
    );
  }
}
