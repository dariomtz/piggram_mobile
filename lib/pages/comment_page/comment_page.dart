import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggram_mobile/data/post.dart';
import 'package:piggram_mobile/data/user.dart';
import 'package:piggram_mobile/pages/comment_page/bloc/comments_bloc.dart';
import 'package:piggram_mobile/components/posts.dart';
import 'package:piggram_mobile/pages/other_user_profile/bloc/other_user_profile_bloc.dart';
import 'package:piggram_mobile/pages/other_user_profile/other_user_profile.dart';

class CommentPage extends StatefulWidget {
  final PostData post;
  final List<UserData> likes;
  final bool liked;
  CommentPage(
      {Key? key, required this.post, required this.likes, required this.liked})
      : super(key: key);
  final TextEditingController _commentController = TextEditingController();
  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        elevation: 0,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: BlocConsumer<CommentsBloc, CommentsState>(
          builder: (context, state) {
            if (state is CommentsLoadingState) {
              return ListView(
                children: [
                  Post(
                    post: this.widget.post,
                    likes: widget.likes,
                    liked: widget.liked,
                    showComment: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                ],
              );
            }
            if (state is CommentsLoadedState) {
              return ListView(
                children: [
                  Post(
                    post: this.widget.post,
                    likes: widget.likes,
                    liked: widget.liked,
                    showComment: false,
                  ),
                  ...state.comments.map(
                    (comment) => Comment(
                      userId: comment.userId,
                      username: comment.user!.username,
                      text: comment.description,
                    ),
                  ),
                ],
              );
            }
            return Container();
          },
          listener: (context, state) {
            if (state is CommentsCreatedState) {
              widget._commentController.text = '';
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text("Comment created")));
            }
          },
        ),
      ),
      bottomSheet: CreateComment(
        postId: widget.post.id!,
        controller: widget._commentController,
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String userId, username, text;
  const Comment(
      {Key? key,
      required this.userId,
      required this.username,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                BlocProvider.of<OtherUserProfileBloc>(context)
                    .add(OtherUserProfileLoad(userId: userId));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => OtherUserProfile(
                              username: username,
                            ))));
              },
              child: Text(
                username,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Flexible(child: Text(text)),
        ],
      ),
    );
  }
}

class CreateComment extends StatelessWidget {
  final String postId;
  final TextEditingController controller;
  const CreateComment(
      {Key? key, required this.postId, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.red,
        child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  BlocProvider.of<CommentsBloc>(context).add(
                      CommentsCreateEvent(
                          postId: postId, comment: controller.text));
                },
                icon: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8),
                    labelText: "Comment",
                    filled: true,
                    hintText: "Insert your comment",
                  ),
                ),
              )
            ]));
  }
}
