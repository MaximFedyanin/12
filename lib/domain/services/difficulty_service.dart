import 'dart:math';
import '../../core/database/models/word.dart';
import '../../core/constants/app_settings.dart';

class DifficultyService {
  /// Calculate local difficulty based on user's interaction with the word
  static double calculateLocalDifficulty(Word word) {
    // Cr1: Decay by exposure (логарифмическое снижение)
    final exposureFactor = 1.0 / (1.0 + 0.3 * log(word.totalShows + 1));

    // Cr2: Forgetting curve (экспоненциальный рост сложности со временем)
    final hoursSinceLast = _getHoursSinceLastAttempt(word.lastAttemptTimestamp);
    final forgettingFactor = min(1.0, 0.15 * sqrt(hoursSinceLast));

    // Cr3: Accuracy trend - simplified version
    final accuracy = word.totalShows > 0
        ? word.correctAnswers / word.totalShows
        : 0.5;
    final accuracyFactor = 1.0 - accuracy;

    // Финальная формула с весами
    double difficulty = (AppSettings.exposureWeight * exposureFactor +
                        AppSettings.forgettingWeight * forgettingFactor +
                        AppSettings.accuracyWeight * accuracyFactor);

    // Clamp to avoid extreme values
    return difficulty.clamp(AppSettings.minDifficulty, AppSettings.maxDifficulty);
  }

  static double _getHoursSinceLastAttempt(int lastAttemptTimestamp) {
    if (lastAttemptTimestamp == 0) return 24.0; // Default to 24 hours if never attempted

    final now = DateTime.now().millisecondsSinceEpoch;
    final diffMs = now - (lastAttemptTimestamp * 1000);
    return diffMs / (1000 * 60 * 60); // Convert to hours
  }

  /// Get words sorted by difficulty for adaptive learning
  static List<Word> sortWordsByDifficulty(List<Word> words, {bool ascending = false}) {
    words.sort((a, b) {
      final comparison = a.localDifficulty.compareTo(b.localDifficulty);
      return ascending ? comparison : -comparison;
    });
    return words;
  }

  /// Select words for next session based on difficulty and spacing
  static List<Word> selectWordsForSession({
    required List<Word> availableWords,
    int count = 50,
    String? cefrLevel,
  }) {
    var filtered = availableWords;

    // Filter by CEFR level if specified
    if (cefrLevel != null) {
      filtered = filtered.where((w) => w.cefrLevel == cefrLevel).toList();
    }

    // Sort by difficulty (hardest first, but mix in some easier ones)
    filtered.sort((a, b) {
      // Add some randomness to avoid always showing the same order
      final randomFactor = (DateTime.now().millisecond % 10) / 100.0;
      final aScore = a.localDifficulty + randomFactor;
      final bScore = b.localDifficulty + randomFactor;
      return bScore.compareTo(aScore);
    });

    // Take top N words
    return filtered.take(count).toList();
  }

  /// Update word statistics after an attempt
  static Word updateWordAfterAttempt({
    required Word word,
    required bool isCorrect,
  }) {
    final newTotalShows = word.totalShows + 1;
    final newCorrectAnswers = isCorrect ? word.correctAnswers + 1 : word.correctAnswers;
    final newLastAttemptTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // Recalculate difficulty
    final updatedWord = word.copyWith(
      totalShows: newTotalShows,
      correctAnswers: newCorrectAnswers,
      lastAttemptTimestamp: newLastAttemptTimestamp,
    );

    final newDifficulty = calculateLocalDifficulty(updatedWord);

    return updatedWord.copyWith(
      localDifficulty: newDifficulty,
    );
  }
}

/// Adaptive forgetting curve for personalized learning
class AdaptiveForgettingCurve {
  final String userId;
  final double baseDecay;
  final double userMultiplier;

  AdaptiveForgettingCurve({
    required this.userId,
    this.baseDecay = 0.15,
    this.userMultiplier = 1.0,
  });

  /// Get forgetting factor based on hours since last review
  double getForgettingFactor(double hours) {
    return min(1.0, baseDecay * userMultiplier * sqrt(hours));
  }

  /// Adjust user multiplier based on retention performance
  void adjustUserMultiplier(double retentionRate) {
    // If retention is high (>80%), increase decay (user remembers well)
    // If retention is low (<50%), decrease decay (user needs more repetition)
    if (retentionRate > 0.8) {
      userMultiplier = (userMultiplier * 1.1).clamp(0.8, 1.5);
    } else if (retentionRate < 0.5) {
      userMultiplier = (userMultiplier * 0.9).clamp(0.8, 1.5);
    }
  }
}

double log(double x) => ln(x) / ln(10);
double ln(double x) => _naturalLog(x);

double _naturalLog(double x) {
  if (x <= 0) return double.negativeInfinity;

  // Use Taylor series approximation for natural log
  double result = 0.0;
  double term = (x - 1) / (x + 1);
  double termSquared = term * term;

  for (int i = 0; i < 20; i++) {
    result += term / (2 * i + 1);
    term *= termSquared;
  }

  return 2 * result;
}
