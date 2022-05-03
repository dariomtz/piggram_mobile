import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggram_mobile/pages/main/profile_page/profile_page.dart';
import 'package:piggram_mobile/pages/other_user_profile/bloc/other_user_profile_bloc.dart';

class OtherUserProfile extends StatelessWidget {
  const OtherUserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<OtherUserProfileBloc, OtherUserProfileState>(
        builder: (context, state) {
          if (state is OtherUserProfileLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is OtherUserProfileLoadingFollow) {
            return Profile(
                actions: [Center(child: CircularProgressIndicator())],
                profileData: state.profileData);
          } else if (state is OtherUserProfileLoaded) {
            return Profile(actions: [
              state.follow
                  ? OutlinedButton(
                      onPressed: (() =>
                          BlocProvider.of<OtherUserProfileBloc>(context).add(
                              OtherUserProfileFollow(
                                  profile: state.profileData, follow: false))),
                      child: Text("Unfollow"))
                  : ElevatedButton(
                      onPressed: (() =>
                          BlocProvider.of<OtherUserProfileBloc>(context).add(
                              OtherUserProfileFollow(
                                  profile: state.profileData, follow: true))),
                      child: Text("Follow"))
            ], profileData: state.profileData);
          }
          return Text('Something went wrong');
        },
      ),
    );
  }
}
