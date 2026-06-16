import '../entities/note_entity.dart';
import '../repositories/notes_repository.dart';

class WatchNotesUseCase {
  final NotesRepository repository;
  WatchNotesUseCase(this.repository);

  Stream<List<NoteEntity>> call(String userId) => repository.watchNotes(userId);
}