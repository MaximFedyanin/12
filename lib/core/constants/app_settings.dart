import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color darkGray = Color(0xFF1A1A1A);

  // Green shades for buttons
  static const Color greenLight = Color(0xFF81C784);
  static const Color greenMedium = Color(0xFF66BB6A);
  static const Color greenDark = Color(0xFF43A047);
  static const Color greenDeep = Color(0xFF2E7D32);

  // Blue gradient for examples
  static const Color blueLight = Color(0xFF64B5F6);
  static const Color blueDark = Color(0xFF42A5F5);

  // Background colors
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF5F5F5);

  // Text colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
}

class AppSettings {
  AppSettings._();

  // App info
  static const String appName = 'Word Bulldog';
  static const String appVersion = '1.0.0';
  static const int appVersionCode = 1;

  // Device info
  static const String targetDeviceModel = 'M2012K11AG'; // POCO F3
  static const int targetScreenHz = 120;

  // Performance settings
  static const Duration coldStartTarget = Duration(milliseconds: 1200);
  static const int targetFrameRate = 55;
  static const int memoryPeakMB = 350;
  static const Duration dbQueryTarget = Duration(milliseconds: 15);
  static const Duration networkRequestTarget = Duration(milliseconds: 800);

  // Database settings
  static const String wordsBoxName = 'words';
  static const String progressBoxName = 'progress';
  static const String settingsBoxName = 'settings';
  static const String cacheBoxName = 'cache';

  // Session settings
  static const int defaultWordsPerSession = 50;
  static const double timerThresholdSeconds = 10.0;
  static const int sessionTimerPrecisionMs = 100;

  // Difficulty calculation weights
  static const double exposureWeight = 0.4;
  static const double forgettingWeight = 0.35;
  static const double accuracyWeight = 0.25;

  // Forgetting curve settings
  static const double baseDecayCoefficient = 0.15;
  static const double minDifficulty = 0.05;
  static const double maxDifficulty = 0.95;

  // Cache settings
  static const int maxCachedQueries = 20;
  static const Duration cacheExpiration = Duration(hours: 24);

  // Name validation
  static const int maxNameLength = 25;
  static const int minNameLength = 2;

  // Carousel settings
  static const Duration carouselInterval = Duration(seconds: 4, milliseconds: 500);
  static const Duration carouselFadeDuration = Duration(milliseconds: 300);

  // Animation durations
  static const Duration splashAnimationDuration = Duration(milliseconds: 2000);
  static const Duration textFadeDuration = Duration(milliseconds: 200);
  static const Duration scaleInDuration = Duration(milliseconds: 250);
  static const Duration expandDownDuration = Duration(milliseconds: 300);
  static const Duration buttonColorTransition = Duration(milliseconds: 200);

  // API endpoints (for future sync)
  static const String baseUrl = 'https://api.wordbulldog.com';
  static const String syncEndpoint = '/api/v1/sync';
  static const String wordsEndpoint = '/api/v1/words';
  static const String progressEndpoint = '/api/v1/progress';

  // Security
  static const String encryptionKeyAlias = 'word_bulldog_key';
}
