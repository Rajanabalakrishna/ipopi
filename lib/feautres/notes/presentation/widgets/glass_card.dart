

import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.padding,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: width,
          height: height,
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            // Shimmer effect: gradient that works on both themes
            gradient: isDark
                ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.10),
                Colors.white.withOpacity(0.04),
                Colors.blue.withOpacity(0.05),
              ],
            )
                : LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.75),
                Colors.white.withOpacity(0.45),
                const Color(0xFFD3E4FE).withOpacity(0.35),
              ],
            ),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.12)
                  : Colors.white.withOpacity(0.8),
              width: 1.2,
            ),
            boxShadow: isDark
                ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 20,
                spreadRadius: -4,
              ),
              BoxShadow(
                color: const Color(0xFFBDC5E9).withOpacity(0.04),
                blurRadius: 40,
                spreadRadius: 0,
              ),
            ]
                : [
              BoxShadow(
                color: const Color(0xFF1F2687).withOpacity(0.08),
                blurRadius: 20,
                spreadRadius: -4,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.6),
                blurRadius: 4,
                spreadRadius: 0,
                offset: const Offset(-1, -1),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}