part of 'like_bloc.dart';

abstract class LikeState extends Equatable {
  const LikeState();

  @override
  List<Object> get props => [];
}

class LikeInitial extends LikeState {}

class LikeDoneState extends LikeState {
  final String postId;
  final List<UserData> likes;
  final bool liked;

  LikeDoneState(
      {required this.postId, required this.likes, required this.liked});

  @override
  List<Object> get props => [postId, likes, liked];
}

class LikeErrorState extends LikeState {
  final String error;

  LikeErrorState(this.error);
}
