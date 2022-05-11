import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggram_mobile/components/like/bloc/mode_bloc.dart';
import 'package:piggram_mobile/components/profile.dart';
import 'package:piggram_mobile/pages/auth/bloc/auth_bloc.dart';
import 'package:piggram_mobile/pages/main/profile_page/bloc/profile_page_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  static List<String> modes = [
    'burger',
    'salad',
    'fast-food',
    'diet',
    'taco',
  ];

  static Map<String, String> mode_titles = {
    'burger': "Burger",
    'salad': "Vegan",
    'fast-food': "Combo",
    'diet': "Diet",
    'taco': "Taco",
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePageBloc, ProfilePageState>(
      builder: (context, state) {
        if (state is ProfilePageLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is ProfilePageLoadingModeState) {
          return Profile(profileData: state.profileData, actions: [
            Center(
              child: CircularProgressIndicator(),
            )
          ]);
        }
        if (state is ProfilePageLoadedState) {
          return Profile(
            actions: [
              ElevatedButton.icon(
                  icon: Image.asset(
                    "assets/${state.profileData.user.mode}.png",
                    height: 25,
                    width: 25,
                  ),
                  onPressed: () {
                    var nextMode = modes[
                        (modes.indexOf(state.profileData.user.mode) + 1) %
                            modes.length];
                    BlocProvider.of<ModeBloc>(context)
                        .add(ModeUpdateEvent(mode: nextMode));
                    BlocProvider.of<ProfilePageBloc>(context).add(
                        ProfilePageUpdateModeEvent(
                            mode: nextMode, profile: state.profileData));
                  },
                  label:
                      Text("${mode_titles[state.profileData.user.mode]} mode")),
              ElevatedButton.icon(
                onPressed: () =>
                    BlocProvider.of<AuthBloc>(context).add(AuthSignOutEvent()),
                label: Text("Sign out"),
                icon: Icon(Icons.logout),
              ),
            ],
            profileData: state.profileData,
          );
        }
        if (state is ProfilePageErrorState) {
          return Center(
            child: Text("Something went wrong try it again"),
          );
        }
        return Center(
          child: Text("Welcome to your profile"),
        );
      },
    );
  }
}
