import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../utils/file_requests.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInitial()) {
    on<PostSubmitEvent>(_onSubmit);
  }

  FutureOr<void> _onSubmit(
      PostSubmitEvent event, Emitter<PostState> emit) async {
    try {
      String? url = await FileRequests.uploadImage(event.image);
      if (url == null) {
        emit(PostErrorState("Unable to upload the image"));
        return;
      }
      await FirebaseFirestore.instance.collection("post").add({
        "description": event.description,
        "image": url,
        "likes": 0,
        "publishedAt": DateTime.now().millisecondsSinceEpoch,
        "userId": FirebaseAuth.instance.currentUser!.uid
      });
      emit(PostUploadedState());
      emit(PostInitial());
    } catch (err) {
      emit(PostErrorState("Something went wrong"));
    }
  }
}
