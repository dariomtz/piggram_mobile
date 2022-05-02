import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggram_mobile/home/profile_page/profile_page.dart';
import 'package:piggram_mobile/other_user_profile/bloc/other_user_profile_bloc.dart';

class OtherUserProfile extends StatelessWidget {
  const OtherUserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<OtherUserProfileBloc, OtherUserProfileState>(
        builder: (context, state) {
          if (state is OtherUserProfileError) {
            return Text('Something went wrong');
          }

          if (state is OtherUserProfileLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is OtherUserProfileLoaded) {
            return Profile(profileData: state.profileData);
          }
          return Text('hello');
        },
      ),
    );
  }
}
