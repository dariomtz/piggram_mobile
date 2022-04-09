import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

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
      //get user info from firebase
      //TODO: change example doc id to use the user id after implementing authentication.
      const _userId = "AfqGBa3fUuDwAxuHkp2o";
      //Get user info from firebase
      var userInfo = await FirebaseFirestore.instance
          .collection("user")
          .doc(_userId)
          .get();
      var _user = userInfo.data();

      //get the count of followers
      var followersDoc = await FirebaseFirestore.instance
          .collection("follow")
          .where("followeeId", isEqualTo: _userId)
          .get();

      _user!["followers"] = followersDoc.docs.length;

      //Get count of following
      var followingDoc = await FirebaseFirestore.instance
          .collection("follow")
          .where("followerId", isEqualTo: _userId)
          .get();

      _user["following"] = followingDoc.docs.length;

      //get posts from firebase
      var postsDoc = await FirebaseFirestore.instance
          .collection("post")
          .where("userId", isEqualTo: _userId)
          .get();

      var _posts = postsDoc.docs.map((post) => post.data()).toList();

      _user["posts"] = postsDoc.docs.length;

      emit(ProfilePageLoadedState(user: _user, posts: _posts));
    } catch (e) {
      emit(ProfilePageErrorState());
    }
  }
}
