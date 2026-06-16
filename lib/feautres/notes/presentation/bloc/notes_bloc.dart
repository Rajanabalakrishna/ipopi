import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_note_usecase.dart';
import '../../domain/usecases/delete_note_usecase.dart';
import '../../domain/usecases/update_note_usecase.dart';
import '../../domain/usecases/watch_notes_usecase.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final WatchNotesUseCase watchNotesUseCase;
  final CreateNoteUseCase createNoteUseCase;
  final UpdateNoteUseCase updateNoteUseCase;
  final DeleteNoteUseCase deleteNoteUseCase;

  StreamSubscription? _notesSubscription;

  NotesBloc({
    required this.watchNotesUseCase,
    required this.createNoteUseCase,
    required this.updateNoteUseCase,
    required this.deleteNoteUseCase,
  }) : super(const NotesState()) {
    on<LoadNotes>(_onLoadNotes);
    on<NotesLoadedFromStream>(_onNotesLoadedFromStream);
    on<CreateNoteEvent>(_onCreateNote);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<DeleteNoteEvent>(_onDeleteNote);
  }

  Future<void> _onLoadNotes(
      LoadNotes event,
      Emitter<NotesState> emit,
      ) async {
    emit(state.copyWith(status: NotesStatus.loading));

    await _notesSubscription?.cancel();

    _notesSubscription = watchNotesUseCase(event.userId).listen(
          (notes) {
        add(NotesLoadedFromStream(notes));
      },
      onError: (error) {
        emit(
          state.copyWith(
            status: NotesStatus.failure,
            errorMessage: error.toString(),
          ),
        );
      },
    );
  }

  void _onNotesLoadedFromStream(
      NotesLoadedFromStream event,
      Emitter<NotesState> emit,
      ) {
    emit(
      state.copyWith(
        status: NotesStatus.success,
        notes: event.notes,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onCreateNote(
      CreateNoteEvent event,
      Emitter<NotesState> emit,
      ) async {
    try {
      emit(state.copyWith(actionInProgress: true, errorMessage: null));

      await createNoteUseCase(
        userId: event.userId,
        title: event.title,
        content: event.description,
      );

      emit(state.copyWith(actionInProgress: false));
    } catch (e) {
      emit(
        state.copyWith(
          actionInProgress: false,
          status: NotesStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdateNote(
      UpdateNoteEvent event,
      Emitter<NotesState> emit,
      ) async {
    try {
      emit(state.copyWith(actionInProgress: true, errorMessage: null));

      await updateNoteUseCase(
        noteId: event.noteId,
        title: event.title,
        content: event.description,
      );

      emit(state.copyWith(actionInProgress: false));
    } catch (e) {
      emit(
        state.copyWith(
          actionInProgress: false,
          status: NotesStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteNote(
      DeleteNoteEvent event,
      Emitter<NotesState> emit,
      ) async {
    try {
      await deleteNoteUseCase(event.noteId);
    } catch (e) {
      emit(
        state.copyWith(
          status: NotesStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await _notesSubscription?.cancel();
    return super.close();
  }
}