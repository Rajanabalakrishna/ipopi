Ipopi Notes — Flutter Assessment
Authentication and Notes Manager application built for the Ipopiads Mobile Developer Assessment.

Repository: https://github.com/Rajanabalakrishna/ipopi

Project Overview
A Flutter application where users can register, log in, and manage personal notes with real-time Firebase sync. Built following Clean Architecture principles with functional error handling via fpdart.

Tech Stack
Flutter 3.x with Null Safety

Firebase Authentication

Cloud Firestore (real-time streaming)

Clean Architecture

Riverpod — authentication and session state

BLoC — notes CRUD state management

fpdart — functional error handling with Either<Failure, T>

SharedPreferences — persistent login session

Glassmorphism UI with responsive layout and dark/light theme

Architecture
The project follows Clean Architecture with three strict layers:

text
lib/
├── core/
│   ├── providers/           # Riverpod global providers
│   ├── services/            # SharedPreferences service
│   └── theme/               # App theme definitions
│
└── feautres/
    ├── auth/
    │   ├── data/
    │   │   ├── datasources/  # Firebase Auth implementation
    │   │   ├── models/       # UserModel
    │   │   └── repositories/ # AuthRepositoryImpl
    │   ├── domain/
    │   │   ├── entities/     # UserEntity (pure Dart)
    │   │   ├── repositories/ # AuthRepository (abstract)
    │   │   └── usecases/     # SignIn, SignUp, SignOut
    │   └── presentation/
    │       ├── providers/    # AuthNotifier (Riverpod)
    │       └── screens/      # LoginScreen, SignupScreen
    │
    └── notes/
        ├── data/
        │   ├── datasources/  # Firestore implementation
        │   ├── models/       # NoteModel
        │   └── repositories/ # NotesRepositoryImpl
        ├── domain/
        │   ├── entities/     # NoteEntity (pure Dart)
        │   ├── repositories/ # NotesRepository (abstract)
        │   └── usecases/     # WatchNotes, CreateNote, UpdateNote, DeleteNote
        ├── notes_injector.dart
        └── presentation/
            ├── bloc/         # NotesBloc, NotesEvent, NotesState
            └── screens/      # NotesScreen, CreateEditNoteScreen
State Management
Layer	Tool	Reason
Authentication	Riverpod StateNotifier	Simple reactive state for login/logout/session
Notes CRUD	BLoC	Event-driven stream handling for Firestore real-time data
Global user session	Riverpod userProvider	Shared across the entire widget tree
Error Handling with fpdart
All repository methods return Either<Failure, T> — Left for errors, Right for success. This keeps the domain layer free of try/catch blocks and makes failures explicit.

dart
// Repository layer
Future<Either<Failure, NoteEntity>> createNote(...) async {
  try {
    final note = await dataSource.createNote(...);
    return right(note);
  } catch (e) {
    return left(ServerFailure(e.toString()));
  }
}

// Use case — clean, no try/catch
Future<Either<Failure, NoteEntity>> call(...) async {
  return await repository.createNote(...);
}

// BLoC — fold to handle both sides
final result = await createNoteUseCase(...);
result.fold(
  (failure) => emit(state.copyWith(status: NotesStatus.failure, errorMessage: failure.message)),
  (_)       => emit(state.copyWith(status: NotesStatus.success)),
);
Firestore Structure
text
users/{userId}
  name: string
  email: string

notes/{noteId}
  userId: string
  title: string
  content: string
  createdAt: timestamp
  updatedAt: timestamp
Required composite index:
Collection notes — fields: userId ASC + updatedAt DESC

Create from Firebase Console: Firestore Database → Indexes → Add Index.
On first run, the app logs a direct URL to create this index automatically.

Setup and Installation
Prerequisites
Flutter SDK 3.x

Dart SDK with null safety

Android Studio or VS Code with Flutter plugin

A Firebase project with Authentication and Firestore enabled

Step 1 — Clone the repository
bash
git clone https://github.com/Rajanabalakrishna/ipopi.git
cd ipopi
Step 2 — Install dependencies
bash
flutter pub get
Step 3 — Firebase configuration
The google-services.json for Android is included in the repository for evaluation purposes.

To connect your own Firebase project:

bash
dart pub global activate flutterfire_cli
flutterfire configure
Then in the Firebase Console:

Authentication — enable Email/Password provider

Cloud Firestore — create database (test mode or apply rules)

Indexes — add composite index: collection notes, fields userId ASC + updatedAt DESC

Step 4 — Run the application
bash
flutter run
Step 5 — Build release APK
bash
flutter build apk --release
Output: build/app/outputs/flutter-apk/app-release.apk

Dependencies
Package	Version	Purpose
firebase_core	^4.10.0	Firebase initialization
firebase_auth	^6.5.2	User authentication
cloud_firestore	^6.5.0	Database and real-time sync
flutter_riverpod	^3.3.2	Auth and session state
flutter_bloc	^9.1.1	Notes state management
fpdart	^1.2.0	Functional error handling
shared_preferences	^2.5.5	Session persistence
equatable	^2.0.8	Value equality for BLoC
uuid	^4.5.3	Unique note ID generation
google_fonts	^8.1.0	Typography
intl	^0.20.2	Date formatting
Assumptions
Notes are stored in a top-level notes collection rather than nested under users for scalable querying and indexing

The content field is used internally instead of description — semantically clearer, same purpose

SharedPreferences stores the user session so users remain logged in across app restarts

fpdart Either is used at the data and domain layers; BLoC handles the UI-level error states separately

Real-time notes streaming is implemented via Firestore Stream inside BLoC rather than StreamBuilder widget — functionally identical, architecturally cleaner

Author
Rajanabalakrishna
https://github.com/Rajanabalakrishna
