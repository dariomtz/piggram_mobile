import 'package:flutter/material.dart';
import 'package:piggram_mobile/home/profile_page/profile_page.dart';

class OtherUserProfilePage extends StatelessWidget {
  const OtherUserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Profile(
          name: name,
          usename: usename,
          description: description,
          image: image,
          postsCount: postsCount,
          followers: followers,
          following: following,
          posts: posts),
    );
  }
}
