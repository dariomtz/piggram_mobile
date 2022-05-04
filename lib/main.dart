import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggram_mobile/pages/auth/bloc/auth_bloc.dart';
import 'package:piggram_mobile/pages/auth/first_sign_in.dart';
import 'package:piggram_mobile/pages/auth/login_page.dart';
import 'package:piggram_mobile/pages/follows/bloc/follows_bloc.dart';
import 'package:piggram_mobile/pages/comment_page/bloc/comments_bloc.dart';
import 'package:piggram_mobile/pages/main/create_post_page/bloc/post_bloc.dart';
import 'package:piggram_mobile/pages/main/create_post_page/file/bloc/file_bloc.dart';
import 'package:piggram_mobile/pages/main/home_page/bloc/home_page_bloc.dart';
import 'package:piggram_mobile/pages/main/home_page/like/bloc/like_bloc.dart';
import 'package:piggram_mobile/pages/main/home_page/share/bloc/share_bloc.dart';
import 'package:piggram_mobile/pages/main/menu.dart';
import 'package:piggram_mobile/pages/main/profile_page/bloc/profile_page_bloc.dart';
import 'package:piggram_mobile/pages/main/search_page/bloc/search_page_bloc.dart';
import 'package:piggram_mobile/pages/other_user_profile/bloc/other_user_profile_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => ProfilePageBloc()..add(ProfilePageGetProfileEvent()),
    ),
    BlocProvider(
      create: (context) => HomePageBloc()..add(HomePageLoadEvent()),
    ),
    BlocProvider(create: (context) => SearchPageBloc()),
    BlocProvider(create: (context) => AuthBloc()..add(AuthVerifySignInEvent())),
    BlocProvider(create: (context) => FileBloc()),
    BlocProvider(create: (context) => PostBloc()),
    BlocProvider(create: (context) => OtherUserProfileBloc()),
    BlocProvider(create: (context) => LikeBloc()),
    BlocProvider(create: (context) => FollowsBloc()),
    BlocProvider(create: (context) => CommentsBloc()),
    BlocProvider(create: (context) => ShareBloc()),
  ], child: const MyApp()));
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'PigGram',
        home: BlocConsumer<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthUnsignedInState ||
                state is AuthFirebaseErrorState) {
              return LoginPage();
            }
            if (state is AuthSignedInState) {
              return Menu();
            }
            if (state is AuthFirstSignInState) {
              return FirstSignIn(
                name: state.name,
                username: state.username,
                dateOfBirth: state.dateOfBirth,
                description: state.description,
                image: state.image,
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
          listener: (context, state) {
            if (state is AuthFirebaseErrorState) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
            }
          },
        ));
  }
}
