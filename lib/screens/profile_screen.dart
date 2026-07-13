import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final weeklyCompletionRate = provider.weeklyCompletionRate;
    
    return Scaffold(
      backgroundColor: HabitFlowColors.background,
      extendBody: true,
      body: Stack(
        children: [
          // Ambient gradients
          Positioned(
            top: -MediaQuery.of(context).size.height * 0.1,
            left: -MediaQuery.of(context).size.width * 0.1,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    HabitFlowColors.primaryFixed.withValues(alpha: 0.4),
                    HabitFlowColors.tertiaryFixed.withValues(alpha: 0.2),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -MediaQuery.of(context).size.height * 0.1,
            right: -MediaQuery.of(context).size.width * 0.1,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    HabitFlowColors.secondaryFixed.withValues(alpha: 0.3),
                    HabitFlowColors.surfaceTint.withValues(alpha: 0.1),
                  ],
                ),
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
                  child: const Row(
                    children: [
                      Text(
                        'HabitFlow',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: HabitFlowColors.primary,
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
                  // Profile Card
                  GlassCard(
                    borderRadius: 24,
                    opacity: 0.25,
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        // Avatar
                        Stack(
                          children: [
                            Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: HabitFlowColors.primaryContainer,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: HabitFlowColors.primary
                                        .withValues(alpha: 0.2),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  'AR',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: HabitFlowColors.primary,
                                  border: Border.all(
                                      color: Colors.white, width: 2),
                                ),
                                child: const Icon(Icons.edit,
                                    color: Colors.white, size: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Alex Rivers',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: HabitFlowColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Level badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: HabitFlowColors.primaryFixed
                                .withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(9999),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.5)),
                          ),
                          child: const Text(
                            'Habit Master • Level 12',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: HabitFlowColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Focused on building a healthy morning routine and staying hydrated.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: HabitFlowColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: GradientButton(
                            label: 'Share Profile',
                            icon: Icons.share,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Profile link copied to clipboard!'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Stats bento
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.local_fire_department,
                          iconColor: HabitFlowColors.primary,
                          value: '${provider.globalStreak}',
                          label: 'Day Streak',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.task_alt,
                          iconColor: HabitFlowColors.tertiary,
                          value: '${provider.activeHabits.length}',
                          label: 'Active Habits',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Completion rate
                  GlassCard(
                    opacity: 0.25,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Weekly Completion Rate',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: HabitFlowColors.onSurfaceVariant,
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
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.5)),
                            ),
                            child: FractionallySizedBox(
                              widthFactor: weeklyCompletionRate.clamp(0.0, 1.0),
                              alignment: Alignment.centerLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      HabitFlowColors.tertiary,
                                      HabitFlowColors.primary,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: HabitFlowColors.primary
                                          .withValues(alpha: 0.5),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Account Settings
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.only(left: 8),
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(
                              color: HabitFlowColors.primary, width: 4),
                        ),
                      ),
                      child: const Text(
                        'Account Settings',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: HabitFlowColors.onSurface,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Preferences group
                  _SettingsGroup(
                    title: 'PREFERENCES',
                    items: [
                      _SettingItem(
                        icon: Icons.palette,
                        title: 'Appearance',
                        subtitle: 'System default (Light)',
                        hasToggle: true,
                      ),
                      _SettingItem(
                        icon: Icons.language,
                        title: 'Language',
                        subtitle: 'English (US)',
                        hasChevron: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SettingsGroup(
                    title: 'NOTIFICATIONS & SYNC',
                    items: [
                      _SettingItem(
                        icon: Icons.notifications_active,
                        title: 'Daily Reminders',
                        subtitle: 'Push notifications for habits',
                        hasToggle: true,
                      ),
                      _SettingItem(
                        icon: Icons.sync,
                        title: 'Cloud Sync',
                        subtitle: 'Last synced: Just now',
                        trailing: const Icon(Icons.cloud_done,
                            color: HabitFlowColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SettingsGroup(
                    title: 'DATA & PRIVACY',
                    items: [
                      _SettingItem(
                        icon: Icons.download,
                        title: 'Export Data',
                        subtitle: 'Download your habit history as CSV',
                        hasChevron: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Log out
                  TextButton.icon(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false),
                    icon: const Icon(Icons.logout,
                        color: HabitFlowColors.error, size: 20),
                    label: const Text(
                      'Log out',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: HabitFlowColors.error,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
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

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      opacity: 0.25,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withValues(alpha: 0.1),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: HabitFlowColors.onSurface,
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

class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<_SettingItem> items;

  const _SettingsGroup({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      opacity: 0.25,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: HabitFlowColors.primary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          ...items.asMap().entries.map((entry) {
            final isLast = entry.key == items.length - 1;
            return Column(
              children: [
                entry.value,
                if (!isLast)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _SettingItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool hasToggle;
  final bool hasChevron;
  final Widget? trailing;

  const _SettingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.hasToggle = false,
    this.hasChevron = false,
    this.trailing,
  });

  @override
  State<_SettingItem> createState() => _SettingItemState();
}

class _SettingItemState extends State<_SettingItem> {
  bool _toggled = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: HabitFlowColors.surfaceVariant.withValues(alpha: 0.5),
              border:
                  Border.all(color: Colors.white.withValues(alpha: 0.4)),
            ),
            child: Icon(widget.icon,
                color: HabitFlowColors.onSurfaceVariant, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: HabitFlowColors.onSurface,
                  ),
                ),
                Text(
                  widget.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: HabitFlowColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (widget.hasToggle)
            Switch(
              value: _toggled,
              onChanged: (v) => setState(() => _toggled = v),
              activeColor: HabitFlowColors.primaryContainer,
              activeTrackColor:
                  HabitFlowColors.primaryContainer.withValues(alpha: 0.5),
            ),
          if (widget.hasChevron)
            const Icon(Icons.chevron_right,
                color: HabitFlowColors.onSurfaceVariant),
          if (widget.trailing != null) widget.trailing!,
        ],
      ),
    );
  }
}
