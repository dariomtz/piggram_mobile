import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggram_mobile/auth/bloc/auth_bloc.dart';
import 'package:piggram_mobile/home/home_page/bloc/home_page_bloc.dart';

import 'package:piggram_mobile/home/home_page/home_page.dart';
import 'package:piggram_mobile/home/messages_page/messages_page.dart';
import 'package:piggram_mobile/home/profile_page/bloc/profile_page_bloc.dart';
import 'package:piggram_mobile/home/profile_page/profile_page.dart';
import 'package:piggram_mobile/home/search_page/search_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    MessagesPage(),
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
        title: const Text('PigGram'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(AuthSignOutEvent());
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
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
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
