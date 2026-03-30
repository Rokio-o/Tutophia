import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  static const List<String> _tutorTypeOptions = [
    'Student Tutor',
    'Graduate Tutor',
    'Professional Tutor',
    'Expert Tutor',
  ];

  final TextEditingController minRateCtrl;
  final TextEditingController maxRateCtrl;
  final TextEditingController tutorTypeCtrl;
  final TextEditingController specializationCtrl;
  final TextEditingController programCtrl;
  final VoidCallback onApply;
  final VoidCallback onCancel;

  const FilterButton({
    super.key,
    required this.minRateCtrl,
    required this.maxRateCtrl,
    required this.tutorTypeCtrl,
    required this.specializationCtrl,
    required this.programCtrl,
    required this.onApply,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    // Full modal content for tutor filtering
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 25,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Filter Tutors",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xff3d6fa5),
              ),
            ),
            const SizedBox(height: 20),

            const Text("Session Rate:", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 5),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Minimum rate:",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 40,
                        child: TextField(
                          controller: minRateCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixText: "₱ ",
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Maximum rate:",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 40,
                        child: TextField(
                          controller: maxRateCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixText: "₱ ",
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            const Text("Tutor Type:", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 5),

            DropdownButtonFormField<String>(
              value: _tutorTypeOptions.contains(tutorTypeCtrl.text)
                  ? tutorTypeCtrl.text
                  : null,
              decoration: InputDecoration(
                hintText: "Select tutor type",
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: _tutorTypeOptions
                  .map(
                    (type) => DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                tutorTypeCtrl.text = value ?? '';
              },
            ),

            const SizedBox(height: 15),

            const Text("Specialization:", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 5),

            SizedBox(
              height: 40,
              child: TextField(
                controller: specializationCtrl,
                decoration: InputDecoration(
                  hintText: "e.g., Calculus, Physics",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            const Text("Program:", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 5),

            SizedBox(
              height: 40,
              child: TextField(
                controller: programCtrl,
                decoration: InputDecoration(
                  hintText: "e.g., Computer Science",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black87),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: onCancel,
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3d6fa5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: onApply,
                    child: const Text(
                      "Apply",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
