part of 'follows_bloc.dart';

abstract class FollowsEvent extends Equatable {
  const FollowsEvent();

  @override
  List<Object> get props => [];
}

class FollowsLoad extends FollowsEvent {
  final List<FollowData> followers, following;
  const FollowsLoad({
    required this.followers,
    required this.following,
  });

  @override
  List<Object> get props => [followers, following];
}
