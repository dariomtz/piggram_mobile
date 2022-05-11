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
  final List<List<dynamic>> stack;
  const OtherUserProfileLoaded(
      {required this.profileData, required this.follow, required this.stack});

  @override
  List<Object> get props => [profileData, follow, stack];
}

class OtherUserProfileLoadingFollow extends OtherUserProfileState {
  final ProfileData profileData;
  const OtherUserProfileLoadingFollow({required this.profileData});

  @override
  List<Object> get props => [profileData];
}

class OtherUserProfileError extends OtherUserProfileState {}
