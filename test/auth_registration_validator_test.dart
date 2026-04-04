import 'package:flutter_test/flutter_test.dart';
import 'package:tutophia/services/authentication/auth_registration_validator.dart';

void main() {
  group('AuthRegistrationValidator.hasAllowedEmailDomain', () {
    test('accepts .edu addresses', () {
      expect(
        AuthRegistrationValidator.hasAllowedEmailDomain('student@school.edu'),
        isTrue,
      );
    });

    test('accepts .edu.ph addresses', () {
      expect(
        AuthRegistrationValidator.hasAllowedEmailDomain('qjabniez@tip.edu.ph'),
        isTrue,
      );
    });

    test('accepts subdomains under .edu.ph', () {
      expect(
        AuthRegistrationValidator.hasAllowedEmailDomain(
          'student@cics.tip.edu.ph',
        ),
        isTrue,
      );
    });

    test('rejects non-school domains', () {
      expect(
        AuthRegistrationValidator.hasAllowedEmailDomain('student@gmail.com'),
        isFalse,
      );
    });

    test('rejects lookalike domains', () {
      expect(
        AuthRegistrationValidator.hasAllowedEmailDomain(
          'student@school.education',
        ),
        isFalse,
      );
    });
  });
}