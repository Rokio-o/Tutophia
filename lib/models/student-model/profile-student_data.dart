class StudentProfileModel {
  // NAME
  String firstName;
  String lastName;

  // DESCRIPTION
  String description;

  // ACADEMIC CREDENTIALS
  String program;
  String year;
  String department;

  // CONTACT INFO
  String email;
  String phone;
  String messenger;
  String instagram;
  String others;

  StudentProfileModel({
    this.firstName = "Winfredo",
    this.lastName = "De Lemos",
    this.description =
        "I am currently a 3rd year student interested in Web-based development and Java, Python, and C++.",
    this.program = "Computer Science",
    this.year = "3rd Year",
    this.department = "College of Computer Studies",
    this.email = "wdelomos@tip.edu.ph",
    this.phone = "+63 928 323 958",
    this.messenger = '',
    this.instagram = '',
    this.others = '',
  });
}
