part of 'like_bloc.dart';

abstract class LikeEvent extends Equatable {
  const LikeEvent();

  @override
  List<Object> get props => [];
}

class LikeChangeEvent extends LikeEvent {
  final String postId;
  final bool liked;

  LikeChangeEvent({required this.postId, required this.liked});

  @override
  List<Object> get props => [postId, liked];
}

class LikeRefreshEvent extends LikeEvent {
  final String postId;

  LikeRefreshEvent(this.postId);

  @override
  List<Object> get props => [postId];
}
