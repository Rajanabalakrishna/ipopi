

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ipopi/feautres/auth/domain/entities/user_entity.dart';
import 'package:ipopi/feautres/notes/domain/entities/note_entity.dart';

class NoteDetailsScreen extends StatelessWidget {
  final UserEntity user;
  final NoteEntity note;
  final VoidCallback onEdit;

  const NoteDetailsScreen({
    super.key,
    required this.user,
    required this.note,
    required this.onEdit,
  });

  String _formatDate(DateTime date) {
    final hour =
    date.hour > 12 ? date.hour - 12 : date.hour == 0 ? 12 : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final amPm = date.hour >= 12 ? 'PM' : 'AM';
    return '${date.day}/${date.month}/${date.year} • $hour:$minute $amPm';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF0B1220) : const Color(0xFFF8F9FF),
      body: Stack(
        children: [
          const _LuminaDetailsBackground(),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.08)
                              : Colors.white.withOpacity(0.40),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withOpacity(0.10)
                                : Colors.white.withOpacity(0.65),
                          ),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back_ios_new_rounded),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Note Details',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                    theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    user.displayName?.trim().isNotEmpty == true
                                        ? user.displayName!
                                        : (user.email ?? ''),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.58),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FilledButton.icon(
                              onPressed: onEdit,
                              icon: const Icon(Icons.edit_rounded),
                              label: const Text('Edit'),
                              style: FilledButton.styleFrom(
                                backgroundColor: isDark
                                    ? const Color(0xFF324863)
                                    : const Color(0xFF3A506B),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withOpacity(0.06)
                                : Colors.white.withOpacity(0.55),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withOpacity(0.10)
                                  : Colors.white.withOpacity(0.75),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black.withOpacity(0.18)
                                    : const Color(0xFF3A506B).withOpacity(0.08),
                                blurRadius: 30,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  _InfoChip(
                                    icon: Icons.description_rounded,
                                    label: 'Professional View',
                                    isDark: isDark,
                                  ),
                                  _InfoChip(
                                    icon: Icons.update_rounded,
                                    label: _formatDate(note.updatedAt),
                                    isDark: isDark,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Text(
                                note.title,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Container(
                                width: 72,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.75),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                note.content,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  height: 1.8,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.78),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.08)
            : const Color(0xFFE8F0FF).withOpacity(0.95),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.10)
              : Colors.white.withOpacity(0.85),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _LuminaDetailsBackground extends StatelessWidget {
  const _LuminaDetailsBackground();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? const [
                Color(0xFF0B1220),
                Color(0xFF101A2D),
                Color(0xFF0E1626),
              ]
                  : const [
                Color(0xFFF8F9FF),
                Color(0xFFF2F6FF),
                Color(0xFFEFF4FF),
              ],
            ),
          ),
        ),
        Positioned(
          top: -100,
          right: -70,
          child: _blurBlob(
            color: const Color(0xFF64A8FE).withOpacity(isDark ? 0.16 : 0.24),
            size: 240,
          ),
        ),
        Positioned(
          left: -90,
          bottom: 80,
          child: _blurBlob(
            color: const Color(0xFFB2C8E8).withOpacity(isDark ? 0.10 : 0.24),
            size: 260,
          ),
        ),
      ],
    );
  }

  Widget _blurBlob({
    required Color color,
    required double size,
  }) {
    return IgnorePointer(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 55, sigmaY: 55),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}