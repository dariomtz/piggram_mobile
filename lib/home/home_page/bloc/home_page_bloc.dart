import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggram_mobile/utils/user_requests.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(HomePageInitial()) {
    on<HomePageLoadEvent>(_load);
  }

  FutureOr<void> _load(
      HomePageLoadEvent event, Emitter<HomePageState> emit) async {
    emit(HomePageLoadingState());
    try {
      var postDocs =
          await FirebaseFirestore.instance.collection("post").limit(10).get();
      var posts = postDocs.docs.map((doc) => doc.data()).toList();
      for (var post in posts) {
        var userdoc = await UserRequests.findById(post["userId"]);
        post["user"] = userdoc.data();
      }

      emit(HomePageLoadedState(posts: posts));
    } catch (e) {
      emit(HomePageErrorState());
    }
  }
}
