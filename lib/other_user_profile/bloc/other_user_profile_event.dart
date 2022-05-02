part of 'other_user_profile_bloc.dart';

abstract class OtherUserProfileEvent extends Equatable {
  const OtherUserProfileEvent();

  @override
  List<Object> get props => [];
}

class OtherUserProfileLoadEvent extends OtherUserProfileEvent {
  final String userId;
  const OtherUserProfileLoadEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}
