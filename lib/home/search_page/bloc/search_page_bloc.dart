import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:piggram_mobile/data/user.dart';
import 'package:piggram_mobile/utils/user_requests.dart';

part 'search_page_event.dart';
part 'search_page_state.dart';

class SearchPageBloc extends Bloc<SearchPageEvent, SearchPageState> {
  SearchPageBloc() : super(SearchPageInitial()) {
    on<SearchPageSearchEvent>(_search);
  }

  FutureOr<void> _search(
      SearchPageSearchEvent event, Emitter<SearchPageState> emit) async {
    //finds the users with username or name that starts with name given like query
    emit(SearchPageLoadingState());
    try {
      List<UserData> _users = await UserRequests.searchUser(event.nameQuery);
      if (_users.isEmpty) {
        emit(SearchPageEmptyState());
      } else {
        emit(SearchPageResultState(users: _users));
      }
    } catch (e) {
      emit(SearchPageErrorState());
    }
  }
}
