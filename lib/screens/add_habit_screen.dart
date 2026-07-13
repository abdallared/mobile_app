import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  int _selectedCategory = 0;
  int _selectedColor = 0;
  int _selectedFrequency = 0;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 8, minute: 0);
  final _nameController = TextEditingController();

  final List<_Category> _categories = [
    _Category(Icons.favorite, 'Health'),
    _Category(Icons.fitness_center, 'Fitness'),
    _Category(Icons.self_improvement, 'Mind'),
    _Category(Icons.local_library, 'Learning'),
    _Category(Icons.work, 'Career'),
  ];

  final List<Color> _colors = [
    HabitFlowColors.primary,
    HabitFlowColors.secondary,
    HabitFlowColors.tertiary,
    HabitFlowColors.green,
    HabitFlowColors.amber,
    HabitFlowColors.red,
  ];

  final List<String> _frequencies = ['Daily', 'Weekly', 'Custom'];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveHabit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a habit name.'),
          backgroundColor: HabitFlowColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final cat = _categories[_selectedCategory];
    final color = _colors[_selectedColor];
    final habit = Habit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: name,
      category: cat.label,
      color: color,
      icon: cat.icon,
    );
    context.read<HabitProvider>().addHabit(habit);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HabitFlowColors.surface,
      body: Stack(
        children: [
          // Ambient backgrounds
          Positioned(
            top: -MediaQuery.of(context).size.height * 0.2,
            left: -MediaQuery.of(context).size.width * 0.1,
            child: Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: HabitFlowColors.primary.withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -MediaQuery.of(context).size.height * 0.2,
            right: -MediaQuery.of(context).size.width * 0.1,
            child: Container(
              width: 800,
              height: 800,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: HabitFlowColors.secondary.withValues(alpha: 0.1),
              ),
            ),
          ),
          // Glass Card overlay
          SafeArea(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(32),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.6)),
                    boxShadow: [
                      BoxShadow(
                        color: HabitFlowColors.primary.withValues(alpha: 0.15),
                        blurRadius: 64,
                        offset: const Offset(0, 32),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 24),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: Colors.white.withValues(alpha: 0.3)),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.add_task,
                                    color: HabitFlowColors.primary, size: 28),
                                const SizedBox(width: 8),
                                const Text(
                                  'New Habit',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color: HabitFlowColors.onSurface,
                                    height: 34 / 28,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color:
                                          Colors.white.withValues(alpha: 0.4)),
                                ),
                                child: const Icon(Icons.close,
                                    color: HabitFlowColors.onSurfaceVariant),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Form area
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Habit Name
                              _SectionLabel('Habit Name'),
                              const SizedBox(height: 8),
                              Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color:
                                          Colors.white.withValues(alpha: 0.6)),
                                ),
                                child: TextField(
                                  controller: _nameController,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: HabitFlowColors.onSurface,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'e.g., Morning Meditation',
                                    hintStyle: TextStyle(
                                      color: HabitFlowColors.outline,
                                      fontSize: 18,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              // Category
                              _SectionLabel('Category'),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: List.generate(
                                    _categories.length, (index) {
                                  final cat = _categories[index];
                                  final isSelected =
                                      _selectedCategory == index;
                                  return GestureDetector(
                                    onTap: () =>
                                        setState(() =>
                                            _selectedCategory = index),
                                    child: Container(
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? HabitFlowColors.primaryContainer
                                            : Colors.white
                                                .withValues(alpha: 0.5),
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? HabitFlowColors
                                                  .primaryContainer
                                              : Colors.white.withValues(
                                                  alpha: 0.6),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(cat.icon,
                                              size: 18,
                                              color: isSelected
                                                  ? Colors.white
                                                  : HabitFlowColors
                                                      .onSurfaceVariant),
                                          const SizedBox(width: 8),
                                          Text(
                                            cat.label,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: isSelected
                                                  ? Colors.white
                                                  : HabitFlowColors
                                                      .onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 32),
                              // Color Theme
                              _SectionLabel('Color Theme'),
                              const SizedBox(height: 8),
                              Row(
                                children: List.generate(
                                    _colors.length, (index) {
                                  final isSelected =
                                      _selectedColor == index;
                                  return GestureDetector(
                                    onTap: () => setState(
                                        () => _selectedColor = index),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      margin:
                                          const EdgeInsets.only(right: 16),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _colors[index],
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.transparent,
                                          width: 2,
                                        ),
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: _colors[index]
                                                      .withValues(alpha: 0.5),
                                                  blurRadius: 8,
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: isSelected
                                          ? const Icon(Icons.check,
                                              color: Colors.white, size: 20)
                                          : null,
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 32),
                              // Frequency
                              _SectionLabel('Frequency'),
                              const SizedBox(height: 8),
                              Container(
                                height: 48,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color:
                                          Colors.white.withValues(alpha: 0.6)),
                                ),
                                child: Row(
                                  children: List.generate(
                                      _frequencies.length, (index) {
                                    final isSelected =
                                        _selectedFrequency == index;
                                    return Expanded(
                                      child: GestureDetector(
                                        onTap: () => setState(() =>
                                            _selectedFrequency = index),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: isSelected
                                                ? [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withValues(
                                                              alpha: 0.05),
                                                      blurRadius: 4,
                                                    ),
                                                  ]
                                                : null,
                                          ),
                                          child: Center(
                                            child: Text(
                                              _frequencies[index],
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: isSelected
                                                    ? HabitFlowColors.primary
                                                    : HabitFlowColors
                                                        .onSurfaceVariant,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              const SizedBox(height: 32),
                              // Reminder Time
                              _SectionLabel('Reminder Time'),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () async {
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime: _reminderTime,
                                  );
                                  if (picked != null) {
                                    setState(() => _reminderTime = picked);
                                  }
                                },
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color:
                                            Colors.white.withValues(alpha: 0.6)),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 16),
                                      const Icon(
                                          Icons.notifications_active_outlined,
                                          color: HabitFlowColors.outline),
                                      const SizedBox(width: 12),
                                      Text(
                                        _reminderTime.format(context),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: HabitFlowColors.onSurface,
                                        ),
                                      ),
                                      const Spacer(),
                                      const Padding(
                                        padding: EdgeInsets.only(right: 16),
                                        child: Icon(Icons.edit_outlined,
                                            size: 18,
                                            color: HabitFlowColors.onSurfaceVariant),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Save button
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          border: Border(
                            top: BorderSide(
                                color: Colors.white.withValues(alpha: 0.4)),
                          ),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: GradientButton(
                            label: 'Save Habit',
                            icon: Icons.arrow_forward,
                            onPressed: _saveHabit,
                          ),
                        ),
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

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: HabitFlowColors.onSurfaceVariant,
          letterSpacing: 0.01 * 14,
          height: 20 / 14,
        ),
      ),
    );
  }
}

class _Category {
  final IconData icon;
  final String label;
  const _Category(this.icon, this.label);
}
