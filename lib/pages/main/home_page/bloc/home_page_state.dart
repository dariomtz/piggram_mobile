part of 'home_page_bloc.dart';

abstract class HomePageState extends Equatable {
  const HomePageState();

  @override
  List<Object> get props => [];
}

class HomePageInitial extends HomePageState {}

class HomePageLoadingState extends HomePageState {}

class HomePageLoadedState extends HomePageState {
  final List<PostData> posts;
  final List<List<UserData>> likes;
  final List<bool> likeds;

  HomePageLoadedState(
      {required this.posts, required this.likes, required this.likeds});

  @override
  List<Object> get props => [posts, likes, likeds];
}

class HomePageErrorState extends HomePageState {}
