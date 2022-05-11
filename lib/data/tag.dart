import 'package:flutter/material.dart';

@immutable
class TagData {
  final String name;

  TagData({required this.name});

  TagData.fromJson(Map<String, Object?> json)
      : this(name: json["name"]! as String);

  Map<String, Object?> toJson() {
    return {
      "name": name,
    };
  }
}
