import 'package:bloc_firebase_photo_gallery/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppState {
  final bool isLoading;
  final AuthError? authError;

  const AppState({
    this.isLoading = false,
    this.authError,
  });
}

@immutable
class AppStateLoggedIn extends AppState {
  final User user;
  final Iterable<Reference> images;

  const AppStateLoggedIn({
    required this.user,
    required this.images,
    bool isLoading = false,
    AuthError? authError,
  }) : super(
          isLoading: isLoading,
          authError: authError,
        );

  @override
  bool operator ==(other) {
    final otherClass = other;
    if (otherClass is AppStateLoggedIn) {
      print('otherClass ' + otherClass.images.length.toString());
      print('class ' + images.length.toString());
      return isLoading == otherClass.isLoading &&
          user.uid == otherClass.user.uid &&
          images.length == otherClass.images.length;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(
        user.uid,
        images.length,
      );

  @override
  String toString() => 'AppStateLoggedIn { user: $user, images: $images }';
}

@immutable
class AppStateLoggedOut extends AppState {
  const AppStateLoggedOut({
    bool isLoading = false,
    AuthError? authError,
  }) : super(
          isLoading: isLoading,
          authError: authError,
        );

  @override
  String toString() =>
      'AppStateLoggedOut, isLoading = $isLoading, authError = $authError';
}

@immutable
class AppStateInRegistrationView extends AppState {
  const AppStateInRegistrationView({
    bool isLoading = false,
    AuthError? authError,
  }) : super(
          isLoading: isLoading,
          authError: authError,
        );
}

@immutable
class AppStateInitializing extends AppState {
  const AppStateInitializing() : super(isLoading: true);
}

extension GetUser on AppState {
  User? get user {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.user;
    }
    return null;
  }
}

extension GetImages on AppState {
  Iterable<Reference>? get images {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.images;
    }
    return null;
  }
}
