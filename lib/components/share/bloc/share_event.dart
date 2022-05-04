part of 'share_bloc.dart';

abstract class ShareEvent extends Equatable {
  const ShareEvent();

  @override
  List<Object> get props => [];
}

class ShareSendEvent extends ShareEvent {
  final ScreenshotController controller;
  final PostData post;

  ShareSendEvent({required this.post, required this.controller});
  @override
  List<Object> get props => [controller, post];
}
