import 'package:equatable/equatable.dart';
import '../../domain/entities/note_entity.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotes extends NotesEvent {
  final String userId;
  const LoadNotes(this.userId);

  @override
  List<Object?> get props => [userId];
}

class NotesLoadedFromStream extends NotesEvent {
  final List<NoteEntity> notes;
  const NotesLoadedFromStream(this.notes);

  @override
  List<Object?> get props => [notes];
}

class CreateNoteEvent extends NotesEvent {
  final String userId;
  final String title;
  final String description;

  const CreateNoteEvent({
    required this.userId,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [userId, title, description];
}

class UpdateNoteEvent extends NotesEvent {
  final String noteId;
  final String title;
  final String description;

  const UpdateNoteEvent({
    required this.noteId,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [noteId, title, description];
}

class DeleteNoteEvent extends NotesEvent {
  final String noteId;
  const DeleteNoteEvent(this.noteId);

  @override
  List<Object?> get props => [noteId];
}