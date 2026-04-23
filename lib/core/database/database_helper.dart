import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'models/word.dart';
import 'models/user_progress.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static Box<Word>? _wordsBox;
  static Box<UserProgress>? _progressBox;
  static Box<dynamic>? _settingsBox;
  static Box<dynamic>? _cacheBox;

  static Future<void> initialize() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);

    // Register adapters
    Hive.registerAdapter(WordAdapter());
    Hive.registerAdapter(UsageExampleAdapter());
    Hive.registerAdapter(UserProgressAdapter());

    // Open boxes
    _wordsBox = await Hive.openBox<Word>('words');
    _progressBox = await Hive.openBox<UserProgress>('progress');
    _settingsBox = await Hive.openBox('settings');
    _cacheBox = await Hive.openBox('cache');
  }

  // Words operations
  static Box<Word> get wordsBox {
    if (_wordsBox == null) {
      throw Exception('Database not initialized. Call initialize() first.');
    }
    return _wordsBox!;
  }

  static Future<void> saveWord(Word word) async {
    await wordsBox.put(word.id, word);
  }

  static Future<void> saveWords(List<Word> words) async {
    for (final word in words) {
      await wordsBox.put(word.id, word);
    }
  }

  static Word? getWord(String id) {
    return wordsBox.get(id);
  }

  static List<Word> getAllWords() {
    return wordsBox.values.toList();
  }

  static Future<void> deleteWord(String id) async {
    await wordsBox.delete(id);
  }

  static Future<void> updateWordStats({
    required String wordId,
    required int totalShows,
    required int correctAnswers,
    required int lastAttemptTimestamp,
    required double localDifficulty,
  }) async {
    final word = getWord(wordId);
    if (word != null) {
      final updatedWord = word.copyWith(
        totalShows: totalShows,
        correctAnswers: correctAnswers,
        lastAttemptTimestamp: lastAttemptTimestamp,
        localDifficulty: localDifficulty,
      );
      await saveWord(updatedWord);
    }
  }

  // User progress operations
  static Box<UserProgress> get progressBox {
    if (_progressBox == null) {
      throw Exception('Database not initialized. Call initialize() first.');
    }
    return _progressBox!;
  }

  static Future<void> saveUserProgress(UserProgress progress) async {
    await progressBox.put(progress.id, progress);
  }

  static UserProgress? getUserProgress(String userId) {
    return progressBox.get(userId);
  }

  // Settings operations
  static Box<dynamic> get settingsBox {
    if (_settingsBox == null) {
      throw Exception('Database not initialized. Call initialize() first.');
    }
    return _settingsBox!;
  }

  static Future<void> saveSetting(String key, dynamic value) async {
    await settingsBox.put(key, value);
  }

  static dynamic getSetting(String key, {dynamic defaultValue}) {
    return settingsBox.get(key, defaultValue: defaultValue);
  }

  static bool isFirstLaunch() {
    return settingsBox.get('isFirstLaunch', defaultValue: true) as bool;
  }

  static Future<void> setFirstLaunchComplete() async {
    await settingsBox.put('isFirstLaunch', false);
  }

  static String? getUserName() {
    return settingsBox.get('userName') as String?;
  }

  static Future<void> saveUserName(String name) async {
    await settingsBox.put('userName', name);
  }

  // Cache operations
  static Box<dynamic> get cacheBox {
    if (_cacheBox == null) {
      throw Exception('Database not initialized. Call initialize() first.');
    }
    return _cacheBox!;
  }

  static Future<void> cacheQuery(String query, List<Word> results) async {
    await cacheBox.put('query_$query', {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'results': results.map((w) => w.toJson()).toList(),
    });
  }

  static List<Word>? getCachedQuery(String query) {
    final cached = cacheBox.get('query_$query');
    if (cached == null) return null;

    final timestamp = cached['timestamp'] as int;
    final now = DateTime.now().millisecondsSinceEpoch;
    final expirationHours = 24;

    if (now - timestamp > expirationHours * 60 * 60 * 1000) {
      cacheBox.delete('query_$query');
      return null;
    }

    final resultsJson = cached['results'] as List;
    return resultsJson
        .map((json) => Word.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  static Future<void> clearCache() async {
    await cacheBox.clear();
  }

  static Future<void> close() async {
    await _wordsBox?.close();
    await _progressBox?.close();
    await _settingsBox?.close();
    await _cacheBox?.close();
  }
}
