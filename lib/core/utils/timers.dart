import 'package:flutter/services.dart';

class SessionTimer {
  double _elapsed = 0.0;
  bool _isRunning = false;
  DateTime? _startTime;
  Timer? _timer;

  double get elapsed => _elapsed;
  bool get isRunning => _isRunning;

  void start() {
    if (_isRunning) return;

    _isRunning = true;
    _startTime = DateTime.now();

    _timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) {
        if (_startTime != null) {
          _elapsed = DateTime.now().difference(_startTime!).inMilliseconds / 1000.0;
        }
      },
    );
  }

  void pause() {
    if (!_isRunning) return;

    _timer?.cancel();
    _isRunning = false;

    if (_startTime != null) {
      _elapsed = DateTime.now().difference(_startTime!).inMilliseconds / 1000.0;
    }
    _startTime = null;
  }

  void reset() {
    _timer?.cancel();
    _isRunning = false;
    _elapsed = 0.0;
    _startTime = null;
  }

  void dispose() {
    _timer?.cancel();
  }

  String evaluateAnswer(String userInput, String correctAnswer) {
    final isCorrectResult = _isCorrect(userInput, correctAnswer);

    if (_elapsed > 10.0) {
      if (isCorrectResult) {
        return 'correct_but_late';
      } else {
        return 'incorrect_and_late';
      }
    }

    return isCorrectResult ? 'correct' : 'incorrect';
  }

  bool _isCorrect(String userInput, String correctAnswer) {
    final normalizedUser = userInput.trim().toLowerCase();
    final normalizedCorrect = correctAnswer.trim().toLowerCase();
    return normalizedUser == normalizedCorrect;
  }

  bool isTooLate() => _elapsed > 10.0;
}

class NameValidator {
  static const int minLength = 2;
  static const int maxLength = 25;

  static bool isValidName(String name) {
    if (name.length < minLength || name.length > maxLength) {
      return false;
    }

    // Allow only letters, spaces, hyphens, and apostrophes
    // final nameRegex = RegExp(r'^[a-zA-Z\s\'\-]+$');
    final nameRegex = RegExp(r"^[a-zA-Z\s'-]+$");
    return nameRegex.hasMatch(name);
  }

  static String? validate(String name) {
    if (name.isEmpty) {
      return 'Name is required';
    }

    if (name.length < minLength) {
      return 'Name must be at least 2 characters';
    }

    if (name.length > maxLength) {
      return 'Name must not exceed $maxLength characters';
    }

    if (!isValidName(name)) {
      return 'Name contains invalid characters';
    }

    return null;
  }
}

class TextCapitalizationUtil {
  static String capitalizeWords(String text) {
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}
