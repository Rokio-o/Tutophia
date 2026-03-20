import '../models/tutor_data.dart';

// Temporary tutor data.
// Replace this later with database or backend data.
final List<TutorData> availableTutors = [
  const TutorData(
    name: "Jeancess Gallo",
    role: "Student Tutor",
    location: "Montalban Rizal",
    sessionRate: "₱60 /hr",
    rating: "4.8",
    reviews: "(20 reviews)",
    subjects: ["Linear Algebra", "Calculus 1", "UI/UX"],
    imagePath: "assets/images/placeholder_profile.jpg",
    description:
        "3rd year Computer Science student with 2 years of experience tutoring Linear Algebra, Calculus 1, and UI/UX. I explain concepts clearly using simple, step-by-step examples.",
    department: "College of Computer Studies",
    program: "Computer Science",
    yearLevel: "3rd Year",
    tutoringExperience: "2 Years",
    mode: "Hybrid",
    sessionDuration: "2 hours",
    email: "qjsgallo@gmail.com",
    contactNumber: "09123487634",
    messenger: "JeancessGallo/messenger.com",
    instagram: "Cess/instagram.com",
    others: "Rokio/github.com",
    availableSchedule: [
      "Wednesday • 8:30 am to 10:30 am",
      "Wednesday • 5:00 pm to 7:00 pm",
    ],
  ),
  const TutorData(
    name: "Eric De Leon",
    role: "Student Tutor",
    location: "Montalban Rizal",
    sessionRate: "₱60 /hr",
    rating: "4.8",
    reviews: "(20 reviews)",
    subjects: ["Linear Algebra", "Calculus 1", "UI/UX"],
    imagePath: "",
    description:
        "A student tutor who explains lessons in a clear and simple way.",
    department: "College of Computer Studies",
    program: "Computer Science",
    yearLevel: "3rd Year",
    tutoringExperience: "2 Years",
    mode: "Hybrid",
    sessionDuration: "2 hours",
    email: "eric@example.com",
    contactNumber: "09123456789",
    messenger: "Eric/messenger.com",
    instagram: "Eric/instagram.com",
    others: "Eric/github.com",
    availableSchedule: ["Friday • 1:00 pm to 3:00 pm"],
  ),
];
