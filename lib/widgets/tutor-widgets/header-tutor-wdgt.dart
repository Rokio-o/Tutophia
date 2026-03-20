import 'package:flutter/material.dart';

class HeaderTutorWdgt extends StatelessWidget {
  final String title;
  final String subtitle;
  final String logoAsset;
  final double logoHeight;

  const HeaderTutorWdgt({
    super.key,
    required this.title,
    required this.subtitle,
    this.logoAsset = "assets/images/tutophia-logo-white-outline.png",
    this.logoHeight = 60,
  });

  // ── Named constructors for each tutor screen ──

  const HeaderTutorWdgt.dashboard({Key? key})
    : this(
        key: key,
        title: "DASHBOARD",
        subtitle: "Empower Minds Through Mentorship",
      );

  const HeaderTutorWdgt.sessionRequests({Key? key})
    : this(
        key: key,
        title: "SESSION REQUESTS",
        subtitle: "Review and manage student tutoring requests",
      );

  const HeaderTutorWdgt.sessionHistory({Key? key})
    : this(
        key: key,
        title: "SESSION HISTORY",
        subtitle: "Your history of empowering learners through mentorship",
      );

  const HeaderTutorWdgt.uploadMaterials({Key? key})
    : this(
        key: key,
        title: "UPLOAD MATERIALS",
        subtitle:
            "Provide supplementary materials to enhance the learning session.",
      );

  const HeaderTutorWdgt.feedback({Key? key})
    : this(
        key: key,
        title: "FEEDBACK",
        subtitle: "Review student impressions and share your expert advice",
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
                  fontSize: 24,
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
