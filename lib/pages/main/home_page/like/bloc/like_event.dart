part of 'like_bloc.dart';

abstract class LikeEvent extends Equatable {
  const LikeEvent();

  @override
  List<Object> get props => [];
}

class LikeAddEvent extends LikeEvent {
  final String postId;

  LikeAddEvent(this.postId);

  @override
  List<Object> get props => [postId];
}

class LikeRemoveEvent extends LikeEvent {
  final String postId;

  LikeRemoveEvent(this.postId);

  @override
  List<Object> get props => [postId];
}

class LikeRefreshEvent extends LikeEvent {
  final String postId;

  LikeRefreshEvent(this.postId);

  @override
  List<Object> get props => [postId];
}
