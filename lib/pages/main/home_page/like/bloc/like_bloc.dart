import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:piggram_mobile/data/like.dart';
import 'package:piggram_mobile/utils/likes_requests.dart';

part 'like_event.dart';
part 'like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  LikeBloc() : super(LikeInitial()) {
    on<LikeAddEvent>(_onAdd);
    on<LikeRemoveEvent>(_onRemove);
  }

  FutureOr<void> _onAdd(LikeAddEvent event, Emitter<LikeState> emit) async {
    emit(LikeInitial());
    var userId = FirebaseAuth.instance.currentUser!.uid;
    var like = await LikesRequests.find(event.postId, userId);
    if (like != null) {
      emit(LikeErrorState("Like already exist"));
      return;
    }
    await FirebaseFirestore.instance
        .collection("likes")
        .add({"postId": event.postId, "userId": userId});

    var likes = await LikesRequests.getByPostId(event.postId);
    emit(LikeDoneState(event.postId, likes));
  }

  FutureOr<void> _onRemove(
      LikeRemoveEvent event, Emitter<LikeState> emit) async {
    emit(LikeInitial());
    var userId = FirebaseAuth.instance.currentUser!.uid;
    var like = await LikesRequests.find(event.postId, userId);
    if (like == null) {
      emit(LikeErrorState("Like doesn't exist"));
      return;
    }
    await FirebaseFirestore.instance.collection("likes").doc(like.id).delete();
    var likes = await LikesRequests.getByPostId(event.postId);
    emit(LikeDoneState(event.postId, likes));
  }
}
