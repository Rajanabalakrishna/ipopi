import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'data/datasources/notes_remote_datasource.dart';
import 'data/repositories/notes_repository_impl.dart';
import 'domain/usecases/create_note_usecase.dart';
import 'domain/usecases/delete_note_usecase.dart';
import 'domain/usecases/update_note_usecase.dart';
import 'domain/usecases/watch_notes_usecase.dart';
import 'presentation/bloc/notes_bloc.dart';

NotesBloc createNotesBloc() {
  final dataSource = NotesRemoteDataSourceImpl(
    FirebaseFirestore.instance,
    const Uuid(),
  );

  final repository = NotesRepositoryImpl(dataSource);

  return NotesBloc(
    watchNotesUseCase: WatchNotesUseCase(repository),
    createNoteUseCase: CreateNoteUseCase(repository),
    updateNoteUseCase: UpdateNoteUseCase(repository),
    deleteNoteUseCase: DeleteNoteUseCase(repository),
  );
}