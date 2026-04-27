import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/app_settings.dart';
import 'core/database/database_helper.dart';
//import 'core/database/models/word.dart';
//import 'core/database/models/user_progress.dart';
import 'features/onboarding/screen/onboarding_screen.dart';
import 'features/welcome/screen/welcome_screen.dart';
import 'presentation/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait for POCO F3
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Hive database
  await DatabaseHelper.initialize();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const WordBulldogApp());
}

class WordBulldogApp extends StatelessWidget {
  const WordBulldogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppSettings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/welcome': (context) => const WelcomeScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: AppSettings.splashAnimationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    // Navigate after 2 seconds
    Future.delayed(AppSettings.splashAnimationDuration, () {
      if (mounted) {
        _navigateToNextScreen();
      }
    });
  }

  Future<void> _navigateToNextScreen() async {
    final isFirstLaunch = DatabaseHelper.isFirstLaunch();

    if (isFirstLaunch) {
      Navigator.of(context).pushReplacementNamed('/onboarding');
    } else {
      Navigator.of(context).pushReplacementNamed('/welcome');
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return AppStrings.goodMorning;
    if (hour < 18) return AppStrings.goodAfternoon;
    return AppStrings.goodEvening;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bulldog image placeholder
            FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  color: AppColors.greenLight.withValues(0.3),
                  borderRadius: BorderRadius.circular(120),
                ),
                child: const Icon(
                  Icons.pets,
                  size: 120,
                  color: AppColors.greenLight,
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Greeting text
            SlideTransition(
              position: _slideAnimation,
              child: Text(
                _getGreeting(),
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppStrings {
  AppStrings._();
  static const String goodMorning = 'Good morning!';
  static const String goodAfternoon = 'Good afternoon!';
  static const String goodEvening = 'Good evening!';
}
