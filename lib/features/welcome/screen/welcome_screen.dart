import 'package:flutter/material.dart';
import '../../../core/constants/app_settings.dart';
import '../../../core/database/database_helper.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  String? _userName;
  int _correctAnswers = 0;
  int _uniqueWordsAnswered = 0;
  bool _showBulldogOverlay = false;

  late AnimationController _overlayController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    _overlayController = AnimationController(
      duration: AppSettings.scaleInDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _overlayController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _overlayController, curve: Curves.easeIn),
    );
  }

  Future<void> _loadUserData() async {
    final name = DatabaseHelper.getUserName();
    final progress = DatabaseHelper.getUserProgress('default_user');

    setState(() {
      _userName = name ?? 'Friend';
      _correctAnswers = progress?.totalCorrectAnswers ?? 0;
      _uniqueWordsAnswered = progress?.totalUniqueWordsAnswered ?? 0;
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12 && hour >= 4) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    if (hour < 22) return 'Good evening';
    return 'Good night';
  }

  void _handleNameDoubleTap() {
    setState(() {
      _showBulldogOverlay = true;
    });
    _overlayController.forward();
  }

  void _hideOverlay() {
    _overlayController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showBulldogOverlay = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _overlayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Stack(
        children: [
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // Statistics cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          '✅ correct answers: $_correctAnswers',
                          AppColors.blueLight,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          '🏅 unique words: $_uniqueWordsAnswered',
                          AppColors.greenLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Greeting with double-tap interaction
                  GestureDetector(
                    onDoubleTap: _handleNameDoubleTap,
                    child: Text(
                      '$_getGreeting, $_userName!',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Menu buttons
                  Expanded(
                    child: ListView(
                      children: [
                        _buildMenuButton('new words', Icons.add_circle_outline),
                        _buildMenuButton('repetition', Icons.refresh),
                        _buildMenuButton('mixed (prev + new)', Icons.shuffle),
                        _buildMenuButton('custom sets', Icons.folder),
                        _buildMenuButton('my progress', Icons.trending_up),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bulldog overlay (shown on double-tap)
          if (_showBulldogOverlay)
            Positioned.fill(
              child: GestureDetector(
                onTap: _hideOverlay,
                child: Container(
                  color: Colors.white.withValues(alpha: 0.3),
                  child: Center(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: AppColors.greenLight.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.pets,
                            size: 100,
                            color: AppColors.greenLight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String text, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildMenuButton(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: () {
            // Navigate to appropriate screen
            if (text == 'new words') {
              Navigator.pushNamed(context, '/keyword-input');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.greenLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
