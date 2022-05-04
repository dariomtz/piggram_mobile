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
  static List<String> appbarTitles = [
    'FoodShare',
    'New post',
    'Search',
    'My profile',
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
        title: Text(appbarTitles.elementAt(_selectedIndex)),
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
