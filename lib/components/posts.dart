import 'package:flutter/material.dart';
import 'package:piggram_mobile/pages/comment_page/bloc/comments_bloc.dart';
import 'package:piggram_mobile/pages/comment_page/comment_page.dart';
import 'package:piggram_mobile/components/like/bloc/like_bloc.dart';
import 'package:piggram_mobile/components/share/bloc/share_bloc.dart';
import 'package:piggram_mobile/pages/liked_by/liked_by_page.dart';
import 'package:piggram_mobile/pages/other_user_profile/bloc/other_user_profile_bloc.dart';
import 'package:piggram_mobile/pages/other_user_profile/other_user_profile.dart';
import 'package:piggram_mobile/data/post.dart';
import 'package:piggram_mobile/data/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';

class Post extends StatefulWidget {
  final PostData post;
  final List<UserData> likes;
  final bool liked;
  final bool showComment;
  Post(
      {Key? key,
      required this.post,
      required this.likes,
      required this.liked,
      this.showComment = true})
      : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  late List<UserData> likes;
  late bool liked;

  @override
  void initState() {
    likes = widget.likes;
    liked = widget.liked;
    super.initState();
  }

  final ScreenshotController controller = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PostHead(
          post: widget.post,
          controller: controller,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BlocListener<LikeBloc, LikeState>(
              listener: (context, state) {
                if (state is LikeDoneState) {
                  if (this.widget.post.id == state.postId) {
                    setState(() {
                      likes = state.likes;
                      liked = state.liked;
                    });
                  }
                }
              },
              child: IconButton(
                onPressed: () {
                  BlocProvider.of<LikeBloc>(context).add(LikeChangeEvent(
                      postId: this.widget.post.id!, liked: !liked));
                },
                icon: Icon((liked) ? Icons.favorite : Icons.favorite_outline),
                color: (liked) ? Colors.red : null,
              ),
            ),
            if (this.widget.showComment)
              IconButton(
                onPressed: () {
                  BlocProvider.of<CommentsBloc>(context)
                      .add(CommentsLoadEvent(this.widget.post.id!));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => CommentPage(
                          post: this.widget.post,
                          liked: widget.liked,
                          likes: likes)),
                    ),
                  );
                },
                icon: Icon(Icons.comment),
              ),
            IconButton(
              onPressed: () {
                BlocProvider.of<ShareBloc>(context).add(
                    ShareSendEvent(post: widget.post, controller: controller));
              },
              icon: Icon(Icons.share),
            ),
            Text("Liked by "),
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => LikedByPage(users: likes)))),
              child: Text(
                "${likes.length} ${likes.length == 1 ? "person" : "people"}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Comment(
            userId: widget.post.userId,
            username: widget.post.user!.username,
            text: widget.post.description),
        Divider(),
      ],
    );
  }
}

class PostHead extends StatelessWidget {
  final ScreenshotController controller;
  PostHead({
    Key? key,
    required this.post,
    required this.controller,
  }) : super(key: key);

  final PostData post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserCard(
          userImageURL: post.user!.photoUrl,
          userName: post.user!.username,
          userId: post.userId,
        ),
        Center(
            child: Screenshot(
                controller: controller, child: Image.network(post.image))),
      ],
    );
  }
}

class CircularIcon extends StatelessWidget {
  const CircularIcon({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserData user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(this.user.photoUrl),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final String userImageURL, userName, userId;
  const UserCard(
      {Key? key,
      required this.userImageURL,
      required this.userName,
      required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<OtherUserProfileBloc>(context)
            .add(OtherUserProfileLoad(userId: userId));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => OtherUserProfile(
                      username: userName,
                    ))));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            userImageURL != ""
                ? CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(userImageURL),
                  )
                : Icon(
                    Icons.person,
                    size: 40,
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                userName,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
