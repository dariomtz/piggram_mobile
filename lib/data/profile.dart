import 'package:flutter/material.dart';
import 'package:piggram_mobile/data/follow.dart';
import 'package:piggram_mobile/data/post.dart';
import 'package:piggram_mobile/data/user.dart';

@immutable
class ProfileData {
  final String id;
  final UserData user;
  final List<PostData> posts;
  final List<FollowData> followers, following;

  ProfileData(
      {required this.user,
      required this.posts,
      required this.followers,
      required this.following,
      required this.id});
}
