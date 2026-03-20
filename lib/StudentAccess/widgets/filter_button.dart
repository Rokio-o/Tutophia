import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final int filterRating;
  final TextEditingController minRateCtrl;
  final TextEditingController maxRateCtrl;
  final TextEditingController subjectCtrl;
  final TextEditingController locationCtrl;
  final ValueChanged<int> onRatingChanged;
  final VoidCallback onApply;
  final VoidCallback onCancel;

  const FilterButton({
    super.key,
    required this.filterRating,
    required this.minRateCtrl,
    required this.maxRateCtrl,
    required this.subjectCtrl,
    required this.locationCtrl,
    required this.onRatingChanged,
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

            const Text("Rating:", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 5),

            Row(
              children: [
                ...List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => onRatingChanged(index + 1),
                    child: Icon(
                      Icons.star,
                      color: index < filterRating
                          ? Colors.yellow
                          : Colors.grey[300],
                      size: 32,
                    ),
                  );
                }),
                const SizedBox(width: 10),
                Text(
                  "$filterRating stars",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 15),

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

            const Text("Subject:", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 5),

            SizedBox(
              height: 40,
              child: TextField(
                controller: subjectCtrl,
                decoration: InputDecoration(
                  hintText: "Text...",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            const Text("Location:", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 5),

            SizedBox(
              height: 40,
              child: TextField(
                controller: locationCtrl,
                decoration: InputDecoration(
                  hintText: "Text...",
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
