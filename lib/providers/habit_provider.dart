import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../theme/app_theme.dart';

class HabitProvider extends ChangeNotifier {
  final List<Habit> _habits = [
    Habit(
      id: '1',
      title: 'Morning Hydration',
      category: 'Health',
      color: HabitFlowColors.primary,
      icon: Icons.water_drop,
      completedDates: {
        Habit.normalizeDate(DateTime.now()),
        Habit.normalizeDate(DateTime.now().subtract(const Duration(days: 1))),
        Habit.normalizeDate(DateTime.now().subtract(const Duration(days: 2))),
        Habit.normalizeDate(DateTime.now().subtract(const Duration(days: 4))),
        Habit.normalizeDate(DateTime.now().subtract(const Duration(days: 5))),
      },
    ),
    Habit(
      id: '2',
      title: 'Read 30 Minutes',
      category: 'Learning',
      color: HabitFlowColors.secondary,
      icon: Icons.menu_book,
      completedDates: {
        Habit.normalizeDate(DateTime.now().subtract(const Duration(days: 1))),
        Habit.normalizeDate(DateTime.now().subtract(const Duration(days: 3))),
      },
    ),
    Habit(
      id: '3',
      title: 'Workout',
      category: 'Fitness',
      color: HabitFlowColors.tertiary,
      icon: Icons.fitness_center,
      completedDates: {},
    ),
  ];

  List<Habit> get habits => List.unmodifiable(_habits);

  List<Habit> get activeHabits => _habits.toList(); // Simplification

  void toggleHabitCompletion(String habitId, DateTime date) {
    final habit = _habits.firstWhere((h) => h.id == habitId);
    habit.toggleCompletion(date);
    notifyListeners();
  }

  void addHabit(Habit habit) {
    _habits.add(habit);
    notifyListeners();
  }

  Habit getHabit(String id) {
    return _habits.firstWhere((h) => h.id == id);
  }

  int get globalStreak {
    // A simple global streak calculation:
    // User has a streak if at least one habit was completed each day.
    int streak = 0;
    DateTime date = Habit.normalizeDate(DateTime.now());
    
    bool completedAnyOn(DateTime d) => _habits.any((h) => h.isCompletedOn(d));

    if (!completedAnyOn(date)) {
      date = date.subtract(const Duration(days: 1));
      if (!completedAnyOn(date)) return 0;
    }

    while (completedAnyOn(date)) {
      streak++;
      date = date.subtract(const Duration(days: 1));
    }
    return streak;
  }

  double get weeklyCompletionRate {
    // 7 days lookback
    int totalExpected = _habits.length * 7;
    int totalCompleted = 0;
    final today = Habit.normalizeDate(DateTime.now());

    for (int i = 0; i < 7; i++) {
      final date = today.subtract(Duration(days: i));
      for (final h in _habits) {
        if (h.isCompletedOn(date)) totalCompleted++;
      }
    }

    if (totalExpected == 0) return 0;
    return totalCompleted / totalExpected;
  }

  Map<int, double> get weeklyTrend {
    // Returns completion rate per day of the week (0 = 7 days ago, 6 = today)
    Map<int, double> trend = {};
    final today = Habit.normalizeDate(DateTime.now());
    for (int i = 0; i < 7; i++) {
      final date = today.subtract(Duration(days: 6 - i));
      int completed = _habits.where((h) => h.isCompletedOn(date)).length;
      trend[i] = _habits.isEmpty ? 0 : completed / _habits.length;
    }
    return trend;
  }

  double get categoryFocusRate(String category) {
    int totalCompleted = 0;
    int totalCategoryCompleted = 0;
    
    for (var h in _habits) {
      totalCompleted += h.completedDates.length;
      if (h.category == category) {
        totalCategoryCompleted += h.completedDates.length;
      }
    }
    if (totalCompleted == 0) return 0;
    return totalCategoryCompleted / totalCompleted;
  }
}
