part of 'profile_page_bloc.dart';

abstract class ProfilePageState extends Equatable {
  const ProfilePageState();

  @override
  List<Object> get props => [];
}

class ProfilePageInitial extends ProfilePageState {}

class ProfilePageLoadingState extends ProfilePageState {}

class ProfilePageErrorState extends ProfilePageState {}

class ProfilePageUserLoadedState extends ProfilePageState {
  final Map<String, dynamic> user;

  ProfilePageUserLoadedState({required this.user});

  @override
  List<Object> get props => [user];
}

class ProfilePagePostsLoadedState extends ProfilePageState {
  final Map<String, dynamic> user;
  final List<Map<String, dynamic>> posts;

  ProfilePagePostsLoadedState({required this.user, required this.posts});

  @override
  List<Object> get props => [user, posts];
}
