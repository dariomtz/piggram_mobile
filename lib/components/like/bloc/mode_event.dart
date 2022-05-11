part of 'mode_bloc.dart';

abstract class ModeEvent extends Equatable {
  const ModeEvent();

  @override
  List<Object> get props => [];
}

class ModeLoadEvent extends ModeEvent {}

class ModeUpdateEvent extends ModeEvent {
  final String mode;
  const ModeUpdateEvent({required this.mode});

  @override
  List<Object> get props => [mode];
}
