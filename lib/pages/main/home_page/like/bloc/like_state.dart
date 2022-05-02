part of 'like_bloc.dart';

abstract class LikeState extends Equatable {
  const LikeState();

  @override
  List<Object> get props => [];
}

class LikeInitial extends LikeState {}

class LikeDoneState extends LikeState {
  final String postId;
  final List<LikeData> likes;

  LikeDoneState(this.postId, this.likes);

  @override
  List<Object> get props => [postId, likes];
}

class LikeErrorState extends LikeState {
  final String error;

  LikeErrorState(this.error);
}
