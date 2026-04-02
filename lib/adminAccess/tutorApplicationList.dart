import 'package:flutter/material.dart';
import 'package:tutophia/models/admin-model/applications-data.dart';
import 'package:tutophia/data/admin-data/application-repository.dart';
import 'package:tutophia/widgets/admin-widgets/tutorApplicationWidget.dart';
import 'package:tutophia/adminAccess/viewTutorApplication.dart';

class TutorApplicationListScreen extends StatefulWidget {
  const TutorApplicationListScreen({super.key});

  @override
  State<TutorApplicationListScreen> createState() =>
      _TutorApplicationListScreenState();
}

class _TutorApplicationListScreenState
    extends State<TutorApplicationListScreen> {
  late List<TutorApplicationModel> _applications;

  @override
  void initState() {
    super.initState();
    _applications = List.from(dummyTutorApplications);
  }

  void _onStatusChanged(
    String id,
    ApplicationStatus newStatus, {
    String? rejectReason,
  }) {
    setState(() {
      final idx = _applications.indexWhere((a) => a.id == id);
      if (idx != -1) {
        _applications[idx] = _applications[idx].copyWith(
          status: newStatus,
          rejectReason: rejectReason,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Tutor Applications',
              style: TextStyle(
                color: Color(0xFF386FA4),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              'Manage Tutor Applications',
              style: TextStyle(color: Colors.black54, fontSize: 11),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset(
                'assets/images/tutophia-logo-white-outline.png',
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) => const Icon(
                  Icons.school,
                  color: Color(0xFF386FA4),
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),

      body: _applications.isEmpty
          ? const Center(
              child: Text(
                'No tutor applications yet.',
                style: TextStyle(color: Colors.black54),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: _applications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final app = _applications[index];
                return TutorApplicationCard(
                  name: app.name,
                  specialization: app.specialization,
                  image: app.image,
                  hasImage: app.hasImage,
                  status: app.status.label,
                  onViewTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdminViewTutorApplication(
                          application: app,
                          onStatusChanged: (status, {rejectReason}) =>
                              _onStatusChanged(
                                app.id,
                                status,
                                rejectReason: rejectReason,
                              ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
