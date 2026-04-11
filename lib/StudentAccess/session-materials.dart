import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tutophia/data/student-data/session-materials-repository.dart';
import 'package:tutophia/models/student-model/session-material_data.dart';
import 'package:tutophia/widgets/student-widgets/bottom-navigation-student.dart';
import 'package:tutophia/widgets/student-widgets/header-student-wgt.dart';
import 'package:tutophia/widgets/student-widgets/session-material-card.dart';
import 'package:tutophia/StudentAccess/profile-student.dart';
import 'package:tutophia/StudentAccess/dashboard-student.dart';
import 'package:tutophia/StudentAccess/notifications-student.dart';
import 'package:url_launcher/url_launcher.dart';

class SessionMaterialsScreen extends StatefulWidget {
  const SessionMaterialsScreen({super.key});

  @override
  State<SessionMaterialsScreen> createState() => _SessionMaterialsScreenState();
}

class _SessionMaterialsScreenState extends State<SessionMaterialsScreen> {
  final SessionMaterialsRepository _repository =
      SessionMaterialsRepository.instance;

  @override
  Widget build(BuildContext context) {
    final studentId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 24,
                ),
              ),

              const SizedBox(height: 12),

              const HeaderStudentWdgt.sessionMaterials(),

              const SizedBox(height: 24),

              Expanded(
                child: studentId == null
                    ? const Center(
                        child: Text(
                          'Please login to view your session materials.',
                          style: TextStyle(color: Colors.black54),
                        ),
                      )
                    : StreamBuilder<List<SessionMaterialData>>(
                        stream: _repository.watchStudentMaterials(studentId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return const Center(
                              child: Text(
                                'Unable to load session materials right now.',
                                style: TextStyle(color: Colors.black54),
                              ),
                            );
                          }

                          final materials = snapshot.data ?? const [];
                          if (materials.isEmpty) {
                            return const Center(
                              child: Text(
                                'No session materials have been shared yet.',
                                style: TextStyle(color: Colors.black54),
                              ),
                            );
                          }

                          return ListView.separated(
                            itemCount: materials.length,
                            padding: const EdgeInsets.only(bottom: 80),
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final material = materials[index];

                              return SessionMaterialCard(
                                data: material,
                                onDownload: () async {
                                  try {
                                    final uri = await _repository
                                        .resolveOpenUri(material);
                                    final opened = await launchUrl(
                                      uri,
                                      mode: LaunchMode.externalApplication,
                                    );

                                    if (!opened && context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Unable to open this material.',
                                          ),
                                        ),
                                      );
                                    }
                                  } catch (_) {
                                    if (!context.mounted) {
                                      return;
                                    }

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Unable to open this material.',
                                        ),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavStudent(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const StudentDashboard()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const StudentNotificationsScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const StudentProfileScreen()),
            );
          }
        },
      ),
    );
  }
}
