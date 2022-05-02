import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:piggram_mobile/data/profile.dart';
import 'package:piggram_mobile/utils/user_requests.dart';

part 'other_user_profile_event.dart';
part 'other_user_profile_state.dart';

class OtherUserProfileBloc
    extends Bloc<OtherUserProfileEvent, OtherUserProfileState> {
  OtherUserProfileBloc() : super(OtherUserProfileInitial()) {
    on<OtherUserProfileLoadEvent>(loadProfile);
  }

  Future<void> loadProfile(OtherUserProfileLoadEvent event, emit) async {
    emit(OtherUserProfileLoading());
    try {
      ProfileData data = await UserRequests.getProfile(event.userId);

      emit(OtherUserProfileLoaded(profileData: data));
    } catch (e) {
      print(e);
      emit(OtherUserProfileError());
    }
  }
}
