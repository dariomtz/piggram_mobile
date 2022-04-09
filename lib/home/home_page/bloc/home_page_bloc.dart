import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

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
        var userdoc = await FirebaseFirestore.instance
            .collection("user")
            .doc(post["userId"])
            .get();
        post["user"] = userdoc.data();
      }

      emit(HomePageLoadedState(posts: posts));
    } catch (e) {
      emit(HomePageErrorState());
    }
  }
}
