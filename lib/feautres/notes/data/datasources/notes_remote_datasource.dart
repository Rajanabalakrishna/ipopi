import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/note_model.dart';

abstract class NotesRemoteDataSource {
  Stream<List<NoteModel>> watchNotes(String userId);
  Future<void> createNote({
    required String userId,
    required String title,
    required String content,
  });
  Future<void> updateNote({
    required String noteId,
    required String title,
    required String content,
  });
  Future<void> deleteNote(String noteId);
}

class NotesRemoteDataSourceImpl implements NotesRemoteDataSource {
  final FirebaseFirestore firestore;
  final Uuid uuid;

  NotesRemoteDataSourceImpl(this.firestore, this.uuid);

  @override
  Stream<List<NoteModel>> watchNotes(String userId) {
    return firestore
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => NoteModel.fromMap(doc.data(), doc.id))
          .toList(),
    );
  }

  @override
  Future<void> createNote({
    required String userId,
    required String title,
    required String content,
  }) async {
    final noteId = uuid.v4();
    final now = DateTime.now();

    await firestore.collection('notes').doc(noteId).set({
      'id': noteId,
      'userId': userId,
      'title': title,
      'content': content,
      'createdAt': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
    });
  }

  @override
  Future<void> updateNote({
    required String noteId,
    required String title,
    required String content,
  }) async {
    await firestore.collection('notes').doc(noteId).update({
      'title': title,
      'content': content,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  @override
  Future<void> deleteNote(String noteId) async {
    await firestore.collection('notes').doc(noteId).delete();
  }
}