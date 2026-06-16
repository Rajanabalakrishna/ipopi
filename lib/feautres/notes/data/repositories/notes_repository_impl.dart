import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/notes_remote_datasource.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesRemoteDataSource _dataSource;
  NotesRepositoryImpl(this._dataSource);

  @override
  Stream<List<NoteEntity>> watchNotes(String userId) => _dataSource.watchNotes(userId);

  @override
  Future<void> createNote({required String userId, required String title, required String content}) =>
      _dataSource.createNote(userId: userId, title: title, content: content);

  @override
  Future<void> updateNote({required String noteId, required String title, required String content}) =>
      _dataSource.updateNote(noteId: noteId, title: title, content: content);

  @override
  Future<void> deleteNote(String noteId) => _dataSource.deleteNote(noteId);
}