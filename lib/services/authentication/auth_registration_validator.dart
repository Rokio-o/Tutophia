const allowedEmailDomainHint = '.edu or .edu.ph';

class AuthRegistrationValidator {
  static final RegExp _emailPattern = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  static String normalizeEmail(String email) => email.trim();

  static bool isValidEmailFormat(String email) {
    return _emailPattern.hasMatch(normalizeEmail(email));
  }

  static bool hasAllowedEmailDomain(String email) {
    final normalizedEmail = normalizeEmail(email).toLowerCase();
    final separatorIndex = normalizedEmail.lastIndexOf('@');

    if (separatorIndex <= 0 || separatorIndex == normalizedEmail.length - 1) {
      return false;
    }

    final domain = normalizedEmail.substring(separatorIndex + 1);
    return domain == 'edu' ||
        domain == 'edu.ph' ||
        domain.endsWith('.edu') ||
        domain.endsWith('.edu.ph');
  }

  static String? validateRegistrationEmail(String? value) {
    final email = normalizeEmail(value ?? '');

    if (email.isEmpty) {
      return 'Email is required';
    }

    if (!isValidEmailFormat(email)) {
      return 'Invalid email address';
    }

    if (!hasAllowedEmailDomain(email)) {
      return 'Use a school email ($allowedEmailDomainHint)';
    }

    return null;
  }

  static int? parseAge(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is String) {
      return int.tryParse(value.trim());
    }

    return null;
  }

  static String? validateStudentAge(dynamic value) {
    final parsedAge = parseAge(value);

    if (parsedAge == null) {
      return 'Age is required';
    }

    if (parsedAge <= 17) {
      return 'Must be 18 or older';
    }

    if (parsedAge > 100) {
      return 'Age must be 100 or below';
    }

    return null;
  }
}
