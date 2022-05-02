import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:piggram_mobile/data/post.dart';
import 'package:piggram_mobile/utils/post_requests.dart';

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
      var posts = await PostRequests.getPosts();
      emit(HomePageLoadedState(posts: posts));
    } catch (e) {
      print(e);
      emit(HomePageErrorState());
    }
  }
}
