import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:piggram_mobile/auth/user_auth_repository.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserAuthRepository _userAuth = UserAuthRepository();
  AuthBloc() : super(AuthInitial()) {
    on<AuthSignInEmailEvent>(_signInEmail);
    on<AuthVerifySignInEvent>(_verifySignIn);
    on<AuthRegisterEmailEvent>(_registerEmail);
    on<AuthSignInGoogleEvent>(_signInGoogle);
    on<AuthSignOutEvent>(_signOut);
  }

  FutureOr<void> _signInEmail(
      AuthSignInEmailEvent event, Emitter<AuthState> emit) async {
    var res = await _userAuth.SignInEmailPassword(event.email, event.password);
    if (res == 'user-not-found' || res == 'wrong-password') {
      emit(AuthFirebaseErrorState(res!));
      return;
    }
    emit(AuthSignedInState());
  }

  FutureOr<void> _verifySignIn(
      AuthVerifySignInEvent event, Emitter<AuthState> emit) {
    if (_userAuth.isAuthenticated()) {
      emit(AuthSignedInState());
    } else {
      emit(AuthUnsignedInState());
    }
  }

  FutureOr<void> _registerEmail(
      AuthRegisterEmailEvent event, Emitter<AuthState> emit) async {
    var res =
        await _userAuth.RegisterEmailPassword(event.email, event.password);
    if (res == 'weak-password' || res == 'email-already-in-use') {
      emit(AuthFirebaseErrorState(res!));
      return;
    }
    if (res != null) {
      emit(AuthErrorState(res));
      return;
    }
    emit(AuthSignedInState());
  }

  FutureOr<void> _signInGoogle(
      AuthSignInGoogleEvent event, Emitter<AuthState> emit) async {
    await _userAuth.signInGoogle();
    //After SignIn find if current acoount contains an entry in the database
    var docsRef = await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (!docsRef.exists) {
      emit(AuthFirstSignInState());
      return;
    }
    emit(AuthSignedInState());
  }

  FutureOr<void> _signOut(
      AuthSignOutEvent event, Emitter<AuthState> emit) async {
    if (await _userAuth.isSignedInGoogle()) {
      await _userAuth.signOutGoogleUser();
    }
    if (_userAuth.isAuthenticated()) {
      await _userAuth.signoutFirebaseUser();
    }
    emit(AuthUnsignedInState());
  }
}
