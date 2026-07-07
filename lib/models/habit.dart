import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String title;
  final String category;
  final Color color;
  final IconData icon;
  final Set<DateTime> completedDates;

  Habit({
    required this.id,
    required this.title,
    required this.category,
    required this.color,
    required this.icon,
    Set<DateTime>? completedDates,
  }) : completedDates = completedDates ?? {};

  /// Normalizes a date to midnight for consistent checking
  static DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool isCompletedOn(DateTime date) {
    return completedDates.contains(normalizeDate(date));
  }

  void toggleCompletion(DateTime date) {
    final normalized = normalizeDate(date);
    if (completedDates.contains(normalized)) {
      completedDates.remove(normalized);
    } else {
      completedDates.add(normalized);
    }
  }

  int get currentStreak {
    int streak = 0;
    DateTime date = normalizeDate(DateTime.now());
    
    // If not completed today, check if it was completed yesterday.
    // If neither, streak is 0.
    if (!isCompletedOn(date)) {
      date = date.subtract(const Duration(days: 1));
      if (!isCompletedOn(date)) return 0;
    }

    while (isCompletedOn(date)) {
      streak++;
      date = date.subtract(const Duration(days: 1));
    }
    return streak;
  }

  int get longestStreak {
    if (completedDates.isEmpty) return 0;
    
    List<DateTime> sortedDates = completedDates.toList()..sort();
    int longest = 0;
    int current = 1;

    for (int i = 1; i < sortedDates.length; i++) {
      if (sortedDates[i].difference(sortedDates[i - 1]).inDays == 1) {
        current++;
      } else {
        if (current > longest) longest = current;
        current = 1;
      }
    }
    if (current > longest) longest = current;
    return longest;
  }
}
