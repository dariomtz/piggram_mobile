import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class LikeData {
  final String postId, userId, id;

  LikeData({required this.postId, required this.userId, required this.id});

  LikeData.fromJson(Map<String, Object?> json)
      : this(
            id: json["id"] as String,
            postId: json["postId"]! as String,
            userId: json["userId"]! as String);

  Map<String, Object?> toJson() {
    return {postId: postId, userId: userId};
  }
}
