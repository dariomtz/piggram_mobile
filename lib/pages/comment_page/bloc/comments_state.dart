part of 'comments_bloc.dart';

abstract class CommentsState extends Equatable {
  const CommentsState();

  @override
  List<Object> get props => [];
}

class CommentsInitial extends CommentsState {}

class CommentsLoadingState extends CommentsState {}

class CommentsLoadedState extends CommentsState {
  final List<CommentData> comments;

  CommentsLoadedState(this.comments);
}

class CommentsErrorState extends CommentsState {}

class CommentsCreatedState extends CommentsState {}
