import 'package:hive/hive.dart';

class UserProgress {
  final String id;
  final String userId;

  // Statistics
  int totalCorrectAnswers;
  int totalUniqueWordsAnswered;
  int totalSessionsCompleted;

  // Learning streak
  int currentStreak;
  int longestStreak;
  DateTime? lastSessionDate;

  // CEFR level progress
  Map<String, int> wordsLearnedByLevel; // {A1: 50, A2: 30, ...}

  // Meta
  DateTime createdAt;
  DateTime updatedAt;

  UserProgress({
    required this.id,
    required this.userId,
    this.totalCorrectAnswers = 0,
    this.totalUniqueWordsAnswered = 0,
    this.totalSessionsCompleted = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastSessionDate,
    Map<String, int>? wordsLearnedByLevel,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : wordsLearnedByLevel = wordsLearnedByLevel ?? {},
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'totalCorrectAnswers': totalCorrectAnswers,
      'totalUniqueWordsAnswered': totalUniqueWordsAnswered,
      'totalSessionsCompleted': totalSessionsCompleted,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastSessionDate': lastSessionDate?.toIso8601String(),
      'wordsLearnedByLevel': wordsLearnedByLevel,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      id: json['id'] as String,
      userId: json['userId'] as String,
      totalCorrectAnswers: json['totalCorrectAnswers'] as int? ?? 0,
      totalUniqueWordsAnswered: json['totalUniqueWordsAnswered'] as int? ?? 0,
      totalSessionsCompleted: json['totalSessionsCompleted'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      lastSessionDate: json['lastSessionDate'] != null
          ? DateTime.parse(json['lastSessionDate'] as String)
          : null,
      wordsLearnedByLevel: (json['wordsLearnedByLevel'] as Map?)
              ?.map((k, v) => MapEntry(k as String, v as int)) ??
          {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  UserProgress copyWith({
    String? id,
    String? userId,
    int? totalCorrectAnswers,
    int? totalUniqueWordsAnswered,
    int? totalSessionsCompleted,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastSessionDate,
    Map<String, int>? wordsLearnedByLevel,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProgress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      totalCorrectAnswers: totalCorrectAnswers ?? this.totalCorrectAnswers,
      totalUniqueWordsAnswered:
          totalUniqueWordsAnswered ?? this.totalUniqueWordsAnswered,
      totalSessionsCompleted:
          totalSessionsCompleted ?? this.totalSessionsCompleted,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastSessionDate: lastSessionDate ?? this.lastSessionDate,
      wordsLearnedByLevel: wordsLearnedByLevel ?? this.wordsLearnedByLevel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserProgressAdapter extends TypeAdapter<UserProgress> {
  @override
  final int typeId = 2;

  @override
  UserProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fieldsMap = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fieldsMap[reader.readByte()] = reader.read();
    }
    return UserProgress(
      id: fieldsMap[0] as String,
      userId: fieldsMap[1] as String,
      totalCorrectAnswers: fieldsMap[2] as int? ?? 0,
      totalUniqueWordsAnswered: fieldsMap[3] as int? ?? 0,
      totalSessionsCompleted: fieldsMap[4] as int? ?? 0,
      currentStreak: fieldsMap[5] as int? ?? 0,
      longestStreak: fieldsMap[6] as int? ?? 0,
      lastSessionDate: fieldsMap[7] as DateTime?,
      wordsLearnedByLevel:
          (fieldsMap[8] as Map?)?.map((k, v) => MapEntry(k as String, v as int)),
      createdAt: fieldsMap[9] as DateTime? ?? DateTime.now(),
      updatedAt: fieldsMap[10] as DateTime? ?? DateTime.now(),
    );
  }

  @override
  void write(BinaryWriter writer, UserProgress obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.totalCorrectAnswers)
      ..writeByte(3)
      ..write(obj.totalUniqueWordsAnswered)
      ..writeByte(4)
      ..write(obj.totalSessionsCompleted)
      ..writeByte(5)
      ..write(obj.currentStreak)
      ..writeByte(6)
      ..write(obj.longestStreak)
      ..writeByte(7)
      ..write(obj.lastSessionDate)
      ..writeByte(8)
      ..write(obj.wordsLearnedByLevel)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt);
  }
}
