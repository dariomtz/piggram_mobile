part of 'tag_page_bloc.dart';

abstract class TagPageState extends Equatable {
  const TagPageState();

  @override
  List<Object> get props => [];
}

class TagPageInitial extends TagPageState {}

class TagPageLoading extends TagPageState {}

class TagPageLoaded extends TagPageState {
  final List<PostData> posts;

  const TagPageLoaded({required this.posts});

  @override
  List<Object> get props => [posts];
}

class TagPageError extends TagPageState {}
