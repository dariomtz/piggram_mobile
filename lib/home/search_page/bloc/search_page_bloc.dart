import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

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
      //find by name
      var _docs = await FirebaseFirestore.instance
          .collection("user")
          .where("name", isGreaterThan: event.nameQuery)
          .where("name", isLessThan: event.nameQuery + '\uf8ff')
          .get();
      var _users = _docs.docs.map((doc) => doc.data()).toList();

      var _userset = _users.map((e) => e["username"]).toSet();

      //find by username
      _docs = await FirebaseFirestore.instance
          .collection("user")
          .where("username", isGreaterThan: event.nameQuery)
          .where("username", isLessThan: event.nameQuery + '\uf8ff')
          .get();

      //join results
      _docs.docs.map((doc) => doc.data()).forEach((doc) {
        if (!_userset.contains(doc["username"])) {
          _users.add(doc);
        }
      });

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
