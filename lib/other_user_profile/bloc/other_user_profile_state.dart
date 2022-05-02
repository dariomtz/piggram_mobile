part of 'other_user_profile_bloc.dart';

abstract class OtherUserProfileState extends Equatable {
  const OtherUserProfileState();

  @override
  List<Object> get props => [];
}

class OtherUserProfileInitial extends OtherUserProfileState {}

class OtherUserProfileLoading extends OtherUserProfileState {}

class OtherUserProfileLoaded extends OtherUserProfileState {
  final ProfileData profileData;
  const OtherUserProfileLoaded({required this.profileData});

  @override
  List<Object> get props => [profileData];
}

class OtherUserProfileError extends OtherUserProfileState {}
