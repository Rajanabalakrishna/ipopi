import '../repositories/notes_repository.dart';

class DeleteNoteUseCase {
  final NotesRepository repository;
  DeleteNoteUseCase(this.repository);

  Future<void> call(String noteId) => repository.deleteNote(noteId);
}