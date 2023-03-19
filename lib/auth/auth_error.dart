import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
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
  abstract class AuthError{
  final String dialogTitle;
  final String dialogText;

  const AuthError({
    required this.dialogTitle,
    required this.dialogText,
  });

  factory AuthError.from(FirebaseAuthException exception) =>
      authErrorMapping[exception.code.toLowerCase().trim()] ??
      const AuthErrorUnknown();
  }

  // unknown error
  @immutable
  class AuthErrorUnknown extends AuthError{
    const AuthErrorUnknown()
    : super(
      dialogTitle: 'Authentication error',
      dialogText: 'Unknown Authentication error'
    );
  }

// no current user
@immutable
class AuthErrorNoCurrentUser extends AuthError{
  const AuthErrorNoCurrentUser()
      : super(
      dialogTitle: 'No current user!',
      dialogText: 'No current user with this info was found!'
  );
}

// requires recent login
@immutable
class AuthErrorRequiresRecentLogin extends AuthError{
  const AuthErrorRequiresRecentLogin()
      : super(
      dialogTitle: 'Requires recent login!',
      dialogText: 'Log out and log in again to perform this action'
  );
}

// email is being used
@immutable
class AuthErrorEmailAlreadyInUse extends AuthError{
  const AuthErrorEmailAlreadyInUse()
      : super(
      dialogTitle: 'Email in use!',
      dialogText: 'This email is in use. Try another email!!!!'
  );
}

// operation is not allowed
@immutable
class AuthErrorOperationNotAllowed extends AuthError{
  const AuthErrorOperationNotAllowed()
      : super(
      dialogTitle: 'Operation not allowed!',
      dialogText: 'You can\'t register using this method at the time !!'
  );
}

// invalid email
@immutable
class AuthErrorInvalidEmail extends AuthError{
  const AuthErrorInvalidEmail()
      : super(
      dialogTitle: 'Invalid email!',
      dialogText: 'You\'ve entered an invalid email format. Try another format possibly \'you@name.com\'!!!'
  );
}

// invalid email
@immutable
class AuthErrorWeakPassword extends AuthError{
  const AuthErrorWeakPassword()
      : super(
      dialogTitle: 'Weak Password!!',
      dialogText: 'You\'ve entered a weak password. Try mixing capital and small letters, symbols and numbers!!!'
  );
}

// user not found
@immutable
class AuthErrorUserNotFound extends AuthError{
  const AuthErrorUserNotFound()
      : super(
      dialogTitle: 'User-not-found!',
      dialogText: 'The given user cannot be found!!!'
  );
}