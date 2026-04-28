class Validators {
  Validators._();

  static bool isValidName(String name) {
    if (name.isEmpty) return false;

    // Allow only letters, spaces, hyphens, and apostrophes
    // final nameRegex = RegExp(r'^[a-zA-Z\s\'\-]+$');
    final nameRegex = RegExp(r"^[a-zA-Z\s'-]+$");
    return nameRegex.hasMatch(name);
  }

  static String? validateName(String name) {
    if (name.isEmpty) {
      return 'Name is required';
    }

    if (name.length < 2) {
      return 'Name must be at least 2 characters';
    }

    if (name.length > 25) {
      return 'Name must not exceed 25 characters';
    }

    if (!isValidName(name)) {
      return 'Name contains invalid characters';
    }

    return null;
  }

  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  static bool isValidKeyword(String keyword) {
    if (keyword.isEmpty) return false;
    // Keywords should contain only letters and spaces
    final keywordRegex = RegExp(r'^[a-zA-Z\s]+$');
    return keywordRegex.hasMatch(keyword);
  }

  static List<String> parseKeywords(String input) {
    return input
        .split(' ')
        .map((k) => k.trim())
        .where((k) => k.isNotEmpty)
        .toList();
  }
}
