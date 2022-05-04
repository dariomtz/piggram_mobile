import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggram_mobile/data/user.dart';

class PostData {
  final String? id;
  UserData? user;
  final String description, image, userId;
  final DateTime publishedAt;

  PostData(
      {this.id,
      required this.publishedAt,
      required this.description,
      required this.image,
      required this.userId});
  PostData.fromJson(Map<String, Object?> json)
      : this(
            id: json["id"] != null ? json["id"] as String : '',
            description: json["description"] as String,
            image: json["image"] as String,
            userId: json["userId"] as String,
            publishedAt: (json["publishedAt"] as Timestamp).toDate());
  Map<String, Object?> toJson() => {
        "description": description,
        "image": image,
        "userId": userId,
        "publishedAt": Timestamp.fromDate(publishedAt)
      };
}
