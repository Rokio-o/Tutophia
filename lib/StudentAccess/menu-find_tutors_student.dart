import 'package:flutter/material.dart';
import 'package:tutophia/data/student-data/tutor_repository.dart';
import 'package:tutophia/models/student-model/tutor_data.dart';
import 'package:tutophia/widgets/student-widgets/tutor_card_widget.dart';
import 'package:tutophia/widgets/student-widgets/filter_button.dart';
import 'package:tutophia/widgets/student-widgets/header-student-wgt.dart';
import 'package:tutophia/widgets/student-widgets/bottom-navigation-student.dart';
import 'package:tutophia/StudentAccess/notifications-student.dart';
import 'package:tutophia/StudentAccess/profile-student.dart';

class FindTutors extends StatefulWidget {
  const FindTutors({super.key});

  @override
  State<FindTutors> createState() => _FindTutorsState();
}

class _FindTutorsState extends State<FindTutors> {
  int _selectedIndex = 0;

  // Variables for filter criteria
  final TextEditingController _minRateCtrl = TextEditingController();
  final TextEditingController _maxRateCtrl = TextEditingController();
  final TextEditingController _tutorTypeCtrl = TextEditingController();
  final TextEditingController _specializationCtrl = TextEditingController();
  final TextEditingController _programCtrl = TextEditingController();

  // Search state
  final TextEditingController _searchCtrl = TextEditingController();

  // Displayed list of tutors after filtering and searching
  List<TutorData> _filteredTutors = [];

  // All tutors fetched from Firestore
  List<TutorData> _allTutors = [];

  // Loading and error states
  bool _isLoading = true;
  String? _errorMessage;

  // Shows or hides the Clear Filter button
  bool _hasActiveFilter = false;

  @override
  void initState() {
    super.initState();
    _loadTutors();
  }

  /// Fetch tutors from Firestore
  Future<void> _loadTutors() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final tutors = await fetchAllTutors();
      
      setState(() {
        _allTutors = tutors;
        _filteredTutors = tutors;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load tutors. Please try again.';
        // Fallback to mock data on error
        _allTutors = availableTutors;
        _filteredTutors = availableTutors;
      });
      print('Error loading tutors: $e');
    }
  }

  @override
  void dispose() {
    _minRateCtrl.dispose();
    _maxRateCtrl.dispose();
    _tutorTypeCtrl.dispose();
    _specializationCtrl.dispose();
    _programCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _applyFilter() {
    setState(() {
      _filteredTutors = _allTutors.where((tutor) {
        final searchQuery = _searchCtrl.text.trim().toLowerCase();
        final matchesSearch =
            searchQuery.isEmpty ||
            tutor.name.toLowerCase().contains(searchQuery) ||
            tutor.subjects.any((s) => s.toLowerCase().contains(searchQuery)) ||
            tutor.program.toLowerCase().contains(searchQuery);

        final priceStr = tutor.sessionRate.replaceAll(RegExp(r'[^0-9]'), '');
        final price = double.tryParse(priceStr) ?? 0.0;
        final minPrice = double.tryParse(_minRateCtrl.text) ?? 0.0;
        final maxPrice = double.tryParse(_maxRateCtrl.text) ?? double.infinity;
        final matchesPrice = price >= minPrice && price <= maxPrice;

        final tutorTypeQuery = _tutorTypeCtrl.text.trim().toLowerCase();
        final matchesTutorType =
            tutorTypeQuery.isEmpty ||
            tutor.role.toLowerCase().contains(tutorTypeQuery);

        final specializationQuery = _specializationCtrl.text
          .trim()
          .toLowerCase();
        final matchesSpecialization =
          specializationQuery.isEmpty ||
          tutor.subjects.any(
            (s) => s.toLowerCase().contains(specializationQuery),
          );

        final programQuery = _programCtrl.text.trim().toLowerCase();
        final matchesProgram =
          programQuery.isEmpty ||
          tutor.program.toLowerCase().contains(programQuery);

        return matchesSearch &&
            matchesPrice &&
            matchesTutorType &&
          matchesSpecialization &&
          matchesProgram;
      }).toList();

      // Determines if at least one filter is currently active
      _hasActiveFilter =
          _minRateCtrl.text.trim().isNotEmpty ||
          _maxRateCtrl.text.trim().isNotEmpty ||
          _tutorTypeCtrl.text.trim().isNotEmpty ||
          _specializationCtrl.text.trim().isNotEmpty ||
          _programCtrl.text.trim().isNotEmpty;
    });
  }

  void _clearFilters() {
    setState(() {
      _minRateCtrl.clear();
      _maxRateCtrl.clear();
      _tutorTypeCtrl.clear();
      _specializationCtrl.clear();
      _programCtrl.clear();
      _filteredTutors = _allTutors;
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
              minRateCtrl: _minRateCtrl,
              maxRateCtrl: _maxRateCtrl,
              tutorTypeCtrl: _tutorTypeCtrl,
              specializationCtrl: _specializationCtrl,
              programCtrl: _programCtrl,
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
              // ── Find Tutors Header ──
              const HeaderStudentWdgt.findTutors(),

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
                            ? const Color(0xfff4a24c)
                            : const Color(0xff3d6fa5),
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
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xff3d6fa5),
                        ),
                      )
                    : _errorMessage != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline,
                                    color: Colors.red, size: 48),
                                const SizedBox(height: 16),
                                Text(
                                  _errorMessage ?? 'An error occurred',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: _loadTutors,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Try Again'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff3d6fa5),
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : _filteredTutors.isEmpty
                            ? const Center(child: Text("No match."))
                            : ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: _filteredTutors.length,
                                itemBuilder: (context, index) {
                                  final tutor = _filteredTutors[index];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: TutorCardWidget(tutor: tutor),
                                  );
                                },
                              ),
              ),
            ],
          ),
        ),
      ),

      // ── Bottom Navigation ──
      // ── Bottom Navigation ──
      bottomNavigationBar: BottomNavStudent(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const StudentNotificationsScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StudentProfileScreen()),
            );
          }
        },
      ),
    );
  }
}
