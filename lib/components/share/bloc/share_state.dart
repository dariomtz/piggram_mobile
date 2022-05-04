part of 'share_bloc.dart';

abstract class ShareState extends Equatable {
  const ShareState();
  
  @override
  List<Object> get props => [];
}

class ShareInitial extends ShareState {}
