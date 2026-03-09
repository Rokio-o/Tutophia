import 'package:flutter/material.dart';
import 'package:tutophia/login.dart';
import 'package:tutophia/StudentAccess/terms-condition-student.dart';
import 'package:tutophia/registration-type.dart';
import 'registration2-student.dart';
import 'package:tutophia/src/features/authentication/controllers/signup_controller.dart';
import 'package:get/get.dart';
import 'package:tutophia/src/features/authentication/models/user_model.dart';

class StudentRegistration1 extends StatefulWidget {
  const StudentRegistration1({super.key});

  @override
  State<StudentRegistration1> createState() => _StudentRegistration1State();
}

class _StudentRegistration1State extends State<StudentRegistration1> {
  final OutlineInputBorder borderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
  );

  final _formKey = GlobalKey<FormState>();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());

    return Scaffold(
      backgroundColor: const Color(0xfff3f3f3),

      // back arrow
      appBar: AppBar(
        backgroundColor: const Color(0xfff3f3f3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegistrationType()),
            );
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CREATE ACCOUNT title
            const Text(
              "CREATE ACCOUNT",
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xff3d6fa5),
              ),
            ),

            const SizedBox(height: 5),

            // student Registration subtitle
            const Text(
              "Student Registration",
              style: TextStyle(color: Colors.black54, fontFamily: 'Arial'),
            ),

            const SizedBox(height: 30),

            // contact information section
            const Text(
              "Contact Information",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            // email Address
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Email Address",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: " *",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: controller.email,
                  decoration: InputDecoration(
                    border: borderStyle,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter your email address",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // contact number
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Contact Number",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: " *",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: controller.phoneNo,
                  decoration: InputDecoration(
                    border: borderStyle,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter your contact number",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // other accounts text
            const Text(
              "Other Accounts",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 15),

            // messenger
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Messenger",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                    border: borderStyle,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter messenger account link",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // instagram
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Instagram",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                    border: borderStyle,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter instagram account link",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // others
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Others",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                    border: borderStyle,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter other accounts",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // account creation section
            const Text(
              "Account Creation",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            // username
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Username",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: " *",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: controller.userName,
                  decoration: InputDecoration(
                    border: borderStyle,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter your username",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // password
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Password",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: " *",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: controller.password,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    border: borderStyle,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter your password",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // confirm password
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "Confirm Password",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: " *",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  obscureText: obscureConfirmPassword,
                  decoration: InputDecoration(
                    border: borderStyle,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Confirm your password",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureConfirmPassword = !obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // NEXT button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff3d6fa5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if(_formKey.currentState!.validate()) {

                    SignUpController.instance.registerUser(controller.email.text.trim(), controller.password.text.trim());

                      // Create a UserModel instance with the provided information
                    final user = UserModel(
                      email: controller.email.text.trim(),
                      password: controller.password.text.trim(),
                      userName: controller.userName.text.trim(),
                      phoneNo: controller.phoneNo.text.trim(),
                    );
                    SignUpController.instance.createUser(user);
                  }
                },
                child: const Text(
                  "NEXT",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Login link
            Center(
              child: GestureDetector(
                onTap: () {
                  // Navigate to login screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(color: Colors.black54),
                    children: [
                      TextSpan(
                        text: "Login",
                        style: TextStyle(
                          color: Color(0xff3d6fa5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
        ),
      ),
    );
  }
}
