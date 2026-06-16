import 'package:flutter/material.dart';
import 'dart:async';

import '../auth/presentation/screens/sign_up_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin { // Upgraded to support multiple animations

  late AnimationController _mainController;
  late AnimationController _pulseController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;

  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Main Entry Animation (Slower, 2.5 seconds for a premium feel)
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // --- Logo Animations (Happens from 0% to 50% of the timeline) ---
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    // --- Text Animations (Happens from 40% to 100% of the timeline) ---
    // This creates a "staggered" effect where the text follows the logo
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2), // Starts slightly lower
      end: Offset.zero,            // Glides up into position
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    // 2. Pulse Animation for the "Initializing..." text
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Start the main animation, then begin pulsing the loading text
    _mainController.forward().then((_) {
      _pulseController.repeat(reverse: true);
    });

    // Navigate to the next screen after the animations complete
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SignupScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // A premium, very soft slate-white
      body: Stack(
        children: [
          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- Animated Logo ---
                FadeTransition(
                  opacity: _logoFadeAnimation,
                  child: ScaleTransition(
                    scale: _logoScaleAnimation,
                    child: Container(
                      height: screenHeight * 0.16,
                      width: screenHeight * 0.16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32), // Smoother, rounder corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06), // Very soft, elegant shadow
                            blurRadius: 30,
                            spreadRadius: 5,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Image.asset(
                          'assets/images/ipopi.jpg',
                          // fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // --- Animated Main Text ---
                FadeTransition(
                  opacity: _textFadeAnimation,
                  child: SlideTransition(
                    position: _textSlideAnimation,
                    child: Column(
                      children: [
                        const Text(
                          'Ipopi Notes Manager',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700, // Bolder, structured look
                            letterSpacing: -0.5, // Tighter tracking looks more modern
                            color: Color(0xFF0F172A), // Deep Slate, better than harsh black
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Organize your thoughts efficiently.',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.2,
                            color: const Color(0xFF64748B), // Muted professional grey
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- Animated Initializing Indicator (Bottom) ---
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: FadeTransition(
              // Only show the loading text AFTER the main text has faded in
              opacity: _textFadeAnimation,
              child: FadeTransition(
                // The continuous pulsing effect
                opacity: Tween<double>(begin: 0.3, end: 1.0).animate(_pulseController),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF94A3B8)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Initializing...',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: Color(0xFF94A3B8), // Matches the spinner
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}