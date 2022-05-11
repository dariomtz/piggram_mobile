import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:piggram_mobile/data/user.dart';
import 'package:piggram_mobile/utils/auth_requests.dart';
import 'package:piggram_mobile/utils/user_requests.dart';

part 'mode_event.dart';
part 'mode_state.dart';

class ModeBloc extends Bloc<ModeEvent, ModeState> {
  ModeBloc() : super(ModeInitial()) {
    on<ModeLoadEvent>(_loadMode);
    on<ModeUpdateEvent>((_updateMode));
  }

  _updateMode(event, emit) {
    emit(ModeLoaded(mode: event.mode));
  }

  FutureOr<void> _loadMode(event, emit) async {
    emit(ModeLoading());
    try {
      DocumentSnapshot<UserData> documentSnapshot =
          await UserRequests.findById(AuthRequests.currentUserId());
      UserData user = await documentSnapshot.data()!;
      emit(ModeLoaded(mode: user.mode));
    } catch (e) {
      print(e);
      emit(ModeError());
    }
  }
}
