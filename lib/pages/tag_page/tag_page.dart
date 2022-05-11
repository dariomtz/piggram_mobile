import 'package:flutter/material.dart';

class TagPage extends StatelessWidget {
  final String tag;
  const TagPage({Key? key, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("#$tag"),
      ),
      body: Center(
        child: Text(tag),
      ),
    );
  }
}
