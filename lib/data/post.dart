import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggram_mobile/data/user.dart';

class PostData {
  final String? id;
  UserData? user;
  final String description, image, userId;
  final DateTime publishedAt;
  final List<dynamic> tags;

  PostData(
      {this.id,
      required this.publishedAt,
      required this.description,
      required this.image,
      required this.tags,
      required this.userId});
  PostData.fromJson(Map<String, Object?> json)
      : this(
            id: json["id"] != null ? json["id"] as String : '',
            description: json["description"] as String,
            image: json["image"] as String,
            userId: json["userId"] as String,
            publishedAt: (json["publishedAt"] as Timestamp).toDate(),
            tags:
                json.containsKey("tags") ? json["tags"] as List<dynamic> : []);
  Map<String, Object?> toJson() => {
        "description": description,
        "image": image,
        "userId": userId,
        "publishedAt": Timestamp.fromDate(publishedAt),
        "tags": tags,
      };
}
