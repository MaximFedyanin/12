class AppStrings {
  AppStrings._();

  // Splash Screen
  static const String goodMorning = 'Good morning!';
  static const String goodAfternoon = 'Good afternoon!';
  static const String goodEvening = 'Good evening!';

  // Onboarding Screen
  static const String onboardingTitle = 'Hello! My name is Word, I\'m going to learn English words with you! Tell me, please, your name';
  static const String letsStart = 'Let\'s start!';
  static const String enterYourName = 'Enter your name';

  // Welcome Screen
  static const String correctAnswers = '✅ correct answers: ';
  static const String uniqueWordsAnswered = '🏅 unique words answered: ';
  static const String newWords = 'new words';
  static const String repetition = 'repetition';
  static const String mixed = 'mixed (prev + new)';
  static const String customSets = 'custom sets';
  static const String myProgress = 'my progress';

  // Keyword Input Screen
  static const String enterKeywords = 'Enter keywords to define the theme (separated by a space, without commas)';
  static const String build = 'BUILD';
  static const String back = '← Back';

  // Training Screen
  static const String submit = 'Submit';
  static const String exampleOfUsage = 'Example of usage';
  static const String tooLateWithAnswer = 'too late with answer';
  static const String formalPrefix = '[formal] ';
  static const String casualPrefix = '[casual] ';

  // Validation
  static const String nameTooShort = 'Name must be at least 2 characters';
  static const String invalidCharacters = 'Name contains invalid characters';
  static const String nameRequired = 'Name is required';

  // Example styles
  static const String literaryStyle = 'literary';
  static const String formalStyle = 'formal';
  static const String casualStyle = 'casual';
}

// Keyword examples for carousel
class KeywordExamples {
  KeywordExamples._();

  static const List<String> examples = [
    'kitchen design flat',
    'food beauty wellness',
    'travel adventure culture',
    'business finance startup',
    'health fitness nutrition',
  ];
}
