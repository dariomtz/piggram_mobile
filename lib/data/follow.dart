import 'package:flutter/material.dart';

@immutable
class FollowData {
  final String followee, follower;

  FollowData({required this.followee, required this.follower});

  FollowData.fromJson(Map<String, Object?> json)
      : this(
          followee: json["followeeId"]! as String,
          follower: json["followerId"]! as String,
        );

  Map<String, Object?> toJson() {
    return {
      "followeeID": followee,
      "followerID": follower,
    };
  }
}
