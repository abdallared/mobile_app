import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_theme.dart';

class HabitBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const HabitBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 72 + MediaQuery.of(context).padding.bottom,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            border: Border(
              top: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
            ),
            boxShadow: [
              BoxShadow(
                color: HabitFlowColors.primary.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTab(Icons.home_rounded, 'Home', 0),
              _buildTab(Icons.notifications_rounded, 'Alerts', 1),
              _buildTab(Icons.leaderboard_rounded, 'Stats', 2),
              _buildTab(Icons.person_rounded, 'Profile', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(IconData icon, String label, int index) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive
                  ? HabitFlowColors.primary
                  : HabitFlowColors.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w600,
                color: isActive
                    ? HabitFlowColors.primary
                    : HabitFlowColors.onSurfaceVariant.withValues(alpha: 0.7),
                height: 16 / 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
