import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggram_mobile/pages/main/create_post_page/create_post_page.dart';
import 'package:piggram_mobile/pages/main/home_page/bloc/home_page_bloc.dart';
import 'package:piggram_mobile/pages/main/home_page/home_page.dart';
import 'package:piggram_mobile/pages/main/profile_page/bloc/profile_page_bloc.dart';
import 'package:piggram_mobile/pages/main/profile_page/profile_page.dart';
import 'package:piggram_mobile/pages/main/search_page/search_page.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MenuState extends State<Menu> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    CreatePostPage(),
    SearchPage(),
    ProfilePage(),
  ];
  static dynamic _calls = [
    (context) {
      BlocProvider.of<HomePageBloc>(context).add(HomePageLoadEvent());
    },
    (context) {},
    (context) {},
    (context) {
      BlocProvider.of<ProfilePageBloc>(context)
          .add(ProfilePageGetProfileEvent());
    }
  ];

  List<Widget> appbarTitles = [
    AppBarTitle(word1: "Food", word2: "Share"),
    AppBarTitle(word1: "New", word2: "Post"),
    AppBarTitle(word1: "", word2: "Search"),
    AppBarTitle(word1: "My", word2: "Profile"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _calls[index](context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: appbarTitles.elementAt(_selectedIndex),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'New Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class AppBarTitle extends StatelessWidget {
  final String word1, word2;
  const AppBarTitle({Key? key, required this.word1, required this.word2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(word1),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/app_icon.png",
            height: 30,
            width: 30,
          ),
        ),
        Text(word2),
      ],
    );
  }
}
