import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:piggram_mobile/utils/likes_requests.dart';
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
      var posts = postDocs.docs.map((doc) {
        var t = doc.data();
        t["id"] = doc.id;
        return t;
      }).toList();
      for (var post in posts) {
        //Get data of post user owner
        var userdoc = await FirebaseFirestore.instance
            .collection("user")
            .doc(post["userId"])
            .get();
        post["user"] = userdoc.data();

        //Get likes of post
        var liked = await LikesRequests.find(
            post["id"], FirebaseAuth.instance.currentUser!.uid);
        var likes = await LikesRequests.getByPostId(post["id"]);
        post["likes"] = likes;

        post["liked"] = liked != null;
        //Get list of comments
        var commentsDocs = await FirebaseFirestore.instance
            .collection("comment")
            .where("postId", isEqualTo: post["id"])
            .get();

        //Get user info of each comment
        var comments = commentsDocs.docs.map((doc) async {
          var comment = doc.data();
          comment["user"] = await UserRequests.findById(comment["userId"]);
          return comment;
        });
        post["comments"] = comments.toList();
      }

      emit(HomePageLoadedState(posts: posts));
    } catch (e) {
      emit(HomePageErrorState());
    }
  }
}
