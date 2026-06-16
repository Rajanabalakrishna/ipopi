import '../repositories/notes_repository.dart';

class CreateNoteUseCase {
  final NotesRepository repository;
  CreateNoteUseCase(this.repository);

  Future<void> call({required String userId, required String title, required String content}) =>
      repository.createNote(userId: userId, title: title, content: content);
}