import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:piggram_mobile/data/follow.dart';
import 'package:piggram_mobile/data/user.dart';
import 'package:piggram_mobile/utils/user_requests.dart';

part 'follows_event.dart';
part 'follows_state.dart';

class FollowsBloc extends Bloc<FollowsEvent, FollowsState> {
  FollowsBloc() : super(FollowsInitial()) {
    on<FollowsLoad>(loadFollows);
  }

  Future<void> loadFollows(FollowsLoad event, emit) async {
    emit(FollowsLoading());
    try {
      List<UserData> followers = await UserRequests.loadUsers(
          event.followers.map((followData) => followData.follower).toList());
      List<UserData> following = await UserRequests.loadUsers(
          event.following.map((followData) => followData.followee).toList());
      emit(FollowsLoaded(followers: followers, following: following));
    } catch (e) {
      print(e);
      emit(FollowsError());
    }
  }
}
