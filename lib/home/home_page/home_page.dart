import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggram_mobile/home/home_page/bloc/home_page_bloc.dart';
import 'package:piggram_mobile/like/bloc/like_bloc.dart';

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
  final List<Map<String, dynamic>> posts;
  const PostList({
    Key? key,
    required this.posts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> posts = this
        .posts
        .map(
          (post) => Post(
              liked: post["liked"],
              postid: post["id"],
              comments: post["comments"],
              likes: post["likes"],
              username: post["user"]["name"],
              userimage: post["user"]["image"],
              image: post["image"],
              description: post["description"]),
        )
        .toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: posts,
    );
  }
}

class Post extends StatelessWidget {
  final String username, userimage, image, description, postid;
  bool liked;
  List<dynamic> likes, comments;
  Post(
      {Key? key,
      required this.username,
      required this.userimage,
      required this.description,
      required this.image,
      required this.comments,
      required this.likes,
      required this.postid,
      required this.liked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            color: Color.fromARGB(50, 100, 100, 100),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      userimage != ""
                          ? CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(userimage),
                            )
                          : Icon(
                              Icons.person,
                              size: 90,
                            ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          username,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.star_border),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Image.network(image),
          ),
          Divider(),
          Text(description),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BlocConsumer<LikeBloc, LikeState>(
                    builder: (context, state) {
                      if (state is LikeDoneState) {
                        if (this.postid == state.postId) {
                          this.likes = state.likes;
                          this.liked = !this.liked;
                        }
                      }
                      return GestureDetector(
                        onTap: () {
                          if (this.liked) {
                            BlocProvider.of<LikeBloc>(context)
                                .add(LikeRemoveEvent(this.postid));
                          } else {
                            BlocProvider.of<LikeBloc>(context)
                                .add(LikeAddEvent(this.postid));
                          }
                        },
                        child: PostActionButton(
                          icon: Icons.thumb_up,
                          count: this.likes.length,
                          color: this.liked ? Colors.blue : null,
                        ),
                      );
                    },
                    listener: (context, state) {}),
                PostActionButton(
                  icon: Icons.comment,
                  count: comments.length,
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
