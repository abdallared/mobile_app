import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      icon: Icons.checklist_rounded,
      title: 'Track effortlessly',
      subtitle:
          'Log your daily routines with a single tap. Experience a friction-free path to a better you.',
    ),
    _OnboardingPage(
      icon: Icons.eco_rounded,
      title: 'Build consistency',
      subtitle:
          'Watch your habits grow. Every completed day nurtures your progress and strengthens your streak.',
    ),
    _OnboardingPage(
      icon: Icons.insights_rounded,
      title: 'See achievements',
      subtitle:
          'Unlock insights into your behavior. Beautiful analytics help you understand your journey and celebrate wins.',
    ),
  ];

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip() {
    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HabitFlowColors.surface,
      body: Stack(
        children: [
          // Ambient background blobs
          const _AmbientBlob(
            top: -0.1,
            left: -0.1,
            size: 0.5,
            color: HabitFlowColors.primaryFixed,
            delay: 0,
          ),
          const _AmbientBlob(
            top: 0.2,
            right: -0.1,
            size: 0.4,
            color: HabitFlowColors.tertiaryFixed,
            delay: 2,
          ),
          const _AmbientBlob(
            bottom: -0.1,
            left: 0.1,
            size: 0.6,
            color: HabitFlowColors.secondaryFixed,
            delay: 4,
          ),
          // Page view
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: 3,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Illustration placeholder
                    Container(
                      width: 256,
                      height: 256,
                      margin: const EdgeInsets.only(bottom: 32),
                      decoration: BoxDecoration(
                        color:
                            HabitFlowColors.primaryFixed.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        page.icon,
                        size: 100,
                        color: HabitFlowColors.primary.withValues(alpha: 0.7),
                      ),
                    ),
                    // Glass card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                HabitFlowColors.primary.withValues(alpha: 0.05),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            page.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: HabitFlowColors.onSurface,
                              height: 34 / 28,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            page.subtitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: HabitFlowColors.onSurfaceVariant,
                              height: 24 / 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 120), // Space for bottom controls
                  ],
                ),
              );
            },
          ),
          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  20, 16, 20, MediaQuery.of(context).padding.bottom + 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    HabitFlowColors.surface.withValues(alpha: 0),
                    HabitFlowColors.surface.withValues(alpha: 0.8),
                    HabitFlowColors.surface.withValues(alpha: 0.9),
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Progress dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      final isActive = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: isActive
                              ? HabitFlowColors.primary
                              : HabitFlowColors.outlineVariant
                                  .withValues(alpha: 0.4),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: HabitFlowColors.primary
                                        .withValues(alpha: 0.5),
                                    blurRadius: 4,
                                  ),
                                ]
                              : null,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  // Buttons
                  if (_currentPage < 2)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: _skip,
                          style: TextButton.styleFrom(
                            minimumSize: const Size(0, 48),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9999),
                            ),
                          ),
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: HabitFlowColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: HabitFlowColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor: HabitFlowColors.primary
                                  .withValues(alpha: 0.25),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32),
                            ),
                            child: const Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: GradientButton(
                        label: 'Get Started',
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, '/login'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;

  _OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class _AmbientBlob extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double size;
  final Color color;
  final int delay;

  const _AmbientBlob({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.size,
    required this.color,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final blobSize = screenSize.width * size;
    return Positioned(
      top: top != null ? screenSize.height * top! : null,
      left: left != null ? screenSize.width * left! : null,
      right: right != null ? screenSize.width * right! : null,
      bottom: bottom != null ? screenSize.height * bottom! : null,
      child: Container(
        width: blobSize,
        height: blobSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
