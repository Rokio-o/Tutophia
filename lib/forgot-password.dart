import 'package:flutter/material.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}
 



class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

   final double headerHeight = 250;
  //Colors
  static const Color kBlue = Color(0xFF386FA4);
  static const Color kOrange = Color(0xFFF9AB55);
  static const Color kText = Color(0xFF0F0F0F);

  Future resetPassword() async {
    // Validate email
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter your email address.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return;
    }

    // Simple email validation
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(emailController.text.trim())) {
      Get.snackbar(
        "Error",
        "Please enter a valid email address.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return;
    }

    if (_isLoading) return; // Prevent multiple clicks

    setState(() => _isLoading = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim());
      
      // Dismiss the dialog
      Navigator.of(context).pop();

      Get.snackbar(
        "Success",
        "Password reset email sent! Please check your inbox.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.greenAccent.withValues(alpha: 0.1),
        colorText: Colors.green,
      );

      // Clear email and navigate back after a short delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          emailController.clear();
          Navigator.of(context).pop();
        }
      });
    } catch (e) {
      // Dismiss the dialog
      Navigator.of(context).pop();

      Get.snackbar(
        "Error",
        "Failed to send password reset email.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kOrange,
      body: Column(
        children: [
          // Header Color
          Container(
            height: headerHeight,
            width: double.infinity,
            color: kOrange,
            child: Stack(
              children: [
                // Back arrow
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 8,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                  ),
                ),

                // Mismong image
                Center(
                  child: Image.asset(
                    'assets/images/forgot-pass-illustration.png',
                    width: screenWidth * 0.45,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),

          // White base para dun sa mga input fields and buttons
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.03),

                      // app name
                      Text(
                        'TUTOPHIA',
                        style: TextStyle(
                          color: kBlue,
                          fontSize: screenWidth * 0.08,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      // Below tutophia, title page stuff
                      Text(
                        'Reset Your Password',
                        style: TextStyle(
                          color: kText,
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.025),

                      // instruction stuff
                      Text(
                        "Enter your registered email address and we'll send you instructions to reset your password",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kText,
                          fontSize: screenWidth * 0.035,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // email
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Email Address',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w500,
                            color: kText,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      // email field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Enter your email address',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: screenWidth * 0.035,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: screenHeight * 0.018,
                            ),
                          ),
                          style: TextStyle(fontSize: screenWidth * 0.035),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // send button
                      SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.065,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : () {
                            resetPassword();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isLoading ? Colors.grey : kBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            _isLoading ? 'SENDING...' : 'SEND',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.045,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Return to login page
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Text(
                          'Back to Login',
                          style: TextStyle(
                            color: kBlue,
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.038,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // container ng need help stuff
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.02,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Need Help?',
                              style: TextStyle(
                                color: kText,
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.038,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.008),
                            Text(
                              "If you're having trouble resetting your password, please contact support at tutophiaSupport@gmail.com",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: screenWidth * 0.032,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

  }
}
