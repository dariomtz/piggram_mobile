import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:piggram_mobile/data/user.dart';
import 'package:piggram_mobile/utils/likes_requests.dart';

part 'like_event.dart';
part 'like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  LikeBloc() : super(LikeInitial()) {
    on<LikeAddEvent>(_onAdd);
    on<LikeRemoveEvent>(_onRemove);
    on<LikeRefreshEvent>(_onRefresh);
  }

  FutureOr<void> _onAdd(LikeAddEvent event, Emitter<LikeState> emit) async {
    emit(LikeInitial());
    var userId = FirebaseAuth.instance.currentUser!.uid;
    await LikesRequests.create(event.postId, userId);
    var liked = await LikesRequests.exist(event.postId, userId);
    var likes = await LikesRequests.getByPostId(event.postId);
    List<UserData> users = await LikesRequests.getUsersfromList(likes);
    emit(LikeDoneState(postId: event.postId, likes: users, liked: liked));
  }

  FutureOr<void> _onRemove(
      LikeRemoveEvent event, Emitter<LikeState> emit) async {
    emit(LikeInitial());
    var userId = FirebaseAuth.instance.currentUser!.uid;
    await LikesRequests.delete(event.postId, userId);
    var liked = await LikesRequests.exist(event.postId, userId);
    var likes = await LikesRequests.getByPostId(event.postId);
    List<UserData> users = await LikesRequests.getUsersfromList(likes);
    emit(LikeDoneState(postId: event.postId, likes: users, liked: liked));
  }

  FutureOr<void> _onRefresh(
      LikeRefreshEvent event, Emitter<LikeState> emit) async {
    emit(LikeInitial());
    var userId = FirebaseAuth.instance.currentUser!.uid;
    var liked = await LikesRequests.exist(event.postId, userId);
    var likes = await LikesRequests.getByPostId(event.postId);
    List<UserData> users = await LikesRequests.getUsersfromList(likes);
    emit(LikeDoneState(postId: event.postId, likes: users, liked: liked));
  }
}
