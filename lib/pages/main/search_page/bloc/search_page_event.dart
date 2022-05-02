part of 'search_page_bloc.dart';

abstract class SearchPageEvent extends Equatable {
  const SearchPageEvent();

  @override
  List<Object> get props => [];
}

class SearchPageSearchEvent extends SearchPageEvent {
  final String nameQuery;

  SearchPageSearchEvent({required this.nameQuery});
  @override
  List<Object> get props => [nameQuery];
}
