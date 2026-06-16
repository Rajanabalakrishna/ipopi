import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipopi/feautres/auth/domain/entities/user_entity.dart';
import 'package:ipopi/feautres/notes/domain/entities/note_entity.dart';
import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';
import '../bloc/notes_state.dart';
import 'create_edit_note_screen.dart';
import 'note_details_screen.dart';
import '../../notes_injector.dart';
import 'package:ipopi/core/providers/user_provider.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  late final NotesBloc _notesBloc;

  @override
  void initState() {
    super.initState();

    // ✅ FIX: Read userId FIRST from userProvider, then create the bloc with it
    final user = ref.read(userProvider);
    final userId = user?.uid ?? '';

    _notesBloc = createNotesBloc(); // plain creation — no userId needed in injector

    // ✅ FIX: Dispatch LoadNotes immediately with the real userId
    if (userId.isNotEmpty) {
      _notesBloc.add(LoadNotes(userId));
    }
  }

  void _loadNotes() {
    final user = ref.read(userProvider);
    if (user != null && user.uid.isNotEmpty) {
      _notesBloc.add(LoadNotes(user.uid));
    }
  }

  @override
  void dispose() {
    _notesBloc.close();
    super.dispose();
  }

  Future<void> _openCreateScreen(UserEntity user) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: _notesBloc,
          child: CreateEditNoteScreen(userId: user.uid),
        ),
      ),
    );
    _notesBloc.add(LoadNotes(user.uid));
  }

  Future<void> _openEditScreen(UserEntity user, NoteEntity note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: _notesBloc,
          child: CreateEditNoteScreen(
            userId: user.uid,
            note: note,
          ),
        ),
      ),
    );
    _notesBloc.add(LoadNotes(user.uid));
  }

  Future<void> _openDetailsScreen(UserEntity user, NoteEntity note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteDetailsScreen(
          user: user,
          note: note,
          onEdit: () async {
            Navigator.pop(context);
            await Future.delayed(const Duration(milliseconds: 150));
            await _openEditScreen(user, note);
          },
        ),
      ),
    );
    _notesBloc.add(LoadNotes(user.uid));
  }

  Future<void> _logout() async {
    await ref.read(userProvider.notifier).clearUser();
  }

  Future<bool> _showDeleteDialog(NoteEntity note) async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.white.withOpacity(0.78),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.10)
                        : Colors.white.withOpacity(0.80),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.20)
                          : const Color(0xFF3A506B).withOpacity(0.10),
                      blurRadius: 28,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.error.withOpacity(0.12),
                      ),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        color: theme.colorScheme.error,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Delete note?',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Are you sure you want to delete "${note.title}"?\nThis action cannot be undone.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                        color: theme.colorScheme.onSurface.withOpacity(0.68),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(false),
                            style: OutlinedButton.styleFrom(
                              padding:
                              const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              side: BorderSide(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.15),
                              ),
                            ),
                            child: const Text('No'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(true),
                            style: FilledButton.styleFrom(
                              backgroundColor: theme.colorScheme.error,
                              foregroundColor: Colors.white,
                              padding:
                              const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text('Yes, Delete'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // ✅ FIX: watch userProvider — if user becomes null after logout, screen reacts
    final UserEntity? user = ref.watch(userProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return BlocProvider.value(
      value: _notesBloc,
      child: Scaffold(
        backgroundColor:
        isDark ? const Color(0xFF0B1220) : const Color(0xFFF8F9FF),
        body: Stack(
          children: [
            const _LuminaBackground(),
            SafeArea(
              child: Column(
                children: [
                  _LuminaTopBar(
                    user: user,
                    onLogout: _logout,
                  ),
                  Expanded(
                    child: BlocConsumer<NotesBloc, NotesState>(
                      listener: (context, state) {
                        if (state.errorMessage != null &&
                            state.errorMessage!.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text(state.errorMessage!),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state.status == NotesStatus.loading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (state.notes.isEmpty) {
                          return _LuminaEmptyState(theme: theme);
                        }

                        return RefreshIndicator(
                          onRefresh: () async => _loadNotes(),
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding:
                            const EdgeInsets.fromLTRB(20, 12, 20, 110),
                            itemCount: state.notes.length,
                            separatorBuilder: (_, __) =>
                            const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final NoteEntity note = state.notes[index];
                              final bool featured = index == 0;

                              return Dismissible(
                                key: ValueKey(note.id),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.error,
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  child: const Icon(Icons.delete_rounded,
                                      color: Colors.white, size: 28),
                                ),
                                confirmDismiss: (_) async =>
                                await _showDeleteDialog(note),
                                onDismissed: (_) {
                                  context
                                      .read<NotesBloc>()
                                      .add(DeleteNoteEvent(note.id));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      content:
                                      Text('"${note.title}" deleted'),
                                    ),
                                  );
                                },
                                child: _LuminaNoteCard(
                                  note: note,
                                  featured: featured,
                                  onTap: () => _openDetailsScreen(user, note),
                                  onEditTap: () => _openEditScreen(user, note),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: _LuminaFab(
          onPressed: () => _openCreateScreen(user),
        ),
      ),
    );
  }
}

// ─── Top Bar ────────────────────────────────────────────────────────────────

class _LuminaTopBar extends StatelessWidget {
  final UserEntity user;
  final Future<void> Function() onLogout;

  const _LuminaTopBar({required this.user, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
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
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.18)
                      : const Color(0xFF3A506B).withOpacity(0.08),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: isDark
                          ? const [Color(0xFF5D7FA3), Color(0xFF2E4663)]
                          : const [Color(0xFF3A506B), Color(0xFF4A607C)],
                    ),
                  ),
                  child: const Icon(Icons.auto_awesome_rounded,
                      color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Opipi Notes',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.person_rounded,
                              size: 14,
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.55)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
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
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () async => onLogout(),
                  tooltip: 'Logout',
                  icon: Icon(Icons.logout_rounded,
                      color: theme.colorScheme.onSurface.withOpacity(0.70)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Empty State ─────────────────────────────────────────────────────────────

class _LuminaEmptyState extends StatelessWidget {
  final ThemeData theme;
  const _LuminaEmptyState({required this.theme});

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.06)
                    : Colors.white.withOpacity(0.42),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.white.withOpacity(0.68),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? Colors.white.withOpacity(0.08)
                          : const Color(0xFFD3E4FE).withOpacity(0.85),
                    ),
                    child: Icon(Icons.mode_edit_outline_rounded,
                        size: 42,
                        color: theme.colorScheme.primary.withOpacity(0.9)),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No notes yet',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start your productivity journey by creating your first note.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.60),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Note Card ───────────────────────────────────────────────────────────────

class _LuminaNoteCard extends StatelessWidget {
  final NoteEntity note;
  final bool featured;
  final VoidCallback onTap;
  final VoidCallback onEditTap;

  const _LuminaNoteCard({
    required this.note,
    required this.featured,
    required this.onTap,
    required this.onEditTap,
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

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.98, end: 1),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      builder: (context, value, child) =>
          Transform.scale(scale: value, child: child),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: featured
                  ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                  Colors.white.withOpacity(0.10),
                  const Color(0xFF314863).withOpacity(0.24),
                ]
                    : [
                  Colors.white.withOpacity(0.72),
                  const Color(0xFFDCE9FF).withOpacity(0.92),
                ],
              )
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: featured
                        ? Colors.transparent
                        : isDark
                        ? Colors.white.withOpacity(0.06)
                        : Colors.white.withOpacity(0.58),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.10)
                          : Colors.white.withOpacity(0.75),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withOpacity(0.16)
                            : const Color(0xFF3A506B).withOpacity(0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: featured
                                          ? const Color(0xFF0060AC)
                                          .withOpacity(0.12)
                                          : theme.colorScheme.primary
                                          .withOpacity(0.10),
                                      borderRadius:
                                      BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      featured ? 'Featured Note' : 'Quick Note',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                        color: featured
                                            ? const Color(0xFF0060AC)
                                            : theme.colorScheme.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _formatDate(note.updatedAt),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                    style: theme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.45),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(
                              note.title,
                              maxLines: featured ? 2 : 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              note.content,
                              maxLines: featured ? 4 : 3,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.64),
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Icon(Icons.visibility_rounded,
                                    size: 18,
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.55)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Tap to read note',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.55),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: onEditTap,
                        tooltip: 'Edit note',
                        icon: const Icon(Icons.edit_rounded),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── FAB ─────────────────────────────────────────────────────────────────────

class _LuminaFab extends StatelessWidget {
  final VoidCallback onPressed;
  const _LuminaFab({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color:
            const Color(0xFF3A506B).withOpacity(isDark ? 0.20 : 0.25),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: onPressed,
        elevation: 0,
        backgroundColor:
        isDark ? const Color(0xFF324863) : const Color(0xFF3A506B),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Note',
            style: TextStyle(fontWeight: FontWeight.w700)),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
    );
  }
}

// ─── Background ──────────────────────────────────────────────────────────────

class _LuminaBackground extends StatelessWidget {
  const _LuminaBackground();

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
          top: -80,
          left: -80,
          child: _blurBlob(
            color:
            const Color(0xFF64A8FE).withOpacity(isDark ? 0.18 : 0.25),
            size: 220,
          ),
        ),
        Positioned(
          right: -120,
          bottom: 40,
          child: _blurBlob(
            color:
            const Color(0xFFB2C8E8).withOpacity(isDark ? 0.12 : 0.28),
            size: 300,
          ),
        ),
        Positioned(
          top: 180,
          right: 20,
          child: _blurBlob(
            color:
            const Color(0xFFD2E4FF).withOpacity(isDark ? 0.08 : 0.18),
            size: 140,
          ),
        ),
      ],
    );
  }

  Widget _blurBlob({required Color color, required double size}) {
    return IgnorePointer(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
