class MyValidators {
  static String? displayNamevalidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Display name cannot be empty';
    }
    if (value.length < 3) {
      return 'Display name must be at least 3 characters';
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!value.contains('@')) {
      return 'Invalid email address';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? repeatPasswordValidator(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}
