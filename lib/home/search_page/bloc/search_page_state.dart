part of 'search_page_bloc.dart';

abstract class SearchPageState extends Equatable {
  const SearchPageState();

  @override
  List<Object> get props => [];
}

class SearchPageInitial extends SearchPageState {}

class SearchPageLoadingState extends SearchPageState {}

class SearchPageEmptyState extends SearchPageState {}

class SearchPageErrorState extends SearchPageState {}

class SearchPageResultState extends SearchPageState {
  final List<Map<String, dynamic>> users;

  SearchPageResultState({required this.users});

  @override
  List<Object> get props => [users];
}
