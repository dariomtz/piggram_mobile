part of 'profile_page_bloc.dart';

abstract class ProfilePageState extends Equatable {
  const ProfilePageState();

  @override
  List<Object> get props => [];
}

class ProfilePageInitial extends ProfilePageState {}

class ProfilePageLoadingState extends ProfilePageState {}

class ProfilePageErrorState extends ProfilePageState {}

class ProfilePageLoadedState extends ProfilePageState {
  final Map<String, dynamic> user;
  final List<Map<String, dynamic>> posts;

  ProfilePageLoadedState({required this.user, required this.posts});

  @override
  List<Object> get props => [user, posts];
}
