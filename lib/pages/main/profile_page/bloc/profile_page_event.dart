part of 'profile_page_bloc.dart';

abstract class ProfilePageEvent extends Equatable {
  const ProfilePageEvent();

  @override
  List<Object> get props => [];
}

class ProfilePageGetProfileEvent extends ProfilePageEvent {}

class ProfilePageUpdateModeEvent extends ProfilePageEvent {
  final String mode;
  final ProfileData profile;
  const ProfilePageUpdateModeEvent({required this.mode, required this.profile});

  @override
  List<Object> get props => [mode, profile];
}
