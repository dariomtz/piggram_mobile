import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:piggram_mobile/data/user.dart';
import 'package:piggram_mobile/utils/post_requests.dart';
import 'package:piggram_mobile/utils/user_requests.dart';

part 'search_page_event.dart';
part 'search_page_state.dart';

class SearchPageBloc extends Bloc<SearchPageEvent, SearchPageState> {
  SearchPageBloc() : super(SearchPageInitial()) {
    on<SearchPageSearchUserEvent>(_searchUsers);
    on<SearchPageSearchHashtagEvent>(_searchHashtags);
    on<SearchPageCleanEvent>(_clean);
  }

  FutureOr<void> _searchUsers(
      SearchPageSearchUserEvent event, Emitter<SearchPageState> emit) async {
    //finds the users with username or name that starts with name given like query
    emit(SearchPageLoadingState());
    try {
      List<UserData> _users = await UserRequests.searchUser(event.nameQuery);
      if (_users.isEmpty) {
        emit(SearchPageEmptyState());
      } else {
        emit(SearchPageUserResultState(users: _users));
      }
    } catch (e) {
      emit(SearchPageErrorState());
    }
  }

  FutureOr<void> _searchHashtags(
      SearchPageSearchHashtagEvent event, Emitter<SearchPageState> emit) async {
    //finds the users with username or name that starts with name given like query
    emit(SearchPageLoadingState());
    try {
      List<String> _tags = await PostRequests.searchTag(event.tagQuery);
      if (_tags.isEmpty) {
        emit(SearchPageEmptyState());
      } else {
        emit(SearchPageHashtagResultState(tags: _tags));
      }
    } catch (e) {
      emit(SearchPageErrorState());
    }
  }

  Future<void> _clean(
      SearchPageCleanEvent event, Emitter<SearchPageState> emit) async {
    emit(SearchPageInitial());
  }
}
