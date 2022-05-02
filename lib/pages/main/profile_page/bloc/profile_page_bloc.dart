import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:piggram_mobile/data/profile.dart';
import 'package:piggram_mobile/utils/user_requests.dart';

part 'profile_page_event.dart';
part 'profile_page_state.dart';

class ProfilePageBloc extends Bloc<ProfilePageEvent, ProfilePageState> {
  ProfilePageBloc() : super(ProfilePageInitial()) {
    on<ProfilePageGetProfileEvent>(_init);
  }

  FutureOr<void> _init(
      ProfilePageGetProfileEvent event, Emitter<ProfilePageState> emit) async {
    //Loads the information needed in profile page from firebase
    emit(ProfilePageLoadingState());
    try {
      String _userId = FirebaseAuth.instance.currentUser!.uid;
      ProfileData data = await UserRequests.getProfile(_userId);

      emit(ProfilePageLoadedState(profileData: data));
    } catch (e) {
      emit(ProfilePageErrorState());
    }
  }
}
