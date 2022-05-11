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

class SearchPageUserResultState extends SearchPageState {
  final List<UserData> users;

  SearchPageUserResultState({required this.users});

  @override
  List<Object> get props => [users];
}

class SearchPageHashtagResultState extends SearchPageState {
  final List<String> tags;

  SearchPageHashtagResultState({required this.tags});

  @override
  List<Object> get props => [tags];
}
