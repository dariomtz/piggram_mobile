part of 'mode_bloc.dart';

abstract class ModeState extends Equatable {
  const ModeState();

  @override
  List<Object> get props => [];
}

class ModeInitial extends ModeState {}

class ModeError extends ModeState {}

class ModeLoading extends ModeState {}

class ModeLoaded extends ModeState {
  final String mode;
  const ModeLoaded({required this.mode});

  @override
  List<Object> get props => [mode];
}
