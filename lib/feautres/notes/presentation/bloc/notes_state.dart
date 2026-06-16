import 'package:equatable/equatable.dart';
import '../../domain/entities/note_entity.dart';

enum NotesStatus { initial, loading, success, failure }

class NotesState extends Equatable {
  final NotesStatus status;
  final List<NoteEntity> notes;
  final String? errorMessage;
  final bool actionInProgress;

  const NotesState({
    this.status = NotesStatus.initial,
    this.notes = const [],
    this.errorMessage,
    this.actionInProgress = false,
  });

  NotesState copyWith({
    NotesStatus? status,
    List<NoteEntity>? notes,
    String? errorMessage,
    bool? actionInProgress,
  }) {
    return NotesState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      errorMessage: errorMessage,
      actionInProgress: actionInProgress ?? this.actionInProgress,
    );
  }

  @override
  List<Object?> get props => [status, notes, errorMessage, actionInProgress];
}