part of 'home_page_bloc.dart';

abstract class HomePageState extends Equatable {
  const HomePageState();

  @override
  List<Object> get props => [];
}

class HomePageInitial extends HomePageState {}

class HomePageLoadingState extends HomePageState {}

class HomePageLoadedState extends HomePageState {
  final List<Map<String, dynamic>> posts;

  HomePageLoadedState({required this.posts});

  @override
  List<Object> get props => [posts];
}

class HomePageErrorState extends HomePageState {}
