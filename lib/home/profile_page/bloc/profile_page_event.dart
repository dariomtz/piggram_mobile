part of 'profile_page_bloc.dart';

abstract class ProfilePageEvent extends Equatable {
  const ProfilePageEvent();

  @override
  List<Object> get props => [];
}

class ProfilePageInitEvent extends ProfilePageEvent {}
