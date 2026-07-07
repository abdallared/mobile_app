import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/progress_ring.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';

const List<String> _monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December'
];

class HabitDetailScreen extends StatefulWidget {
  const HabitDetailScreen({super.key});

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month, 1);
  }

  void _prevMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get habit passed from route
    final passedHabit = ModalRoute.of(context)!.settings.arguments as Habit?;
    if (passedHabit == null) {
      return const Scaffold(body: Center(child: Text('Error: No habit provided.')));
    }

    final provider = context.watch<HabitProvider>();
    final habit = provider.getHabit(passedHabit.id);

    final today = Habit.normalizeDate(DateTime.now());
    final isCompletedToday = habit.isCompletedOn(today);

    // Calculate generic stats
    final double completionRate = habit.completedDates.isNotEmpty 
        ? min(1.0, habit.completedDates.length / 30.0) 
        : 0.0;
    
    return Scaffold(
      backgroundColor: HabitFlowColors.surface,
      extendBody: true,
      body: Stack(
        children: [
          // Ambient bg
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: habit.color.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -60,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: habit.color.withValues(alpha: 0.05),
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
                    color: Colors.white.withValues(alpha: 0.4),
                    border: Border(
                      bottom: BorderSide(
                          color: Colors.white.withValues(alpha: 0.4)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          child: const Icon(Icons.arrow_back,
                              color: HabitFlowColors.primary),
                        ),
                      ),
                      Text(
                        habit.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: HabitFlowColors.primary,
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: habit.color.withValues(alpha: 0.2),
                          border: Border.all(
                              color: habit.color.withValues(alpha: 0.5)),
                        ),
                        child: Center(
                          child: Icon(habit.icon, color: habit.color, size: 20),
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
                children: [
                  // Hero Progress card
                  GlassCard(
                    opacity: 0.6,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ProgressRing(
                              progress: completionRate,
                              size: 160,
                              strokeWidth: 8,
                              center: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${(completionRate * 100).toInt()}%',
                                    style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w700,
                                      color: HabitFlowColors.primary,
                                      height: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'COMPLETION',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: HabitFlowColors.onSurfaceVariant,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                children: [
                                  _MiniStat(
                                    icon: Icons.local_fire_department,
                                    iconColor: HabitFlowColors.tertiaryFixedDim,
                                    value: '${habit.currentStreak}',
                                    label: 'Day Streak',
                                  ),
                                  const SizedBox(height: 12),
                                  _MiniStat(
                                    icon: Icons.emoji_events,
                                    iconColor: HabitFlowColors.secondary,
                                    value: '${habit.completedDates.length}',
                                    label: 'Total Days',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Longest streak
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Longest Streak',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: HabitFlowColors.onSurfaceVariant,
                                    ),
                                  ),
                                  Text(
                                    '${habit.longestStreak} Days',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: HabitFlowColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(Icons.trending_up,
                                  color: HabitFlowColors.outlineVariant,
                                  size: 36),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Calendar heatmap
                  GlassCard(
                    opacity: 0.6,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_monthNames[_currentMonth.month - 1]} ${_currentMonth.year}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: HabitFlowColors.onSurface,
                              ),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: _prevMonth,
                                  child: const _NavCircle(Icons.chevron_left),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: _nextMonth,
                                  child: const _NavCircle(Icons.chevron_right),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Day headers
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children:
                              ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su']
                                  .map((d) => SizedBox(
                                        width: 36,
                                        child: Center(
                                          child: Text(
                                            d,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: HabitFlowColors
                                                  .onSurfaceVariant,
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                        ),
                        const SizedBox(height: 8),
                        // Calendar grid (dynamic)
                        _CalendarGrid(
                          habit: habit,
                          currentMonth: _currentMonth,
                        ),
                        const SizedBox(height: 12),
                        // Legend
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _LegendDot(
                              color: habit.color.withValues(alpha: 0.3),
                              label: 'Completed',
                            ),
                            const SizedBox(width: 16),
                            const _LegendDot(
                              color: HabitFlowColors.surfaceVariant,
                              label: 'Missed',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      // FAB check
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: isCompletedToday ? habit.color : HabitFlowColors.surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (isCompletedToday ? habit.color : HabitFlowColors.primary)
                  .withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            provider.toggleHabitCompletion(habit.id, today);
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(
            isCompletedToday ? Icons.undo : Icons.check, 
            color: isCompletedToday ? Colors.white : habit.color, 
            size: 28
          ),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _MiniStat({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: HabitFlowColors.primary,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: HabitFlowColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavCircle extends StatelessWidget {
  final IconData icon;
  const _NavCircle(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.5),
      ),
      child: Icon(icon, size: 18, color: HabitFlowColors.onSurfaceVariant),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  final Habit habit;
  final DateTime currentMonth;

  const _CalendarGrid({required this.habit, required this.currentMonth});

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final firstDayWeekday = DateTime(currentMonth.year, currentMonth.month, 1).weekday; // 1 = Monday, 7 = Sunday
    
    final emptySlots = firstDayWeekday - 1; // Align to Monday start
    final totalSlots = emptySlots + daysInMonth;
    final today = Habit.normalizeDate(DateTime.now());

    return GridView.builder(
      itemCount: totalSlots,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        if (index < emptySlots) {
          return const SizedBox();
        }

        final day = index - emptySlots + 1;
        final cellDate = DateTime(currentMonth.year, currentMonth.month, day);
        final isCompleted = habit.isCompletedOn(cellDate);
        final isToday = cellDate.year == today.year && 
                        cellDate.month == today.month && 
                        cellDate.day == today.day;
        final isFuture = cellDate.isAfter(today);

        Color bg;
        Color textColor;

        if (isToday) {
          bg = Colors.transparent;
          textColor = Colors.white;
        } else if (isCompleted) {
          bg = habit.color.withValues(alpha: 0.3);
          textColor = habit.color;
        } else if (isFuture) {
          bg = Colors.transparent;
          textColor = HabitFlowColors.onSurfaceVariant.withValues(alpha: 0.5);
        } else {
          bg = HabitFlowColors.surfaceVariant;
          textColor = HabitFlowColors.onSurfaceVariant;
        }

        return Container(
          decoration: isToday
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    colors: [
                      habit.color,
                      habit.color.withValues(alpha: 0.5),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: habit.color.withValues(alpha: 0.3),
                      blurRadius: 8,
                    ),
                  ],
                )
              : BoxDecoration(
                  shape: BoxShape.circle,
                  color: bg,
                ),
          child: Center(
            child: Text(
              '$day',
              style: TextStyle(
                fontSize: 14,
                fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                color: textColor,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
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
