import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _pulseController;
  late AnimationController _rotateController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    // Navigate after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: HabitFlowGradients.splashBackground,
        ),
        child: Stack(
          children: [
            // Floating glass orb 1
            AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) {
                final dy = sin(_floatController.value * pi) * 30;
                return Positioned(
                  top: MediaQuery.of(context).size.height * 0.15 + dy,
                  left: MediaQuery.of(context).size.width * 0.1,
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.03),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 40,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Floating glass orb 2
            AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) {
                final dy = cos(_floatController.value * pi) * 20;
                return Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.1 + dy,
                  right: MediaQuery.of(context).size.width * 0.15,
                  child: Container(
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.04),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                );
              },
            ),
            // Small accent particle
            AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) {
                final dy = sin((_floatController.value + 0.3) * pi) * 15;
                return Positioned(
                  top: MediaQuery.of(context).size.height * 0.3 + dy,
                  right: MediaQuery.of(context).size.width * 0.3,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.4),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Center content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Prism icon container
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Colors.white.withValues(alpha: 0.1),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Inner flare
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.transparent,
                                  Colors.white.withValues(alpha: 0.2),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Center(
                          child: Icon(
                            Icons.all_inclusive,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Title
                  const Text(
                    'HabitFlow',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.02 * 40,
                      height: 48 / 40,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Subtitle
                  const Text(
                    'LUMINOUS ROUTINE',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: HabitFlowColors.primaryFixedDim,
                      letterSpacing: 0.2 * 14,
                      height: 20 / 14,
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Pulsing dots
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          final delay = index * 0.2;
                          final value =
                              ((_pulseController.value + delay) % 1.0);
                          final scale = 0.85 + 0.15 * sin(value * pi);
                          final alpha = 0.3 + 0.7 * sin(value * pi);
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            width: 10 * scale,
                            height: 10 * scale,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: alpha),
                              boxShadow: alpha > 0.6
                                  ? [
                                      BoxShadow(
                                        color:
                                            Colors.white.withValues(alpha: 0.4),
                                        blurRadius: 15,
                                      ),
                                    ]
                                  : null,
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
