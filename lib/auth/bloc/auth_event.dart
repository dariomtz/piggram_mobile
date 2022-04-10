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
