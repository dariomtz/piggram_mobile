import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggram_mobile/data/post.dart';
import 'package:piggram_mobile/data/user.dart';
import 'package:piggram_mobile/pages/comment_page/bloc/comments_bloc.dart';
import 'package:piggram_mobile/pages/main/home_page/home_page.dart';

class CommentPage extends StatefulWidget {
  final PostData post;
  final List<UserData> likes;
  CommentPage({Key? key, required this.post, required this.likes})
      : super(key: key);
  final TextEditingController _commentController = TextEditingController();
  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Comments")),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: BlocConsumer<CommentsBloc, CommentsState>(
            builder: (context, state) {
          if (state is CommentsLoadingState) {
            return ListView(
              children: [
                Card(
                  child: Post(
                    post: this.widget.post,
                    likes: widget.likes,
                    showComment: false,
                  ),
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
                Card(
                  child: Post(
                    post: this.widget.post,
                    likes: widget.likes,
                    showComment: false,
                  ),
                ),
                ...state.comments.map(
                  (comment) => Card(
                    child: Column(
                      children: [
                        UserCard(
                            userId: comment.userId,
                            userImageURL: comment.user!.photoUrl,
                            userName: comment.user!.username),
                        Text(comment.description),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return Container();
        }, listener: (context, state) {
          if (state is CommentsCreatedState) {
            widget._commentController.text = '';
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text("Comment created")));
          }
        }),
      ),
      bottomSheet: CreateComment(
        postId: widget.post.id!,
        controller: widget._commentController,
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
        color: Colors.blue,
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
