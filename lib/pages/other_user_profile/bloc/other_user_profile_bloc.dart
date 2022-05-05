import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:piggram_mobile/data/profile.dart';
import 'package:piggram_mobile/data/user.dart';
import 'package:piggram_mobile/utils/follow_requests.dart';
import 'package:piggram_mobile/utils/user_requests.dart';

part 'other_user_profile_event.dart';
part 'other_user_profile_state.dart';

class OtherUserProfileBloc
    extends Bloc<OtherUserProfileEvent, OtherUserProfileState> {
  OtherUserProfileBloc() : super(OtherUserProfileInitial()) {
    on<OtherUserProfileLoad>(loadProfile);
    on<OtherUserProfileLoadByUsername>(loadProfileByUsername);
    on<OtherUserProfileFollow>(follow);
  }

  Future<void> loadProfile(OtherUserProfileLoad event, emit) async {
    emit(OtherUserProfileLoading());
    try {
      ProfileData data = await UserRequests.getProfile(event.userId);
      bool follow = await FollowRequests.amIFollowing(event.userId);
      emit(OtherUserProfileLoaded(profileData: data, follow: follow));
    } catch (e) {
      print(e);
      emit(OtherUserProfileError());
    }
  }

  Future<void> loadProfileByUsername(
      OtherUserProfileLoadByUsername event, emit) async {
    emit(OtherUserProfileLoading());
    try {
      QuerySnapshot<UserData> doc =
          await UserRequests.findByUsername(event.username);
      String id = doc.docs[0].reference.id;
      ProfileData data = await UserRequests.getProfile(id);
      bool follow = await FollowRequests.amIFollowing(id);
      emit(OtherUserProfileLoaded(profileData: data, follow: follow));
    } catch (e) {
      print(e);
      emit(OtherUserProfileError());
    }
  }

  Future<void> follow(OtherUserProfileFollow event, emit) async {
    emit(OtherUserProfileLoadingFollow(profileData: event.profile));
    try {
      await FollowRequests.follow(event.profile.id, event.follow);
      emit(OtherUserProfileLoaded(
          profileData: await event.profile.updatedFollows(),
          follow: event.follow));
    } catch (e) {
      print(e);
      emit(OtherUserProfileError());
    }
  }
}
