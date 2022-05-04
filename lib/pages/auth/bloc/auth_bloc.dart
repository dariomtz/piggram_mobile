import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:piggram_mobile/utils/file_requests.dart';
import 'package:piggram_mobile/utils/auth_requests.dart';
import 'package:piggram_mobile/utils/user_requests.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRequests _userAuth = AuthRequests();
  AuthBloc() : super(AuthInitial()) {
    on<AuthSignInEmailEvent>(_signInEmail);
    on<AuthVerifySignInEvent>(_verifySignIn);
    on<AuthRegisterEmailEvent>(_registerEmail);
    on<AuthSignInGoogleEvent>(_signInGoogle);
    on<AuthSignOutEvent>(_signOut);
    on<AuthCreateUserEvent>(_create);
  }

  FutureOr<void> _signInEmail(
      AuthSignInEmailEvent event, Emitter<AuthState> emit) async {
    var res = await _userAuth.SignInEmailPassword(event.email, event.password);
    if (res != null) {
      emit(AuthFirebaseErrorState(res));
      return;
    }
    //If not created the acount go to first sign in
    if (await UserRequests.isRegistered(
        FirebaseAuth.instance.currentUser!.uid)) {
      emit(AuthSignedInState());
    } else {
      emit(AuthFirstSignInState(
          description: "Hey, I'm using PigGram",
          name: FirebaseAuth.instance.currentUser?.displayName));
    }
  }

  FutureOr<void> _verifySignIn(
      AuthVerifySignInEvent event, Emitter<AuthState> emit) async {
    if (_userAuth.isAuthenticated()) {
      var res =
          await UserRequests.findById(FirebaseAuth.instance.currentUser!.uid);
      if (res.exists) {
        emit(AuthSignedInState());
      } else {
        emit(AuthFirstSignInState(
            description: "Hey, I'm using PigGram",
            name: FirebaseAuth.instance.currentUser?.displayName));
      }
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
    emit(AuthFirstSignInState(
        description: "Hey, I'm using PigGram",
        name: FirebaseAuth.instance.currentUser?.displayName));
  }

  FutureOr<void> _signInGoogle(
      AuthSignInGoogleEvent event, Emitter<AuthState> emit) async {
    await _userAuth.signInGoogle();
    //After SignIn find if current acoount contains an entry in the database
    if (await UserRequests.isRegistered(
        FirebaseAuth.instance.currentUser!.uid)) {
      emit(AuthSignedInState());
    } else {
      emit(AuthFirstSignInState(
          description: "Hey, I'm using PigGram",
          name: FirebaseAuth.instance.currentUser?.displayName));
    }
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

  FutureOr<void> _create(
      AuthCreateUserEvent event, Emitter<AuthState> emit) async {
    try {
      String? url = await FileRequests.uploadImage(event.image);
      if (url == null) {
        emit(AuthErrorState("Unable to upload the image"));
        emit(AuthFirstSignInState(
            name: event.name,
            username: event.username,
            image: event.image,
            description: event.description,
            dateOfBirth: event.dateOfBirth));
        return;
      }
      bool res = await UserRequests.registerAccount(
          name: event.name,
          username: event.username,
          image: url,
          description: event.description,
          dateOfBirth: event.dateOfBirth);
      if (!res) {
        emit(AuthErrorState("Username already exist"));
        emit(AuthFirstSignInState(
            name: event.name,
            username: event.username,
            image: event.image,
            description: event.description,
            dateOfBirth: event.dateOfBirth));
        return;
      }
      emit(AuthSignedInState());
    } catch (err) {
      emit(AuthErrorState("Something went wrong"));
      emit(AuthFirstSignInState(
          name: event.name,
          username: event.username,
          image: event.image,
          description: event.description,
          dateOfBirth: event.dateOfBirth));
    }
  }
}
