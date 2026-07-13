import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true;

  void _toggleView() {
    setState(() => _isLogin = !_isLogin);
  }

  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: HabitFlowColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: HabitFlowColors.surface,
        ),
        child: Stack(
          children: [
            // Ambient mesh background
            Positioned(
              top: -MediaQuery.of(context).size.height * 0.1,
              left: -MediaQuery.of(context).size.width * 0.1,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: HabitFlowColors.primaryFixed.withValues(alpha: 0.5),
                ),
              ),
            ),
            Positioned(
              bottom: -MediaQuery.of(context).size.height * 0.1,
              right: -MediaQuery.of(context).size.width * 0.1,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: HabitFlowColors.tertiaryFixed.withValues(alpha: 0.3),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: MediaQuery.of(context).size.width * 0.2,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: HabitFlowColors.secondaryFixed.withValues(alpha: 0.3),
                ),
              ),
            ),
            // Main content
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // Brand anchor
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                HabitFlowColors.primary,
                                HabitFlowColors.tertiary,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: HabitFlowColors.primary
                                    .withValues(alpha: 0.2),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.layers,
                              color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'HabitFlow',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: HabitFlowColors.primary,
                            letterSpacing: -0.02 * 24,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.08),
                    // Auth card
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: _isLogin
                          ? _LoginView(
                              key: const ValueKey('login'),
                              onToggle: _toggleView,
                              onError: (msg) => _showError(context, msg),
                            )
                          : _SignUpView(
                              key: const ValueKey('signup'),
                              onToggle: _toggleView,
                              onError: (msg) => _showError(context, msg),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginView extends StatefulWidget {
  final VoidCallback onToggle;
  final void Function(String) onError;

  const _LoginView({super.key, required this.onToggle, required this.onError});

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_emailController.text.trim().isEmpty) {
      widget.onError('Please enter your email.');
      return;
    }
    if (_passwordController.text.isEmpty) {
      widget.onError('Please enter your password.');
      return;
    }
    Navigator.pushReplacementNamed(context, '/main');
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
            boxShadow: [
              BoxShadow(
                color: HabitFlowColors.primary.withValues(alpha: 0.08),
                blurRadius: 32,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'Welcome back',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: HabitFlowColors.onSurface,
                  height: 34 / 28,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Continue your journey to better habits.',
                style: TextStyle(
                  fontSize: 16,
                  color: HabitFlowColors.onSurfaceVariant,
                  height: 24 / 16,
                ),
              ),
              const SizedBox(height: 24),
              _GlassInput(
                label: 'Email Address',
                icon: Icons.email_outlined,
                hint: 'name@example.com',
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              const SizedBox(height: 16),
              _GlassInput(
                label: 'Password',
                icon: Icons.lock_outlined,
                hint: '••••••••',
                obscure: true,
                controller: _passwordController,
                trailing: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: HabitFlowColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  label: 'Login',
                  onPressed: _submit,
                ),
              ),
              const SizedBox(height: 20),
              // Divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: HabitFlowColors.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR CONTINUE WITH',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: HabitFlowColors.onSurfaceVariant,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: HabitFlowColors.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Social buttons
              Row(
                children: [
                  Expanded(child: _SocialButton(label: 'Google', icon: Icons.g_mobiledata_rounded)),
                  const SizedBox(width: 16),
                  Expanded(child: _SocialButton(label: 'Apple', icon: Icons.apple)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      fontSize: 16,
                      color: HabitFlowColors.onSurfaceVariant,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onToggle,
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: HabitFlowColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignUpView extends StatefulWidget {
  final VoidCallback onToggle;
  final void Function(String) onError;

  const _SignUpView({super.key, required this.onToggle, required this.onError});

  @override
  State<_SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<_SignUpView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameController.text.trim().isEmpty) {
      widget.onError('Please enter your name.');
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      widget.onError('Please enter your email.');
      return;
    }
    if (_passwordController.text.isEmpty) {
      widget.onError('Please create a password.');
      return;
    }
    if (_passwordController.text != _confirmController.text) {
      widget.onError('Passwords do not match.');
      return;
    }
    Navigator.pushReplacementNamed(context, '/main');
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
            boxShadow: [
              BoxShadow(
                color: HabitFlowColors.primary.withValues(alpha: 0.08),
                blurRadius: 32,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'Create an account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: HabitFlowColors.onSurface,
                  height: 34 / 28,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Start building better routines today.',
                style: TextStyle(
                  fontSize: 16,
                  color: HabitFlowColors.onSurfaceVariant,
                  height: 24 / 16,
                ),
              ),
              const SizedBox(height: 20),
              _GlassInput(
                label: 'Full Name',
                icon: Icons.person_outline,
                hint: 'Alex Rivers',
                controller: _nameController,
              ),
              const SizedBox(height: 12),
              _GlassInput(
                label: 'Email Address',
                icon: Icons.email_outlined,
                hint: 'name@example.com',
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              const SizedBox(height: 12),
              _GlassInput(
                label: 'Password',
                icon: Icons.lock_outlined,
                hint: 'Create a password',
                obscure: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 12),
              _GlassInput(
                label: 'Confirm Password',
                icon: Icons.verified_user_outlined,
                hint: 'Repeat password',
                obscure: true,
                controller: _confirmController,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  label: 'Create Account',
                  onPressed: _submit,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontSize: 16,
                      color: HabitFlowColors.onSurfaceVariant,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onToggle,
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: HabitFlowColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassInput extends StatelessWidget {
  final String label;
  final IconData icon;
  final String hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? trailing;
  final TextEditingController? controller;

  const _GlassInput({
    required this.label,
    required this.icon,
    required this.hint,
    this.obscure = false,
    this.keyboardType,
    this.trailing,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: HabitFlowColors.onSurface,
                  letterSpacing: 0.01 * 14,
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontSize: 16,
              color: HabitFlowColors.onSurface,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: HabitFlowColors.outlineVariant,
                fontSize: 16,
              ),
              prefixIcon: Icon(icon,
                  color: HabitFlowColors.outlineVariant, size: 22),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;

  const _SocialButton({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: HabitFlowColors.onSurface),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: HabitFlowColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
