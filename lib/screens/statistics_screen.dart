import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../providers/habit_provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final weeklyCompletionRate = provider.weeklyCompletionRate;
    final weeklyTrend = provider.weeklyTrend;
    final globalStreak = provider.globalStreak;
    
    // Find best habit
    final activeHabits = provider.activeHabits;
    var bestHabit = activeHabits.isNotEmpty ? activeHabits.first : null;
    for (var h in activeHabits) {
      if (bestHabit != null && h.longestStreak > bestHabit.longestStreak) {
        bestHabit = h;
      }
    }

    // Prepare donut data
    final Map<String, Color> categoryColors = {
      'Health': HabitFlowColors.primary,
      'Learning': HabitFlowColors.secondaryContainer,
      'Fitness': HabitFlowColors.tertiaryFixedDim,
    };
    final List<(Color, double)> donutSegments = [];
    final List<Widget> legendItems = [];
    
    for (var cat in categoryColors.keys) {
      double rate = provider.categoryFocusRate(cat);
      if (rate > 0) {
        donutSegments.add((categoryColors[cat]!, rate));
        legendItems.add(_LegendItem(categoryColors[cat]!, cat));
      }
    }
    // Fallback if empty
    if (donutSegments.isEmpty) {
      donutSegments.add((HabitFlowColors.surfaceVariant, 1.0));
      legendItems.add(const _LegendItem(HabitFlowColors.surfaceVariant, 'No Data'));
    }

    return Scaffold(
      backgroundColor: HabitFlowColors.surface,
      extendBody: true,
      body: Stack(
        children: [
          // Ambient
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: HabitFlowColors.primary.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -40,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: HabitFlowColors.tertiaryFixedDim.withValues(alpha: 0.05),
              ),
            ),
          ),
          // App bar
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
                              color: Colors.white.withValues(alpha: 0.4),
                              width: 2),
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
            bottom: 72 + MediaQuery.of(context).padding.bottom,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Analytics',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: HabitFlowColors.primary,
                      height: 34 / 28,
                    ),
                  ),
                  const Text(
                    'Your progress over time.',
                    style: TextStyle(
                      fontSize: 16,
                      color: HabitFlowColors.onSurfaceVariant,
                      height: 24 / 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Weekly consistency chart
                  GlassCard(
                    opacity: 0.25,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'WEEKLY CONSISTENCY',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: HabitFlowColors.onSurfaceVariant,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(weeklyCompletionRate * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: HabitFlowColors.primary,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Bar chart
                        SizedBox(
                          height: 100,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _StatBar(weeklyTrend[0] ?? 0.0, 'M', false),
                              _StatBar(weeklyTrend[1] ?? 0.0, 'T', false),
                              _StatBar(weeklyTrend[2] ?? 0.0, 'W', false),
                              _StatBar(weeklyTrend[3] ?? 0.0, 'T', false),
                              _StatBar(weeklyTrend[4] ?? 0.0, 'F', false),
                              _StatBar(weeklyTrend[5] ?? 0.0, 'S', false),
                              _StatBar(weeklyTrend[6] ?? 0.0, 'S', true),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Focus Areas + Mini cards row
                  Row(
                    children: [
                      // Donut chart
                      Expanded(
                        child: GlassCard(
                          opacity: 0.25,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Focus Areas',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: HabitFlowColors.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Donut
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: CustomPaint(
                                  painter: _DonutPainter(donutSegments),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: legendItems,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Mini stat cards
                      Expanded(
                        child: Column(
                          children: [
                            GlassCard(
                              opacity: 0.25,
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.local_fire_department,
                                      color: HabitFlowColors.tertiaryFixedDim),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$globalStreak',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: HabitFlowColors.primary,
                                    ),
                                  ),
                                  const Text(
                                    'Day Streak',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: HabitFlowColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            GlassCard(
                              opacity: 0.25,
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(bestHabit?.icon ?? Icons.star,
                                      color: bestHabit?.color ?? HabitFlowColors.secondary),
                                  const SizedBox(height: 4),
                                  Text(
                                    bestHabit?.title ?? 'None',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: HabitFlowColors.primary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Text(
                                    'Best Habit',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: HabitFlowColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Trophies
                  const Text(
                    'Trophies',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: HabitFlowColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                    children: [
                      _TrophyCard(
                        icon: Icons.local_fire_department,
                        title: 'Ignition',
                        subtitle: '7 Day Streak',
                        unlocked: globalStreak >= 7,
                      ),
                      _TrophyCard(
                        icon: Icons.check_circle,
                        title: 'Centurion',
                        subtitle: '100 Habits',
                        unlocked: false,
                        progress: 0.46,
                      ),
                      _TrophyCard(
                        icon: Icons.diamond,
                        title: 'Flawless',
                        subtitle: '14/30',
                        unlocked: globalStreak >= 30,
                        progress: globalStreak / 30,
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final double height;
  final String label;
  final bool isHighlighted;

  const _StatBar(this.height, this.label, this.isHighlighted);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: HabitFlowColors.surfaceVariant.withValues(alpha: 0.5),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: height,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isHighlighted
                            ? HabitFlowColors.primary
                            : height > 0.5
                                ? HabitFlowColors.primary
                                : HabitFlowColors.tertiaryFixedDim,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w600,
                color: isHighlighted
                    ? HabitFlowColors.primary
                    : HabitFlowColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<(Color, double)> segments;

  _DonutPainter(this.segments);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 18.0;

    double startAngle = -1.5708; // -pi/2
    for (final (color, fraction) in segments) {
      final sweepAngle = 2 * 3.14159 * fraction;
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      startAngle += sweepAngle;
    }

    // Inner white circle
    canvas.drawCircle(
      center,
      radius - strokeWidth - 4,
      Paint()..color = Colors.white.withValues(alpha: 0.8),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem(this.color, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: HabitFlowColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _TrophyCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool unlocked;
  final double? progress;

  const _TrophyCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.unlocked,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      opacity: unlocked ? 0.35 : 0.15,
      padding: const EdgeInsets.all(12),
      child: Opacity(
        opacity: unlocked ? 1.0 : 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 40,
                color: unlocked
                    ? HabitFlowColors.primary
                    : HabitFlowColors.outlineVariant),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: unlocked
                    ? HabitFlowColors.primary
                    : HabitFlowColors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: HabitFlowColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (progress != null) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress!.clamp(0.0, 1.0),
                  backgroundColor: HabitFlowColors.surfaceVariant,
                  valueColor:
                      const AlwaysStoppedAnimation(HabitFlowColors.outline),
                  minHeight: 4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
