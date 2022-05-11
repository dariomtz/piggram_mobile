import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggram_mobile/components/profile.dart';
import 'package:piggram_mobile/pages/main/profile_page/profile_page.dart';
import 'package:piggram_mobile/pages/other_user_profile/bloc/other_user_profile_bloc.dart';
import 'package:piggram_mobile/utils/auth_requests.dart';

class OtherUserProfile extends StatelessWidget {
  final String username;
  const OtherUserProfile({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
        elevation: 0.0,
      ),
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
            if (state.profileData.id == AuthRequests.currentUserId()) {
              return ProfilePage();
            }
            return Profile(actions: [
              state.follow
                  ? OutlinedButton.icon(
                      icon: Icon(Icons.person_remove),
                      onPressed: (() =>
                          BlocProvider.of<OtherUserProfileBloc>(context).add(
                              OtherUserProfileFollow(
                                  profile: state.profileData, follow: false))),
                      label: Text("Unfollow"))
                  : ElevatedButton.icon(
                      icon: Icon(Icons.person_add),
                      onPressed: (() =>
                          BlocProvider.of<OtherUserProfileBloc>(context).add(
                              OtherUserProfileFollow(
                                  profile: state.profileData, follow: true))),
                      label: Text("Follow"))
            ], profileData: state.profileData);
          }
          return Text('Something went wrong');
        },
      ),
    );
  }
}
