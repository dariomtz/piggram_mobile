import 'package:flutter/material.dart';
import 'package:piggram_mobile/data/user.dart';
import 'package:piggram_mobile/pages/follows/follows_page.dart';

class LikedByPage extends StatelessWidget {
  final List<UserData> users;
  const LikedByPage({Key? key, required this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liked by"),
      ),
      body: ListView(children: transformToWidgets(users)),
    );
  }
}
