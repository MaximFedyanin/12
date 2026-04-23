import 'package:hive/hive.dart';

class UsageExample {
  final String text;
  final String style; // "literary", "formal", "casual"
  final String? source;

  UsageExample({
    required this.text,
    required this.style,
    this.source,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'style': style,
      'source': source,
    };
  }

  factory UsageExample.fromJson(Map<String, dynamic> json) {
    return UsageExample(
      text: json['text'] as String,
      style: json['style'] as String,
      source: json['source'] as String?,
    );
  }
}

class Word {
  final String id; // "word_en_ru_{cefr}_{freq_rank}"
  final String english;
  final List<String> russianTranslations;

  // Statistics
  int totalShows; // количество показов в тренировках
  int correctAnswers;
  int lastAttemptTimestamp; // Unix timestamp

  // Difficulty
  double localDifficulty; // 0.0 (легко) → 1.0 (сложно)
  double globalDifficulty; // синхронизируется с сервера
  final String cefrLevel; // A1, A2, B1, B2, C1, C2

  // Content
  final List<UsageExample> examples;
  final List<String> semanticTags; // ["business", "psychology", ...]

  // Meta
  final DateTime addedAt;
  final DateTime updatedAt;

  Word({
    required this.id,
    required this.english,
    required this.russianTranslations,
    this.totalShows = 0,
    this.correctAnswers = 0,
    this.lastAttemptTimestamp = 0,
    this.localDifficulty = 0.5,
    this.globalDifficulty = 0.5,
    required this.cefrLevel,
    this.examples = const [],
    this.semanticTags = const [],
    DateTime? addedAt,
    DateTime? updatedAt,
  })  : addedAt = addedAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'english': english,
      'russianTranslations': russianTranslations,
      'totalShows': totalShows,
      'correctAnswers': correctAnswers,
      'lastAttemptTimestamp': lastAttemptTimestamp,
      'localDifficulty': localDifficulty,
      'globalDifficulty': globalDifficulty,
      'cefrLevel': cefrLevel,
      'examples': examples.map((e) => e.toJson()).toList(),
      'semanticTags': semanticTags,
      'addedAt': addedAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'] as String,
      english: json['english'] as String,
      russianTranslations: (json['russianTranslations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      totalShows: json['totalShows'] as int? ?? 0,
      correctAnswers: json['correctAnswers'] as int? ?? 0,
      lastAttemptTimestamp: json['lastAttemptTimestamp'] as int? ?? 0,
      localDifficulty: (json['localDifficulty'] as num?)?.toDouble() ?? 0.5,
      globalDifficulty: (json['globalDifficulty'] as num?)?.toDouble() ?? 0.5,
      cefrLevel: json['cefrLevel'] as String,
      examples: (json['examples'] as List<dynamic>?)
              ?.map((e) => UsageExample.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      semanticTags: (json['semanticTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      addedAt: DateTime.parse(json['addedAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Word copyWith({
    String? id,
    String? english,
    List<String>? russianTranslations,
    int? totalShows,
    int? correctAnswers,
    int? lastAttemptTimestamp,
    double? localDifficulty,
    double? globalDifficulty,
    String? cefrLevel,
    List<UsageExample>? examples,
    List<String>? semanticTags,
    DateTime? addedAt,
    DateTime? updatedAt,
  }) {
    return Word(
      id: id ?? this.id,
      english: english ?? this.english,
      russianTranslations: russianTranslations ?? this.russianTranslations,
      totalShows: totalShows ?? this.totalShows,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      lastAttemptTimestamp:
          lastAttemptTimestamp ?? this.lastAttemptTimestamp,
      localDifficulty: localDifficulty ?? this.localDifficulty,
      globalDifficulty: globalDifficulty ?? this.globalDifficulty,
      cefrLevel: cefrLevel ?? this.cefrLevel,
      examples: examples ?? this.examples,
      semanticTags: semanticTags ?? this.semanticTags,
      addedAt: addedAt ?? this.addedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Word && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Hive Type Adapters
class WordAdapter extends TypeAdapter<Word> {
  @override
  final int typeId = 0;

  @override
  Word read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fieldsMap = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fieldsMap[reader.readByte()] = reader.read();
    }
    return Word(
      id: fieldsMap[0] as String,
      english: fieldsMap[1] as String,
      russianTranslations: (fieldsMap[2] as List).cast<String>(),
      totalShows: fieldsMap[3] as int? ?? 0,
      correctAnswers: fieldsMap[4] as int? ?? 0,
      lastAttemptTimestamp: fieldsMap[5] as int? ?? 0,
      localDifficulty: (fieldsMap[6] as num?)?.toDouble() ?? 0.5,
      globalDifficulty: (fieldsMap[7] as num?)?.toDouble() ?? 0.5,
      cefrLevel: fieldsMap[8] as String,
      examples: (fieldsMap[9] as List?)
              ?.map((e) => UsageExampleAdapter().read(e as BinaryReader))
              .toList() ??
          [],
      semanticTags: (fieldsMap[10] as List?)?.cast<String>() ?? [],
      addedAt: fieldsMap[11] as DateTime? ?? DateTime.now(),
      updatedAt: fieldsMap[12] as DateTime? ?? DateTime.now(),
    );
  }

  @override
  void write(BinaryWriter writer, Word obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.english)
      ..writeByte(2)
      ..write(obj.russianTranslations)
      ..writeByte(3)
      ..write(obj.totalShows)
      ..writeByte(4)
      ..write(obj.correctAnswers)
      ..writeByte(5)
      ..write(obj.lastAttemptTimestamp)
      ..writeByte(6)
      ..write(obj.localDifficulty)
      ..writeByte(7)
      ..write(obj.globalDifficulty)
      ..writeByte(8)
      ..write(obj.cefrLevel)
      ..writeByte(9)
      ..write(obj.examples)
      ..writeByte(10)
      ..write(obj.semanticTags)
      ..writeByte(11)
      ..write(obj.addedAt)
      ..writeByte(12)
      ..write(obj.updatedAt);
  }
}

class UsageExampleAdapter extends TypeAdapter<UsageExample> {
  @override
  final int typeId = 1;

  @override
  UsageExample read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fieldsMap = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fieldsMap[reader.readByte()] = reader.read();
    }
    return UsageExample(
      text: fieldsMap[0] as String,
      style: fieldsMap[1] as String,
      source: fieldsMap[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UsageExample obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.style)
      ..writeByte(2)
      ..write(obj.source);
  }
}
