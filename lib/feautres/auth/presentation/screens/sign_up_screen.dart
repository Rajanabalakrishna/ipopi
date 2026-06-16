
import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// Make sure this path matches your actual project structure
import '../../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_state.dart';
import 'login_screen.dart';

// AFTER
class SignupScreen extends ConsumerStatefulWidget {  // ← ConsumerStatefulWidget
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState(); // ← ConsumerState return type
}

class _SignupScreenState extends ConsumerState<SignupScreen>  // ← ConsumerState
    with SingleTickerProviderStateMixin {  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _agreeToTerms = false;
  bool _isLoading = false;
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    // Properly initialize the shimmer controller for the GlassCard effect
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

// REMOVE _isLoading bool field at top — delete this line:
// bool _isLoading = false;

Future<void> _register() async {
  final isValid = _formKey.currentState?.validate() ?? false;
  if (!isValid) return;

  if (!_agreeToTerms) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please accept Terms of Service and Privacy Policy')),
    );
    return;
  }

  await ref.read(authNotifierProvider.notifier).signUp(
    _emailController.text.trim(),
    _passwordController.text,
    _fullNameController.text.trim(), // ← pass fullName
  );
}

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 3) {
      return 'Enter a valid full name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Minimum 8 characters required';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {

    ref.listen<AuthState>(authNotifierProvider, (_, next) {
      if (next is AuthAuthenticated) {
        // ✅ Show success snackbar first
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully! Please log in.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        // ✅ Navigate to LoginScreen after short delay
        Future.delayed(const Duration(seconds: 2), () {
          if (!context.mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        });
      } else if (next is AuthError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.message)));
        ref.read(authNotifierProvider.notifier).resetState();
      }
    });

    // ← Drive loading from state, not local bool
    final isLoading = ref.watch(authNotifierProvider) is AuthLoading;

    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.textTheme;
    final bool isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final bool isDesktop = size.width >= 1024;
    final bool isTablet = size.width >= 700;

    return Scaffold(
      body: Stack(
        children: [
          _BackgroundLayer(isDark: isDark),
          SafeArea(
            child: Column(
              children: [
                _TopBar(isDark: isDark),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop
                            ? 40
                            : isTablet
                            ? 28
                            : 20,
                        vertical: 24,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 460),
                        child: MouseRegion(
                          onHover: (_) {},
                          child: _GlassCard(
                            isDark: isDark,
                            shimmerController: _shimmerController,
                            child: Padding(
                              padding: EdgeInsets.all(isTablet ? 28 : 24),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Create Account',
                                      textAlign: TextAlign.center,
                                      style: isTablet
                                          ? text.headlineLarge?.copyWith(
                                        color: isDark
                                            ? colors.onSurface
                                            : Colors.blue, // Fallback if AppTheme fails
                                      )
                                          : text.headlineMedium?.copyWith(
                                        color: isDark
                                            ? colors.onSurface
                                            : Colors.blue,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      isDark
                                          ? 'Experience the future of digital craftsmanship.'
                                          : 'Start your journey with ipopi Systems',
                                      textAlign: TextAlign.center,
                                      style: text.bodyMedium?.copyWith(
                                        color: colors.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                    _SectionLabel(text: 'Full Name', isDark: isDark),
                                    const SizedBox(height: 6),
                                    _InputField(
                                      controller: _fullNameController,
                                      hintText: 'Enter your full name',
                                      prefixIcon: Icons.person_outline_rounded,
                                      validator: _validateName,
                                      keyboardType: TextInputType.name,
                                      textInputAction: TextInputAction.next,
                                    ),
                                    const SizedBox(height: 16),
                                    _SectionLabel(
                                      text: 'Email Address',
                                      isDark: isDark,
                                    ),
                                    const SizedBox(height: 6),
                                    _InputField(
                                      controller: _emailController,
                                      hintText: 'name@company.com',
                                      prefixIcon: Icons.mail_outline_rounded,
                                      validator: _validateEmail,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                    ),
                                    const SizedBox(height: 16),
                                    _SectionLabel(text: 'Password', isDark: isDark),
                                    const SizedBox(height: 6),
                                    _InputField(
                                      controller: _passwordController,
                                      hintText: '••••••••',
                                      prefixIcon: Icons.lock_outline_rounded,
                                      validator: _validatePassword,
                                      obscureText: _hidePassword,
                                      textInputAction: TextInputAction.next,
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _hidePassword = !_hidePassword;
                                          });
                                        },
                                        icon: Icon(
                                          _hidePassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _SectionLabel(
                                      text: 'Confirm Password',
                                      isDark: isDark,
                                    ),
                                    const SizedBox(height: 6),
                                    _InputField(
                                      controller: _confirmPasswordController,
                                      hintText: '••••••••',
                                      prefixIcon: Icons.verified_user_outlined,
                                      validator: _validateConfirmPassword,
                                      obscureText: _hideConfirmPassword,
                                      textInputAction: TextInputAction.done,
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _hideConfirmPassword =
                                            !_hideConfirmPassword;
                                          });
                                        },
                                        icon: Icon(
                                          _hideConfirmPassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 2),
                                          child: Checkbox(
                                            value: _agreeToTerms,
                                            onChanged: (value) {
                                              setState(() {
                                                _agreeToTerms = value ?? false;
                                              });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 6),
                                            child: RichText(
                                              text: TextSpan(
                                                style: text.bodySmall?.copyWith(
                                                  color: colors.onSurfaceVariant,
                                                ),
                                                children: [
                                                  const TextSpan(
                                                    text: 'I agree to the ',
                                                  ),
                                                  TextSpan(
                                                    text: 'Terms of Service',
                                                    style: text.bodySmall?.copyWith(
                                                      color: colors.primary,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                    recognizer: TapGestureRecognizer()
                                                      ..onTap = () {},
                                                  ),
                                                  const TextSpan(
                                                    text: ' and ',
                                                  ),
                                                  TextSpan(
                                                    text: 'Privacy Policy',
                                                    style: text.bodySmall?.copyWith(
                                                      color: colors.primary,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                    recognizer: TapGestureRecognizer()
                                                      ..onTap = () {},
                                                  ),
                                                  const TextSpan(text: '.'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    _RegisterButton(
                                      isDark: isDark,
                                      isLoading: isLoading,
                                      onTap: _register,
                                    ),
                                    const SizedBox(height: 28),
                                    Center(
                                      child: RichText(
                                        text: TextSpan(
                                          style: text.bodyMedium?.copyWith(
                                            color: colors.onSurfaceVariant,
                                          ),
                                          children: [
                                            const TextSpan(
                                              text: 'Already have an account? ',
                                            ),
                                            TextSpan(
                                              text: 'Log In',
                                              style: text.bodyMedium?.copyWith(
                                                color: colors.primary,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => const LoginScreen(),
                                                    ),
                                                  );
                                                },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 40 : 20,
                    vertical: 20,
                  ),
                  child: size.width >= 700
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '© 2026 ipopi Systems. All rights reserved.',
                        style: text.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      Wrap(
                        spacing: 24,
                        children: const [
                          _FooterLink(title: 'Privacy Policy'),
                          _FooterLink(title: 'Terms of Service'),
                          _FooterLink(title: 'Cookie Policy'),
                        ],
                      ),
                    ],
                  )
                      : Column(
                    children: [
                      Text(
                        '© 2024 Lumina Systems. All rights reserved.',
                        textAlign: TextAlign.center,
                        style: text.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16,
                        runSpacing: 8,
                        children: const [
                          _FooterLink(title: 'Privacy Policy'),
                          _FooterLink(title: 'Terms of Service'),
                          _FooterLink(title: 'Cookie Policy'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final width = MediaQuery.of(context).size.width;
    final bool showDesktopLinks = width >= 900;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: width >= 900 ? 40 : 20,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.transparent,
        border: isDark
            ? Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.10),
          ),
        )
            : null,
      ),
      child: Row(
        children: [
          Row(
            children: [
              Icon(
                isDark
                    ? Icons.auto_awesome_rounded
                    : Icons.bubble_chart_rounded,
                color: colors.primary,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                'ipopi Notes',
                style: text.headlineMedium?.copyWith(
                  color: isDark ? colors.onSurface : colors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (showDesktopLinks) ...[
            const _HeaderLink(title: 'Product'),
            const SizedBox(width: 24),
            const _HeaderLink(title: 'Enterprise'),
            const SizedBox(width: 24),
            const _HeaderLink(title: 'Pricing'),
            const SizedBox(width: 24),
            const _HeaderLink(title: 'Log In'),
            const SizedBox(width: 16),
            _TopActionButton(isDark: isDark),
          ],
        ],
      ),
    );
  }
}

class _TopActionButton extends StatelessWidget {
  const _TopActionButton({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (isDark) {
      return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF545D7C),
              Color(0xFFBDC5E9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFBDC5E9).withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: colors.onPrimary,
            minimumSize: const Size(0, 42),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: Text(
            'Get Started',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: colors.onPrimary,
            ),
          ),
        ),
      );
    }

    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, 42),
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      child: Text(
        'Get Started',
        style: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: colors.onPrimary,
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({
    required this.child,
    required this.isDark,
    required this.shimmerController,
  });

  final Widget child;
  final bool isDark;
  final AnimationController shimmerController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: shimmerController,
      builder: (context, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.white.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.10)
                        : Colors.white.withOpacity(0.80),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.5)
                          : const Color(0xFF1F2687).withOpacity(0.04),
                      blurRadius: isDark ? 50 : 32,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: child,
              ),
              if (!isDark)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Transform.rotate(
                      angle: math.pi / 4,
                      child: Transform.translate(
                        offset: Offset(
                          (shimmerController.value * 600) - 300,
                          0,
                        ),
                        child: Container(
                          width: 120,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.white.withOpacity(0.22),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (isDark)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.white.withOpacity(0.40),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _BackgroundLayer extends StatelessWidget {
  const _BackgroundLayer({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          Container(
            color: isDark
                ? const Color(0xFF131315)
                : const Color(0xFFF8F9FF),
          ),
          if (!isDark) ...[
            const _RadialBlob(
              alignment: Alignment.topLeft,
              color: Color.fromRGBO(210, 228, 255, 0.50),
              size: 380,
            ),
            const _RadialBlob(
              alignment: Alignment.topRight,
              color: Color.fromRGBO(229, 238, 255, 0.40),
              size: 360,
            ),
            const _RadialBlob(
              alignment: Alignment.bottomRight,
              color: Color.fromRGBO(239, 244, 255, 0.60),
              size: 360,
            ),
            const _RadialBlob(
              alignment: Alignment.bottomLeft,
              color: Color.fromRGBO(211, 228, 254, 0.50),
              size: 360,
            ),
          ] else ...[
            const _RadialBlob(
              alignment: Alignment.topLeft,
              color: Color.fromRGBO(31, 37, 65, 0.90),
              size: 400,
            ),
            const _RadialBlob(
              alignment: Alignment.topCenter,
              color: Color.fromRGBO(20, 26, 50, 0.70),
              size: 360,
            ),
            const _RadialBlob(
              alignment: Alignment.bottomRight,
              color: Color.fromRGBO(31, 37, 61, 0.70),
              size: 400,
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.22,
              left: -100,
              child: _GlowOrb(
                color: const Color(0xFFBDC5E9).withOpacity(0.10),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.18,
              right: -100,
              child: _GlowOrb(
                color: const Color(0xFFBFC5E4).withOpacity(0.10),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 120,
            spreadRadius: 40,
          ),
        ],
      ),
    );
  }
}

class _RadialBlob extends StatelessWidget {
  const _RadialBlob({
    required this.alignment,
    required this.color,
    required this.size,
  });

  final Alignment alignment;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, Colors.transparent],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.text,
    required this.isDark,
  });

  final String text;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.28,
          // Removed the direct AppTheme call here to prevent compiling errors if you don't have it imported correctly everywhere, using primary color instead.
          color: colorScheme.primary,
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton({
    required this.isDark,
    required this.isLoading,
    required this.onTap,
  });

  final bool isDark;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (isDark) {
      return Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF545D7C),
              Color(0xFFBDC5E9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFBDC5E9).withOpacity(0.20),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: colors.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isLoading
              ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              valueColor: AlwaysStoppedAnimation<Color>(
                colors.onPrimary,
              ),
            ),
          )
              : Text(
            'Register',
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colors.onPrimary,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        child: isLoading
            ? SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.4,
            valueColor: AlwaysStoppedAnimation<Color>(
              colors.onPrimary,
            ),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Register',
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colors.onPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_rounded,
              color: colors.onPrimary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderLink extends StatelessWidget {
  const _HeaderLink({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Text(
          title,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.6,
            color: colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Text(
          title,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.6,
            color: colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

