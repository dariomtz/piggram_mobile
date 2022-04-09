import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_page_event.dart';
part 'profile_page_state.dart';

class ProfilePageBloc extends Bloc<ProfilePageEvent, ProfilePageState> {
  ProfilePageBloc() : super(ProfilePageInitial()) {
    on<ProfilePageInitEvent>(_init);
  }

  FutureOr<void> _init(
      ProfilePageInitEvent event, Emitter<ProfilePageState> emit) {
    emit(ProfilePageLoadingState());
    try {
      //get user info from firebase
      const _user = {
        "name": "Dario m",
        "username": "darihongo",
        "description": "Hi im bob",
        "image": "url"
      };
      //Also get the count of followers ando following from firebase

      emit(ProfilePageUserLoadedState(user: _user));

      //get post from firebase
      var _posts = List.filled(10, {
        "image":
            "'https://www.pequerecetas.com/wp-content/uploads/2020/10/tacos-mexicanos.jpg'"
      });
      emit(ProfilePagePostsLoadedState(user: _user, posts: _posts));
    } catch (e) {
      emit(ProfilePageErrorState());
    }
  }
}
