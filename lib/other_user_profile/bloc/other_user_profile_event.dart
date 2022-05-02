part of 'other_user_profile_bloc.dart';

abstract class OtherUserProfileEvent extends Equatable {
  const OtherUserProfileEvent();

  @override
  List<Object> get props => [];
}

class OtherUserProfileLoad extends OtherUserProfileEvent {
  final String userId;
  const OtherUserProfileLoad({required this.userId});

  @override
  List<Object> get props => [userId];
}

class OtherUserProfileLoadByUsername extends OtherUserProfileEvent {
  final String username;
  const OtherUserProfileLoadByUsername({required this.username});

  @override
  List<Object> get props => [username];
}
