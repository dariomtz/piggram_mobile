part of 'follows_bloc.dart';

abstract class FollowsState extends Equatable {
  const FollowsState();

  @override
  List<Object> get props => [];
}

class FollowsInitial extends FollowsState {}

class FollowsLoading extends FollowsState {}

class FollowsLoaded extends FollowsState {
  final List<UserData> followers, following;
  const FollowsLoaded({required this.followers, required this.following});

  @override
  List<Object> get props => [followers, following];
}

class FollowsError extends FollowsState {}
