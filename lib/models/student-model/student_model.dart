class studentModel {
  final String? id;
  final String userName;
  final String email;
  final String phoneNo;

  const studentModel({
    this.id,
    required this.email,
    required this.userName,
    required this.phoneNo,
  });

  toJson() {
    return {
      "UserName": userName,
      "Email": email,
      "PhoneNo": phoneNo,
    };
  }
}