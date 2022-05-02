part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthVerifySignInEvent extends AuthEvent {}

class AuthSignInEmailEvent extends AuthEvent {
  final String email, password;

  AuthSignInEmailEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthRegisterEmailEvent extends AuthEvent {
  final String email, password;

  AuthRegisterEmailEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthSignInGoogleEvent extends AuthEvent {}

class AuthSignOutEvent extends AuthEvent {}

class AuthCreateUserEvent extends AuthEvent {
  final String name, username, description;
  final Uint8List image;
  final DateTime dateOfBirth;

  AuthCreateUserEvent(
      {required this.name,
      required this.username,
      required this.description,
      required this.image,
      required this.dateOfBirth});
  @override
  List<Object> get props => [name, username, description, image, dateOfBirth];
}
