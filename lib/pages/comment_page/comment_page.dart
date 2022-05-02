import 'package:flutter/material.dart';
import 'package:piggram_mobile/data/post.dart';

class CommentPage extends StatefulWidget {
  final PostData post;
  CommentPage({Key? key, required this.post}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(),
    );
  }
}
