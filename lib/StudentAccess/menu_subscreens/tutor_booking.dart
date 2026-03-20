import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../data/booking_repository.dart';
import '../models/booking_data.dart';
import '../models/tutor_data.dart';
import 'booking_confirmation.dart';

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

  String? _duration = '1 hour';
  String? _startTime = '7:00 am';
  String? _endTime = '8:00 am';
  String? _subject;
  String? _mode = 'Face to Face';

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  final List<String> durations = ['1 hour', '2 hours', '3 hours', '4 hours'];
  final List<String> times = [
    '7:00 am',
    '8:00 am',
    '9:00 am',
    '10:00 am',
    '1:00 pm',
    '2:00 pm',
  ];
  final List<String> modes = ['Face to Face', 'Online', 'Hybrid'];

  @override
  void dispose() {
    // Dispose controllers when screen is destroyed.
    _locationController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _submitBooking() {
    // Basic form validation.
    if (_selectedDate == null ||
        _subject == null ||
        _locationController.text.trim().isEmpty ||
        _reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields.')),
      );
      return;
    }

    if (_startTime == _endTime) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Start time and end time cannot be the same.'),
        ),
      );
      return;
    }

    final formattedDate =
        "${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}";

    final newBooking = BookingData(
      tutorName: widget.tutor.name,
      role: widget.tutor.role,
      status: "PENDING",
      imagePath: widget.tutor.imagePath,
      date: formattedDate,
      time: "$_startTime to $_endTime",
      duration: _duration ?? "1 hour",
      mode: _mode ?? "Face to Face",
      location: _locationController.text.trim(),
      subjectTarget: _subject ?? "",
      reason: _reasonController.text.trim(),
    );

    showConfirmBookingDialog(
      context,
      onConfirm: () {
        activeBookings.add(newBooking);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> subjects = widget.tutor.subjects;

    // Booking form screen.
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "BOOKING",
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: primaryBlue,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Select a Date"),
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
                    if (isSameDay(_selectedDate, selectedDay)) {
                      _selectedDate = null;
                    } else {
                      _selectedDate = selectedDay;
                    }
                    _focusedDay = focusedDay;
                  });
                },
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  isTodayHighlighted: false,
                  selectedDecoration: BoxDecoration(
                    color: Color(0XFF2A31AB),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8),
                  ),
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
                      _buildLabel("Duration"),
                      const SizedBox(height: 5),
                      _buildDropdown(
                        value: _duration,
                        items: durations,
                        onChanged: (val) => setState(() => _duration = val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Time"),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown(
                              value: _startTime,
                              items: times,
                              onChanged: (val) =>
                                  setState(() => _startTime = val),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text("-"),
                          ),
                          Expanded(
                            child: _buildDropdown(
                              value: _endTime,
                              items: times,
                              onChanged: (val) =>
                                  setState(() => _endTime = val),
                            ),
                          ),
                        ],
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
                      _buildLabel("Subject"),
                      const SizedBox(height: 5),
                      _buildDropdown(
                        value: _subject,
                        hint: "Select a Subject",
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
                      _buildLabel("Mode"),
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

            _buildLabel("Location"),
            const SizedBox(height: 5),
            _buildExpandableTextField(
              controller: _locationController,
              hint: "Enter location...",
            ),

            const SizedBox(height: 20),

            _buildLabel("Reason"),
            const SizedBox(height: 5),
            _buildExpandableTextField(
              controller: _reasonController,
              hint: "Enter reason...",
            ),

            const SizedBox(height: 40),

            Center(
              child: SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Submit",
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

  // Required label with red asterisk.
  Widget _buildLabel(String text) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        children: const [
          TextSpan(
            text: " *",
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  // Styled dropdown for booking form.
  Widget _buildDropdown({
    required String? value,
    String? hint,
    required List<String> items,
    required void Function(String?) onChanged,
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
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
        ),
      ),
    );
  }

  // Expandable text field for location and reason.
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
