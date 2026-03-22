class TutorProfileModel {
  // NAME
  String firstName;
  String lastName;

  // TUTOR TYPE
  String selectedTutorType;
  final List<String> tutorTypes;

  // AREA OF SPECIALIZATION
  String specialization;

  // DESCRIPTION
  String description;

  // PROFESSIONAL CREDENTIALS
  String program;
  String year;
  String department;
  String tutorExp;

  // TUTORING SERVICES
  String mode;
  String sessionDuration;
  String sessionRate;

  // SCHEDULE
  String schedule;
  String linkSchedule;

  // CONTACT INFO
  String email;
  String phone;
  String messenger;
  String instagram;
  String others;

  TutorProfileModel({
    this.firstName = "Jeancess",
    this.lastName = "Gallo",
    this.selectedTutorType = "Student Tutor",
    this.tutorTypes = const ["Student Tutor", "Professional Tutor"],
    this.specialization = "Linear Algebra, Calculus 1, UI/UX",
    this.description =
        "3rd year Computer Science student with 2 years of experience tutoring Linear Algebra, Calculus 1, and UI/UX. I explain concepts clearly using simple, step-by-step examples.",
    this.program = "Computer Science",
    this.year = "3rd Year",
    this.department = "College of Computer Studies",
    this.tutorExp = "2 Years",
    this.mode = "Hybrid",
    this.sessionDuration = "1-2 hours",
    this.sessionRate = "₱300/hour",
    this.schedule = "Wednesday: 6-8 PM",
    this.linkSchedule =
        "https://calendly.com/jeancessgallo/30min?month=2024-06",
    this.email = "qjsgallo@gmail.com",
    this.phone = "09123487634",
    this.messenger = "JeancessGallo/messenger.com",
    this.instagram = "Cess/instagram.com",
    this.others = "Rokio/github.com",
  });
}
