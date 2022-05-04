import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:piggram_mobile/data/post.dart';
import 'package:piggram_mobile/data/user.dart';
import 'package:piggram_mobile/utils/likes_requests.dart';
import 'package:piggram_mobile/utils/post_requests.dart';
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
      List<PostData> posts = await PostRequests.getPosts();
      List<List<UserData>> likes = [];
      List<bool> likeds = [];
      for (var post in posts) {
        var likespost = await LikesRequests.getByPostId(post.id);
        likes.add((await LikesRequests.getUsersfromList(likespost)));
        likeds.add((await LikesRequests.exist(
            post.id!, FirebaseAuth.instance.currentUser!.uid)));
      }

      emit(HomePageLoadedState(posts: posts, likes: likes, likeds: likeds));
    } catch (e) {
      print(e);
      emit(HomePageErrorState());
    }
  }
}
