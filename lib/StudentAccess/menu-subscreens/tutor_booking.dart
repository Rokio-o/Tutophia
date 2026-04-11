import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tutophia/data/student-data/booking_repository.dart';
import 'package:tutophia/models/student-model/booking_data.dart';
import 'package:tutophia/models/student-model/tutor_data.dart';
import 'package:tutophia/services/repository/user_repository/user_repository.dart';
import 'package:tutophia/widgets/student-widgets/header-student-wgt.dart';

class StudentTutorBookingScreen extends StatefulWidget {
  final TutorData tutor;

  const StudentTutorBookingScreen({super.key, required this.tutor});

  @override
  State<StudentTutorBookingScreen> createState() =>
      _StudentTutorBookingScreenState();
}

class _StudentTutorBookingScreenState extends State<StudentTutorBookingScreen> {
  final Color primaryBlue = const Color(0xff3d6fa5);
  final Color primaryOrange = const Color(0xfff4a24c);

  DateTime? _selectedDate;
  DateTime _focusedDay = DateTime.now();

  String? _duration = '60';
  String? _startTime = '7:00 am';
  String? _subject;
  String? _mode = 'Face to Face';

  bool _isSubmitting = false;

  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final List<String> durations = ['60', '120', '180', '240'];
  final List<String> times = [
    '7:00 am',
    '8:00 am',
    '9:00 am',
    '10:00 am',
    '11:00 am',
    '12:00 pm',
    '1:00 pm',
    '2:00 pm',
    '3:00 pm',
    '4:00 pm',
    '5:00 pm',
    '6:00 pm',
  ];
  final List<String> modes = ['Face to Face', 'Online', 'Hybrid'];

  @override
  void dispose() {
    _topicController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitBooking() async {
    if (_isSubmitting) return;

    if (_selectedDate == null ||
        _subject == null ||
        _topicController.text.trim().isEmpty ||
        _notesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields.')),
      );
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please login first.')));
      return;
    }

    if (widget.tutor.uid.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tutor record is incomplete. Please refresh and try again.',
          ),
        ),
      );
      return;
    }

    final start = _buildSessionStart(_selectedDate!, _startTime!);
    final durationMinutes = int.tryParse(_duration ?? '60') ?? 60;
    final end = start.add(Duration(minutes: durationMinutes));

    setState(() => _isSubmitting = true);

    try {
      final studentProfile =
          await UserRepository.instance.getUserProfile(uid) ??
          <String, dynamic>{};
      final studentName =
          '${_asString(studentProfile['firstName'])} ${_asString(studentProfile['lastName'])}'
              .trim();
      final studentProgram = _asString(studentProfile['program']);

      final hourlyRate = _parsePesoValue(widget.tutor.sessionRate);
      final totalPrice = hourlyRate * (durationMinutes / 60.0);

      final booking = BookingData(
        bookingId: '',
        studentId: uid,
        studentName: studentName.isEmpty ? 'Student' : studentName,
        studentProgram: studentProgram,
        tutorId: widget.tutor.uid,
        tutorName: widget.tutor.name,
        tutorType: widget.tutor.role,
        tutorImagePath: widget.tutor.imagePath,
        subject: _subject ?? '',
        topic: _topicController.text.trim(),
        mode: _mode ?? 'Face to Face',
        location: _locationController.text.trim(),
        sessionDateTime: start,
        endDateTime: end,
        durationMinutes: durationMinutes,
        hourlyRate: hourlyRate,
        totalPrice: totalPrice,
        studentNotes: _notesController.text.trim(),
        status: BookingData.statusPending,
      );

      await BookingRepository.instance.createBooking(booking);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking request submitted.')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to submit booking: $e')));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  DateTime _buildSessionStart(DateTime selectedDate, String timeText) {
    final text = timeText.trim().toLowerCase();
    final timeParts = text.split(' ');
    final hm = timeParts.first.split(':');
    var hour = int.tryParse(hm[0]) ?? 0;
    final minute = int.tryParse(hm.length > 1 ? hm[1] : '0') ?? 0;
    final period = timeParts.length > 1 ? timeParts[1] : 'am';

    if (period == 'pm' && hour != 12) hour += 12;
    if (period == 'am' && hour == 12) hour = 0;

    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      hour,
      minute,
    );
  }

  String _asString(dynamic value) {
    if (value is String) return value;
    return '';
  }

  double _parsePesoValue(String input) {
    final clean = input.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(clean) ?? 0;
  }

  Widget _buildSelectedCalendarDay(DateTime day) {
    return Container(
      margin: const EdgeInsets.all(6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0XFF2A31AB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${day.day}',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> subjects = widget.tutor.subjects;

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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderStudentWdgt.booking(),
            const SizedBox(height: 20),

            _buildLabel('Select a Date'),
            const SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black87),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDate = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                calendarBuilders: CalendarBuilders(
                  selectedBuilder: (context, day, focusedDay) =>
                      _buildSelectedCalendarDay(day),
                ),
                calendarStyle: const CalendarStyle(
                  outsideDaysVisible: false,
                  isTodayHighlighted: false,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Duration'),
                      const SizedBox(height: 5),
                      _buildDropdown(
                        value: _duration,
                        items: durations,
                        onChanged: (val) => setState(() => _duration = val),
                        formatItemText: (value) {
                          final mins = int.tryParse(value) ?? 60;
                          final hrs = mins ~/ 60;
                          return hrs == 1 ? '1 hour' : '$hrs hours';
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Start Time'),
                      const SizedBox(height: 5),
                      _buildDropdown(
                        value: _startTime,
                        items: times,
                        onChanged: (val) => setState(() => _startTime = val),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Subject'),
                      const SizedBox(height: 5),
                      _buildDropdown(
                        value: _subject,
                        hint: 'Select a Subject',
                        items: subjects,
                        onChanged: (val) => setState(() => _subject = val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Mode'),
                      const SizedBox(height: 5),
                      _buildDropdown(
                        value: _mode,
                        items: modes,
                        onChanged: (val) => setState(() => _mode = val),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildLabel('Topic'),
            const SizedBox(height: 5),
            _buildExpandableTextField(
              controller: _topicController,
              hint: 'Enter topic...',
            ),

            const SizedBox(height: 20),

            _buildLabel('Location (optional)'),
            const SizedBox(height: 5),
            _buildExpandableTextField(
              controller: _locationController,
              hint: 'Enter location...',
            ),

            const SizedBox(height: 20),

            _buildLabel('Notes'),
            const SizedBox(height: 5),
            _buildExpandableTextField(
              controller: _notesController,
              hint: 'Enter notes for the tutor...',
            ),

            const SizedBox(height: 40),

            Center(
              child: SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        children: text.contains('(optional)')
            ? const []
            : const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ],
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    String? hint,
    required List<String> items,
    required void Function(String?) onChanged,
    String Function(String value)? formatItemText,
  }) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: hint != null
              ? Text(
                  hint,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                )
              : null,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          style: const TextStyle(color: Colors.black87, fontSize: 13),
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(formatItemText?.call(item) ?? item),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildExpandableTextField({
    required TextEditingController controller,
    required String hint,
    int minLines = 1,
    int maxLines = 10,
  }) {
    return TextFormField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        contentPadding: const EdgeInsets.all(10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.black87),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.black87),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: primaryBlue, width: 2),
        ),
      ),
    );
  }
}
