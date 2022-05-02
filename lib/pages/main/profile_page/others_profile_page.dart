import 'package:flutter/material.dart';
import 'package:piggram_mobile/data/profile.dart';
import 'package:piggram_mobile/pages/main/profile_page/profile_page.dart';

class OtherUserProfilePage extends StatelessWidget {
  final ProfileData profileData;
  const OtherUserProfilePage({Key? key, required this.profileData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Profile(
        profileData: profileData,
      ),
    );
  }
}
