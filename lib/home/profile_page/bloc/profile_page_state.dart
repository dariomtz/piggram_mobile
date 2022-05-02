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
  final ProfileData profileData;

  ProfilePageLoadedState({required this.profileData});

  @override
  List<Object> get props => [profileData];
}
