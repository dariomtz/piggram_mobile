import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class UserData {
  final String displayName, photoUrl, username, description, mode;
  final DateTime creationTimestamp, dateOfBirth;

  const UserData({
    required this.displayName,
    required this.description,
    required this.photoUrl,
    required this.creationTimestamp,
    required this.dateOfBirth,
    required this.username,
    required this.mode,
  });

  UserData.fromJson(Map<String, Object?> json)
      : this(
          displayName: json["name"]! as String,
          photoUrl: json["image"]! as String,
          username: json["username"]! as String,
          description: json["description"]! as String,
          creationTimestamp: (json["creationTimestamp"]! as Timestamp).toDate(),
          dateOfBirth: (json["dateOfBirth"]! as Timestamp).toDate(),
          mode: json.containsKey("mode") ? json["mode"]! as String : "burger",
        );

  Map<String, Object?> toJson() {
    return {
      "name": displayName,
      "image": photoUrl,
      "username": username,
      "description": description,
      "creationTimestamp": Timestamp.fromDate(creationTimestamp),
      "dateOfBirth": Timestamp.fromDate(dateOfBirth),
      "mode": mode,
    };
  }

  UserData.changeMode(UserData user, String newMode)
      : this(
            creationTimestamp: user.creationTimestamp,
            displayName: user.displayName,
            username: user.username,
            photoUrl: user.photoUrl,
            description: user.description,
            dateOfBirth: user.dateOfBirth,
            mode: newMode);
}
