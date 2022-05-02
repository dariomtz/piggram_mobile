import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:piggram_mobile/utils/file_requests.dart';
import 'package:piggram_mobile/utils/post_requests.dart';

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
      await PostRequests.create(
          description: event.description,
          userId: FirebaseAuth.instance.currentUser!.uid,
          image: url);
      emit(PostUploadedState());
      emit(PostInitial());
    } catch (err) {
      emit(PostErrorState("Something went wrong"));
    }
  }
}
