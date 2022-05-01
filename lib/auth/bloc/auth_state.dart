part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthSignedInState extends AuthState {}

class AuthUnsignedInState extends AuthState {}

class AuthErrorState extends AuthState {
  final String error;

  AuthErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class AuthFirebaseErrorState extends AuthState {
  final String error;

  AuthFirebaseErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class AuthFirstSignInState extends AuthState {
  final String? name, username, description;
  final Uint8List? image;
  final DateTime? dateOfBirth;
  AuthFirstSignInState(
      {this.name,
      this.username,
      this.description,
      this.image,
      this.dateOfBirth});
}
