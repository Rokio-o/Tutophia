import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutophia/login.dart';
import 'package:tutophia/services/repository/authentication_repository/authentication_repository.dart';
import 'package:tutophia/services/repository/authentication_repository/exceptions/signup_email_password_failure.dart';
import 'package:tutophia/services/authentication/verified_home_router.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String? email;

  const VerifyEmailScreen({super.key, this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  static const int _resendCooldownSeconds = 30;

  Timer? _cooldownTimer;
  int _remainingCooldown = 0;
  bool _isCheckingVerification = false;
  bool _isResending = false;
  bool _isSigningOut = false;

  String get _emailAddress {
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email?.trim();
    return currentUserEmail?.isNotEmpty == true
        ? currentUserEmail!
        : (widget.email?.trim() ?? 'your email address');
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _showMessage(String message, {Color color = Colors.red}) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    setState(() => _remainingCooldown = _resendCooldownSeconds);

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _remainingCooldown <= 1) {
        timer.cancel();
        if (mounted) {
          setState(() => _remainingCooldown = 0);
        }
        return;
      }

      setState(() => _remainingCooldown -= 1);
    });
  }

  Future<void> _checkVerificationStatus() async {
    if (_isCheckingVerification) return;

    setState(() => _isCheckingVerification = true);

    try {
      final user = await AuthenticationRepository.instance.reloadCurrentUser();
      if (user == null) {
        throw const SignUpWithEmailAndPasswordFailure(
          'Your session expired. Please log in again.',
        );
      }

      if (!user.emailVerified) {
        _showMessage(
          'Your email is still unverified. Open the verification link and try again.',
        );
        return;
      }

      if (!mounted) return;
      final didNavigate = await VerifiedHomeRouter.navigate(
        context,
        user: user,
      );
      if (didNavigate) {
        return;
      }

      await AuthenticationRepository.instance.signOut();
      if (!mounted) return;
      _showMessage('Account role not found. Please contact support.');
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      _showMessage(e.message);
    } catch (_) {
      _showMessage('Unable to confirm your verification status right now.');
    } finally {
      if (mounted) {
        setState(() => _isCheckingVerification = false);
      }
    }
  }

  Future<void> _resendVerificationEmail() async {
    if (_isResending || _remainingCooldown > 0) return;

    setState(() => _isResending = true);

    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      _startCooldown();
      _showMessage(
        'Verification email sent. Check the emulator logs or your inbox.',
        color: Colors.green,
      );
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      _showMessage(e.message);
    } catch (_) {
      _showMessage('Unable to resend the verification email right now.');
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  Future<void> _signOutToLogin() async {
    if (_isSigningOut) return;

    setState(() => _isSigningOut = true);

    try {
      await AuthenticationRepository.instance.signOut();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } finally {
      if (mounted) {
        setState(() => _isSigningOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const Icon(
                Icons.mark_email_read_outlined,
                size: 88,
                color: Color(0xFF386FA4),
              ),
              const SizedBox(height: 24),
              const Text(
                'Verify your email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF386FA4),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'We sent a verification email to $_emailAddress. Open the link in that email before continuing to Tutophia.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isCheckingVerification
                      ? null
                      : _checkVerificationStatus,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF386FA4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    _isCheckingVerification
                        ? 'CHECKING...'
                        : 'I HAVE VERIFIED MY EMAIL',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 50,
                child: OutlinedButton(
                  onPressed: (_isResending || _remainingCooldown > 0)
                      ? null
                      : _resendVerificationEmail,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF386FA4)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    _isResending
                        ? 'SENDING...'
                        : _remainingCooldown > 0
                        ? 'RESEND IN $_remainingCooldown S'
                        : 'RESEND VERIFICATION EMAIL',
                    style: const TextStyle(
                      color: Color(0xFF386FA4),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _isSigningOut ? null : _signOutToLogin,
                child: Text(
                  _isSigningOut ? 'SIGNING OUT...' : 'BACK TO LOGIN',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                'Using the Firebase Auth Emulator? Email verification links are shown in the Emulator Suite UI and local emulator logs instead of being sent to a real inbox.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
