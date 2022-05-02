part of 'comments_bloc.dart';

abstract class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object> get props => [];
}

class CommentsLoadEvent extends CommentsEvent {
  final String postId;

  CommentsLoadEvent(this.postId);
  @override
  List<Object> get props => [postId];
}

class CommentsCreateEvent extends CommentsEvent {
  final String postId, comment;

  CommentsCreateEvent({required this.postId, required this.comment});
  @override
  List<Object> get props => [postId, comment];
}
