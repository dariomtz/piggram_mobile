import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:piggram_mobile/data/comment.dart';
import 'package:piggram_mobile/utils/comment_requests.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  CommentsBloc() : super(CommentsInitial()) {
    on<CommentsLoadEvent>(_onLoad);
    on<CommentsCreateEvent>(_onCreate);
  }

  FutureOr<void> _onLoad(
      CommentsLoadEvent event, Emitter<CommentsState> emit) async {
    emit(CommentsLoadingState());
    try {
      List<CommentData> comments =
          await CommentRequests.getByPostId(event.postId);
      emit(CommentsLoadedState(comments));
    } catch (err) {
      emit(CommentsErrorState());
    }
  }

  FutureOr<void> _onCreate(
      CommentsCreateEvent event, Emitter<CommentsState> emit) async {
    if (event.comment.length == 0) {
      return;
    }
    await CommentRequests.create(
        description: event.comment,
        postId: event.postId,
        userId: FirebaseAuth.instance.currentUser!.uid);
    try {
      List<CommentData> comments =
          await CommentRequests.getByPostId(event.postId);
      emit(CommentsCreatedState());
      emit(CommentsLoadedState(comments));
    } catch (err) {
      emit(CommentsErrorState());
    }
  }
}
