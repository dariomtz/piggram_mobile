part of 'search_page_bloc.dart';

abstract class SearchPageEvent extends Equatable {
  const SearchPageEvent();

  @override
  List<Object> get props => [];
}

class SearchPageSearchUserEvent extends SearchPageEvent {
  final String nameQuery;

  SearchPageSearchUserEvent({required this.nameQuery});
  @override
  List<Object> get props => [nameQuery];
}

class SearchPageSearchHashtagEvent extends SearchPageEvent {
  final String tagQuery;

  SearchPageSearchHashtagEvent({required this.tagQuery});
  @override
  List<Object> get props => [tagQuery];
}

class SearchPageCleanEvent extends SearchPageEvent {}
