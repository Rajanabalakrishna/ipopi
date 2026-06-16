

import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? const RadialGradient(
          center: Alignment(-0.6, -0.8),
          radius: 1.4,
          colors: [
            Color(0xFF1C2541),
            Color(0xFF131315),
            Color(0xFF0E0E10),
          ],
        )
            : const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFEFF4FF),
            Color(0xFFF8F9FF),
            Color(0xFFD3E4FE),
          ],
        ),
      ),
      child: child,
    );
  }
}