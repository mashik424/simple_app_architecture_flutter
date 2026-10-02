# todoist

A simple todo app Flutter project showcasing a simple folder structure/architecture.

## Project structure

```
lib/
├── controllers/     # State (ChangeNotifier) consumed by the UI via provider
├── models/          # Plain immutable data classes
├── repositories/    # Data sources behind abstract interfaces
│   └── todo_repository/
│       ├── local/       # SharedPreferences implementation
│       └── firestore/   # Cloud Firestore implementation
├── views/           # Screens, modals and widgets
├── routes.dart      # Named routes
└── main.dart        # App entry point and dependency wiring
```

## Getting Started

Requires Flutter 3.35+ (Dart 3.9+).

```sh
flutter pub get
flutter run
```

You can use either SharedPreferences or Firestore to store data.
SharedPreferences works out of the box. To use Firestore, set up your Firebase
project with the [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/) and
[Firebase CLI](https://firebase.google.com/docs/cli), then swap the repository
in `lib/main.dart` (see the comment there).

## Checks

```sh
flutter analyze
flutter test
```
