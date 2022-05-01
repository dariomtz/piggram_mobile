part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class PostSubmitEvent extends PostEvent {
  final String description;
  final Uint8List image;

  PostSubmitEvent({required this.description, required this.image});

  @override
  List<Object> get props => [description, image];
}
