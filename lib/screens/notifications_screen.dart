import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _activeTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HabitFlowColors.surface,
      body: Stack(
        children: [
          // Ambient blobs
          Positioned(
            top: -MediaQuery.of(context).size.height * 0.1,
            left: -MediaQuery.of(context).size.width * 0.1,
            child: Container(
              width: 384,
              height: 384,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: HabitFlowColors.primary.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.1,
            right: -MediaQuery.of(context).size.width * 0.1,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: HabitFlowColors.tertiaryFixedDim.withValues(alpha: 0.15),
              ),
            ),
          ),
          // Top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                      20, MediaQuery.of(context).padding.top + 8, 20, 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    border: Border(
                      bottom: BorderSide(
                          color: Colors.white.withValues(alpha: 0.4)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'HabitFlow',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: HabitFlowColors.primary,
                        ),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HabitFlowColors.primaryContainer,
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.5)),
                        ),
                        child: const Center(
                          child: Text('A',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Content
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + 56,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Tab switcher
                  ClipRRect(
                    borderRadius: BorderRadius.circular(9999),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          children: [
                            _TabBtn('Alerts', 0),
                            _TabBtn('Empty', 1),
                            _TabBtn('Success', 2),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Views
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _activeTab == 0
                          ? const _AlertsView(key: ValueKey(0))
                          : _activeTab == 1
                              ? const _EmptyView(key: ValueKey(1))
                              : const _SuccessView(key: ValueKey(2)),
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

  Widget _TabBtn(String label, int index) {
    final isActive = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white.withValues(alpha: 0.5)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(9999),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? HabitFlowColors.primary
                    : HabitFlowColors.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AlertsView extends StatelessWidget {
  const _AlertsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Smart Reminders',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: HabitFlowColors.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Mark all read',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: HabitFlowColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _NotifItem(
            icon: Icons.water_drop,
            iconBgColor: HabitFlowColors.primary.withValues(alpha: 0.1),
            iconColor: HabitFlowColors.primary,
            title: 'Morning Hydration',
            subtitle: '8:00 AM • Daily',
            isOn: true,
          ),
          const SizedBox(height: 12),
          _NotifItem(
            icon: Icons.menu_book,
            iconBgColor:
                HabitFlowColors.tertiaryContainer.withValues(alpha: 0.1),
            iconColor: HabitFlowColors.tertiaryContainer,
            title: 'Read 10 Pages',
            subtitle: '8:30 PM • Mon, Wed, Fri',
            isOn: false,
          ),
          const SizedBox(height: 12),
          _NotifItem(
            icon: Icons.self_improvement,
            iconBgColor:
                HabitFlowColors.secondaryContainer.withValues(alpha: 0.1),
            iconColor: HabitFlowColors.secondary,
            title: 'Mindful Stretch',
            subtitle: '12:00 PM • Daily',
            isOn: true,
          ),
        ],
      ),
    );
  }
}

class _NotifItem extends StatefulWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isOn;

  const _NotifItem({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isOn,
  });

  @override
  State<_NotifItem> createState() => _NotifItemState();
}

class _NotifItemState extends State<_NotifItem> {
  late bool _toggled;

  @override
  void initState() {
    super.initState();
    _toggled = widget.isOn;
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      opacity: 0.25,
      borderRadius: 16,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: widget.iconBgColor,
              border:
                  Border.all(color: widget.iconColor.withValues(alpha: 0.2)),
            ),
            child: Icon(widget.icon, color: widget.iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: HabitFlowColors.onSurface,
                  ),
                ),
                Text(
                  widget.subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: HabitFlowColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // Toggle
          GestureDetector(
            onTap: () => setState(() => _toggled = !_toggled),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 44,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: _toggled
                    ? HabitFlowColors.primary.withValues(alpha: 0.8)
                    : Colors.white.withValues(alpha: 0.3),
                border: Border.all(
                    color: _toggled
                        ? Colors.transparent
                        : Colors.white.withValues(alpha: 0.5)),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                alignment:
                    _toggled ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Illustration placeholder
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: HabitFlowColors.primary.withValues(alpha: 0.05),
          ),
          child: Icon(
            Icons.inbox_rounded,
            size: 80,
            color: HabitFlowColors.primary.withValues(alpha: 0.3),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'A Blank Canvas',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: HabitFlowColors.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        const SizedBox(
          width: 280,
          child: Text(
            'Your journey to a better you starts here. Create your first habit and enter the flow.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: HabitFlowColors.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/add-habit'),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                decoration: BoxDecoration(
                  color: HabitFlowColors.primary,
                  borderRadius: BorderRadius.circular(9999),
                  border: Border(
                    top: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: HabitFlowColors.primary.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Start Tracking',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SuccessView extends StatefulWidget {
  const _SuccessView({super.key});

  @override
  State<_SuccessView> createState() => _SuccessViewState();
}

class _SuccessViewState extends State<_SuccessView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Confetti
        ...List.generate(20, (i) {
          final random = Random(i);
          final colors = [
            HabitFlowColors.primary.withValues(alpha: 0.6),
            HabitFlowColors.tertiaryFixedDim.withValues(alpha: 0.6),
            Colors.white.withValues(alpha: 0.8),
          ];
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final progress = (_controller.value + random.nextDouble() * 0.5)
                  .clamp(0.0, 1.0);
              return Positioned(
                left: random.nextDouble() * MediaQuery.of(context).size.width,
                top: -20 + progress * MediaQuery.of(context).size.height,
                child: Opacity(
                  opacity: (1 - progress).clamp(0.0, 1.0),
                  child: Transform.rotate(
                    angle: progress * pi * 2,
                    child: Container(
                      width: 6 + random.nextDouble() * 8,
                      height: 10 + random.nextDouble() * 12,
                      decoration: BoxDecoration(
                        color: colors[random.nextInt(colors.length)],
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
        // Center content
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ring animation
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return SizedBox(
                  width: 192,
                  height: 192,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Ring
                      CustomPaint(
                        size: const Size(192, 192),
                        painter: _SuccessRingPainter(
                          _controller.value,
                        ),
                      ),
                      // Center icon
                      Transform.scale(
                        scale: Curves.elasticOut
                            .transform(_controller.value.clamp(0.0, 1.0)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(64),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Container(
                              width: 128,
                              height: 128,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.4),
                                border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.6)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.workspace_premium,
                                size: 60,
                                color: HabitFlowColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            ShaderMask(
              shaderCallback: (bounds) =>
                  HabitFlowGradients.cyanToIndigo.createShader(bounds),
              child: const Text(
                'Momentum Built!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const SizedBox(
              width: 300,
              child: Text(
                "You've completed your daily hydration goal. Keep riding the wave.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: HabitFlowColors.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9999),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    decoration: BoxDecoration(
                      color: HabitFlowColors.surface,
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.5)),
                    ),
                    child: const Text(
                      'Continue Flow',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: HabitFlowColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SuccessRingPainter extends CustomPainter {
  final double progress;

  _SuccessRingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;

    // Track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
    );

    // Progress
    final paint = Paint()
      ..color = HabitFlowColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_SuccessRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
