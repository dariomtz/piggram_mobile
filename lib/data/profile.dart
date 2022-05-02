import 'package:flutter/material.dart';
import 'package:piggram_mobile/data/user.dart';

@immutable
class ProfileData {
  final UserData user;
  // $$$TODO: Change to post instead of map
  final List<Map<String, dynamic>> posts;
  final int followers, following;

  ProfileData(
      {required this.user,
      required this.posts,
      required this.followers,
      required this.following});
}
