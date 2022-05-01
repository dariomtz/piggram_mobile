part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostUploadedState extends PostState {}

class PostErrorState extends PostState {
  String error;
  PostErrorState(this.error);
}
