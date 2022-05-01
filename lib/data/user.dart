import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class UserData {
  final String displayName, photoUrl, username, description;
  final DateTime creationTimestamp, dateOfBirth;

  const UserData({
    required this.displayName,
    required this.description,
    required this.photoUrl,
    required this.creationTimestamp,
    required this.dateOfBirth,
    required this.username,
  });

  UserData.fromJson(Map<String, Object?> json)
      : this(
          displayName: json["name"]! as String,
          photoUrl: json["image"]! as String,
          username: json["username"]! as String,
          description: json["description"]! as String,
          creationTimestamp: (json["creationTimestamp"]! as Timestamp).toDate(),
          dateOfBirth: (json["dateOfBirth"]! as Timestamp).toDate(),
        );

  Map<String, Object?> toJson() {
    return {
      "name": displayName,
      "image": photoUrl,
      "username": username,
      "description": description,
      "creationTimestamp": Timestamp.fromDate(creationTimestamp),
      "dateOfBirth": Timestamp.fromDate(dateOfBirth),
    };
  }
}
