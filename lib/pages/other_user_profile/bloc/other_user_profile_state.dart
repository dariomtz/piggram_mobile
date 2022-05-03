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
  final bool follow;
  const OtherUserProfileLoaded(
      {required this.profileData, required this.follow});

  @override
  List<Object> get props => [profileData, follow];
}

class OtherUserProfileLoadingFollow extends OtherUserProfileState {
  final ProfileData profileData;
  const OtherUserProfileLoadingFollow({required this.profileData});

  @override
  List<Object> get props => [profileData];
}

class OtherUserProfileError extends OtherUserProfileState {}
