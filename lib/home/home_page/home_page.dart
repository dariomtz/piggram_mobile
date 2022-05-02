import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggram_mobile/data/like.dart';
import 'package:piggram_mobile/data/post.dart';
import 'package:piggram_mobile/home/home_page/bloc/home_page_bloc.dart';
import 'package:piggram_mobile/like/bloc/like_bloc.dart';
import 'package:piggram_mobile/other_user_profile/bloc/other_user_profile_bloc.dart';
import 'package:piggram_mobile/other_user_profile/other_user_profile.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        BlocConsumer<HomePageBloc, HomePageState>(
            builder: (context, state) {
              if (state is HomePageLoadingState) {
                return Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (state is HomePageErrorState) {
                return Center(child: Text('Something went wrong try again'));
              }
              if (state is HomePageLoadedState) {
                return PostList(posts: state.posts);
              }
              return Container();
            },
            listener: (context, state) {})
      ],
    );
  }
}

class PostList extends StatelessWidget {
  final List<PostData> posts;
  const PostList({
    Key? key,
    required this.posts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> posts = this
        .posts
        .map(
          (post) => Post(post: post),
        )
        .toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: posts,
    );
  }
}

class Post extends StatelessWidget {
  final PostData post;
  Post({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Column(
        children: [
          UserCard(
            userImageURL: post.user!.photoUrl,
            userName: post.user!.username,
            userId: post.userId,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Image.network(post.image),
          ),
          Divider(),
          Text(post.description),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BlocConsumer<LikeBloc, LikeState>(
                    builder: (context, state) {
                      if (state is LikeDoneState) {
                        if (this.post.id == state.postId) {
                          this.post.likes = state.likes;
                          this.post.liked = !(this.post.liked!);
                        }
                      }
                      return GestureDetector(
                        onTap: () {
                          if (this.post.liked!) {
                            BlocProvider.of<LikeBloc>(context)
                                .add(LikeRemoveEvent(this.post.id!));
                          } else {
                            BlocProvider.of<LikeBloc>(context)
                                .add(LikeAddEvent(this.post.id!));
                          }
                        },
                        child: PostActionButton(
                          icon: Icons.thumb_up,
                          count: this.post.likes!.length,
                          color: (this.post.liked!) ? Colors.blue : null,
                        ),
                      );
                    },
                    listener: (context, state) {}),
                PostActionButton(
                  icon: Icons.comment,
                  count: post.comments!.length,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PostActionButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color? color;
  const PostActionButton({
    Key? key,
    required this.icon,
    required this.count,
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
          Text('$count')
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
    return TextButton(
      onPressed: () {
        BlocProvider.of<OtherUserProfileBloc>(context)
            .add(OtherUserProfileLoadEvent(userId: userId));
        Navigator.push(context,
            MaterialPageRoute(builder: ((context) => OtherUserProfile())));
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
