

import '../entities/note_entity.dart';

abstract class NotesRepository {
  Stream<List<NoteEntity>> watchNotes(String userId);
  Future<void> createNote({required String userId, required String title, required String content});
  Future<void> updateNote({required String noteId, required String title, required String content});
  Future<void> deleteNote(String noteId);
}