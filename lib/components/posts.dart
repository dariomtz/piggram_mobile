import 'package:flutter/material.dart';
import 'package:piggram_mobile/pages/comment_page/bloc/comments_bloc.dart';
import 'package:piggram_mobile/pages/comment_page/comment_page.dart';
import 'package:piggram_mobile/components/like/bloc/like_bloc.dart';
import 'package:piggram_mobile/components/share/bloc/share_bloc.dart';
import 'package:piggram_mobile/pages/other_user_profile/bloc/other_user_profile_bloc.dart';
import 'package:piggram_mobile/pages/other_user_profile/other_user_profile.dart';
import 'package:piggram_mobile/data/post.dart';
import 'package:piggram_mobile/data/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';

class Post extends StatefulWidget {
  final PostData post;
  List<UserData> likes;
  bool liked;
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BlocBuilder<LikeBloc, LikeState>(
                builder: (context, state) {
                  if (state is LikeDoneState) {
                    if (this.widget.post.id == state.postId) {
                      this.widget.likes = state.likes;
                      this.widget.liked = state.liked;
                    }
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // SizedBox(
                      //     width: MediaQuery.of(context).size.width * 0.5,
                      //     height: 50,
                      //     child: ListView.builder(
                      //         scrollDirection: Axis.horizontal,
                      //         itemCount: this.widget.likes.length,
                      //         itemBuilder: (context, ind) =>
                      //             CircularIcon(user: widget.likes[ind]))),
                      GestureDetector(
                        onTap: () {
                          if (this.widget.liked == true) {
                            BlocProvider.of<LikeBloc>(context)
                                .add(LikeRemoveEvent(this.widget.post.id!));
                          } else {
                            BlocProvider.of<LikeBloc>(context)
                                .add(LikeAddEvent(this.widget.post.id!));
                          }
                        },
                        child: PostActionButton(
                          icon: Icons.favorite,
                          text: '${this.widget.likes.length}',
                          color: (this.widget.liked) ? Colors.red : null,
                        ),
                      ),
                    ],
                  );
                },
              ),
              this.widget.showComment
                  ? GestureDetector(
                      onTap: () {
                        BlocProvider.of<CommentsBloc>(context)
                            .add(CommentsLoadEvent(this.widget.post.id!));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => CommentPage(
                                post: this.widget.post,
                                liked: widget.liked,
                                likes: this.widget.likes)),
                          ),
                        );
                      },
                      child: PostActionButton(
                        icon: Icons.comment,
                        text: '',
                      ),
                    )
                  : Container(),
              GestureDetector(
                onTap: () {
                  BlocProvider.of<ShareBloc>(context).add(ShareSendEvent(
                      post: widget.post, controller: controller));
                },
                child: PostActionButton(
                  icon: Icons.share,
                  text: '',
                ),
              ),
            ],
          ),
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

class PostActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;
  const PostActionButton({
    Key? key,
    required this.icon,
    required this.text,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 30,
          ),
          Text(text)
        ],
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
