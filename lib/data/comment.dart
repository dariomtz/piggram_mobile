import 'package:cloud_firestore/cloud_firestore.dart';

class CommentData {
  final String description, postId, userId;
  final String? id;
  final DateTime publishedAt;

  CommentData(
      {required this.description,
      required this.postId,
      this.id,
      required this.userId,
      required this.publishedAt});

  CommentData.fromJson(Map<String, Object?> json)
      : this(
            id: json["id"] as String,
            description: json["description"] as String,
            postId: json["postId"] as String,
            publishedAt: (json["publishedAt"] as Timestamp).toDate(),
            userId: json["userId"] as String);
  Map<String, Object?> toJson() => {
        "description": description,
        "postId": postId,
        "publishedAt": Timestamp.fromDate(publishedAt),
        "userId": userId
      };
}
