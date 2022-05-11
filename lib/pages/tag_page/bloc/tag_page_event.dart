part of 'tag_page_bloc.dart';

abstract class TagPageEvent extends Equatable {
  const TagPageEvent();

  @override
  List<Object> get props => [];
}

class TagPageLoadEvent extends TagPageEvent {
  final String tag;

  TagPageLoadEvent({required this.tag});

  @override
  List<Object> get props => [tag];
}
