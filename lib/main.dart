import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggram_mobile/auth/bloc/auth_bloc.dart';
import 'package:piggram_mobile/file/bloc/file_bloc.dart';
import 'package:piggram_mobile/home/Post_page/bloc/post_bloc.dart';
import 'package:piggram_mobile/home/home_page/bloc/home_page_bloc.dart';
import 'package:piggram_mobile/home/profile_page/bloc/profile_page_bloc.dart';
import 'package:piggram_mobile/home/search_page/bloc/search_page_bloc.dart';
import 'package:piggram_mobile/login/first_sign_in.dart';
import 'package:piggram_mobile/login/login_page.dart';

import 'home/home.dart';

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
    BlocProvider(create: (context) => PostBloc())
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
              return Home();
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
