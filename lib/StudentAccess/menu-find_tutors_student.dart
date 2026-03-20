import 'package:flutter/material.dart';
import 'package:tutophia/data/student-data/tutor_repository.dart';
import 'package:tutophia/model/student-model/tutor_data.dart';
import 'package:tutophia/widgets/student-widgets/tutor_card_widget.dart';
import 'package:tutophia/widgets/student-widgets/filter_button.dart';

class FindTutors extends StatefulWidget {
  const FindTutors({super.key});

  @override
  State<FindTutors> createState() => _FindTutorsState();
}

class _FindTutorsState extends State<FindTutors> {
  int _selectedIndex = 0;

  // Variables for filter criteria
  int _filterRating = 5;
  final TextEditingController _minRateCtrl = TextEditingController();
  final TextEditingController _maxRateCtrl = TextEditingController();
  final TextEditingController _subjectCtrl = TextEditingController();
  final TextEditingController _locationCtrl = TextEditingController();

  // Search state
  final TextEditingController _searchCtrl = TextEditingController();

  // Displayed list of tutors after filtering and searching
  List<TutorData> _filteredTutors = [];

  // Shows or hides the Clear Filter button
  bool _hasActiveFilter = false;

  @override
  void initState() {
    super.initState();
    _filteredTutors = availableTutors;
  }

  @override
  void dispose() {
    _minRateCtrl.dispose();
    _maxRateCtrl.dispose();
    _subjectCtrl.dispose();
    _locationCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _applyFilter() {
    setState(() {
      _filteredTutors = availableTutors.where((tutor) {
        final searchQuery = _searchCtrl.text.trim().toLowerCase();
        final matchesSearch =
            searchQuery.isEmpty ||
            tutor.name.toLowerCase().contains(searchQuery) ||
            tutor.subjects.any((s) => s.toLowerCase().contains(searchQuery));

        final tutorRating = double.tryParse(tutor.rating) ?? 0.0;
        final matchesRating = tutorRating >= (_filterRating - 1);

        final locQuery = _locationCtrl.text.trim().toLowerCase();
        final matchesLocation =
            locQuery.isEmpty || tutor.location.toLowerCase().contains(locQuery);

        final subQuery = _subjectCtrl.text.trim().toLowerCase();
        final matchesSubject =
            subQuery.isEmpty ||
            tutor.subjects.any((s) => s.toLowerCase().contains(subQuery));

        final priceStr = tutor.sessionRate.replaceAll(RegExp(r'[^0-9]'), '');
        final price = double.tryParse(priceStr) ?? 0.0;
        final minPrice = double.tryParse(_minRateCtrl.text) ?? 0.0;
        final maxPrice = double.tryParse(_maxRateCtrl.text) ?? double.infinity;
        final matchesPrice = price >= minPrice && price <= maxPrice;

        return matchesSearch &&
            matchesRating &&
            matchesLocation &&
            matchesPrice &&
            matchesSubject;
      }).toList();

      // Determines if at least one filter is currently active
      _hasActiveFilter =
          _filterRating != 5 ||
          _minRateCtrl.text.trim().isNotEmpty ||
          _maxRateCtrl.text.trim().isNotEmpty ||
          _subjectCtrl.text.trim().isNotEmpty ||
          _locationCtrl.text.trim().isNotEmpty;
    });
  }

  void _clearFilters() {
    setState(() {
      // Reset all filter values
      _filterRating = 5;
      _minRateCtrl.clear();
      _maxRateCtrl.clear();
      _subjectCtrl.clear();
      _locationCtrl.clear();

      // Reset tutor list
      _filteredTutors = availableTutors;

      // Hide the clear filter button
      _hasActiveFilter = false;
    });
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: Colors.black, width: 2),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return FilterButton(
              filterRating: _filterRating,
              minRateCtrl: _minRateCtrl,
              maxRateCtrl: _maxRateCtrl,
              subjectCtrl: _subjectCtrl,
              locationCtrl: _locationCtrl,
              onRatingChanged: (value) {
                setModalState(() {
                  _filterRating = value;
                });
              },
              onCancel: () => Navigator.pop(context),
              onApply: () {
                _applyFilter();
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "FIND TUTORS",
                          style: TextStyle(
                            fontFamily: 'Arimo',
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff3d6fa5),
                          ),
                        ),
                        Text(
                          "Find the right tutor for your learning goals",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    "assets/images/tutophia-logo-white-outline.png",
                    height: 50,
                    errorBuilder: (c, e, s) => const Icon(
                      Icons.school,
                      size: 50,
                      color: Color(0xfff4a24c),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: _hasActiveFilter ? _clearFilters : _showFilterModal,
                    child: Container(
                      width: 110,
                      height: 35,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: _hasActiveFilter
                            ? const Color(0xfff4a24c) // Color of Clear button
                            : const Color(0xff3d6fa5), // Color of Filter Button
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _hasActiveFilter ? Icons.clear : Icons.filter_list,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _hasActiveFilter ? "Clear Filter" : "Filter",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: (value) => _applyFilter(),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                          isDense: true,
                          hintText: "Search",
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black87,
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Text(
                "Tutors",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const Divider(color: Colors.black87, thickness: 1),
              Expanded(
                child: _filteredTutors.isEmpty
                    ? const Center(child: Text("No match."))
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _filteredTutors.length,
                        itemBuilder: (context, index) {
                          final tutor = _filteredTutors[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: TutorCardWidget(tutor: tutor),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: const Color(0xfff4a24c),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notification",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
