class SessionResult {
  final String id;
  final String sessionId;
  final String wordId;
  final int timestamp; // Unix timestamp
  final double responseTimeSec;
  final String resultType; // "correct", "incorrect", "correct_but_late", "incorrect_and_late"
  final String userInput;
  final List<String> expectedAnswers;
  final SessionContext context;

  SessionResult({
    required this.id,
    required this.sessionId,
    required this.wordId,
    required this.timestamp,
    required this.responseTimeSec,
    required this.resultType,
    required this.userInput,
    required this.expectedAnswers,
    required this.context,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionId': sessionId,
      'wordId': wordId,
      'timestamp': timestamp,
      'response_time_sec': responseTimeSec,
      'result_type': resultType,
      'user_input': userInput,
      'expected_answers': expectedAnswers,
      'context': context.toJson(),
    };
  }

  factory SessionResult.fromJson(Map<String, dynamic> json) {
    return SessionResult(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      wordId: json['wordId'] as String,
      timestamp: json['timestamp'] as int,
      responseTimeSec: (json['response_time_sec'] as num).toDouble(),
      resultType: json['result_type'] as String,
      userInput: json['user_input'] as String,
      expectedAnswers: (json['expected_answers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      context: SessionContext.fromJson(json['context'] as Map<String, dynamic>),
    );
  }
}

class SessionContext {
  final String mode; // "new words", "repetition", "mixed"
  final List<String> themeKeywords;
  final String deviceModel;
  final String appVersion;

  SessionContext({
    required this.mode,
    required this.themeKeywords,
    required this.deviceModel,
    required this.appVersion,
  });

  Map<String, dynamic> toJson() {
    return {
      'mode': mode,
      'theme_keywords': themeKeywords,
      'device_model': deviceModel,
      'app_version': appVersion,
    };
  }

  factory SessionContext.fromJson(Map<String, dynamic> json) {
    return SessionContext(
      mode: json['mode'] as String,
      themeKeywords: (json['theme_keywords'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      deviceModel: json['device_model'] as String,
      appVersion: json['app_version'] as String,
    );
  }
}
