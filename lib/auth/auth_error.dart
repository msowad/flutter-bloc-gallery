import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show immutable;

const Map<String, AuthError> authErrorMapping = {
  'user-not-found': AuthErrorUserNotFound(),
  'weak-password': AuthErrorWeakPassword(),
  'invalid-email': AuthErrorInvalidEmail(),
  'operation-not-allowed': AuthErrorOperationNotAllowed(),
  'email-already-in-use': AuthErrorEmailAlreadyInUse(),
  'requires-recent-login': AuthErrorRequiresRecentLogin(),
  'no-current-user': AuthErrorNoCurrentUser(),
};

@immutable
abstract class AuthError {
  final String title;
  final String message;

  const AuthError({
    required this.title,
    required this.message,
  });

  factory AuthError.from(Object exception) {
    if (exception is FirebaseAuthException) {
      return authErrorMapping[exception.code.toLowerCase().trim()] ??
          const AuthErrorUnknown();
    }
    return const AuthErrorUnknown();
  }
}

@immutable
class AuthErrorUnknown extends AuthError {
  const AuthErrorUnknown()
      : super(
          title: 'Authentication error',
          message: 'An unknown error occurred. Try again later.',
        );
}

@immutable
class AuthErrorNoCurrentUser extends AuthError {
  const AuthErrorNoCurrentUser()
      : super(
          title: 'No current user',
          message: 'There is no current user. Please sign in.',
        );
}

@immutable
class AuthErrorUserNotFound extends AuthError {
  const AuthErrorUserNotFound()
      : super(
          title: 'User not found',
          message: 'The user with the specified email address was not found.',
        );
}

@immutable
class AuthErrorRequiresRecentLogin extends AuthError {
  const AuthErrorRequiresRecentLogin()
      : super(
          title: 'Requires recent login',
          message:
              'You need to log out and log in again in order to perform this action.',
        );
}

@immutable
class AuthErrorOperationNotAllowed extends AuthError {
  const AuthErrorOperationNotAllowed()
      : super(
          title: 'Operation not allowed',
          message: 'You are not authorized to perform this action.',
        );
}

@immutable
class AuthErrorWeakPassword extends AuthError {
  const AuthErrorWeakPassword()
      : super(
          title: 'Weak password',
          message: 'Choose a stronger password consisting of more characters',
        );
}

@immutable
class AuthErrorInvalidEmail extends AuthError {
  const AuthErrorInvalidEmail()
      : super(
          title: 'Invalid email',
          message: 'The email address is badly formatted.',
        );
}

@immutable
class AuthErrorEmailAlreadyInUse extends AuthError {
  const AuthErrorEmailAlreadyInUse()
      : super(
          title: 'Email already in use',
          message: 'The email address is already in use by another account.',
        );
}
