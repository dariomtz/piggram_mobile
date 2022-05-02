import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggram_mobile/data/post.dart';
import 'package:piggram_mobile/data/user.dart';
import 'package:piggram_mobile/pages/comment_page/bloc/comments_bloc.dart';
import 'package:piggram_mobile/pages/comment_page/comment_page.dart';
import 'package:piggram_mobile/pages/main/home_page/bloc/home_page_bloc.dart';
import 'package:piggram_mobile/pages/main/home_page/like/bloc/like_bloc.dart';
import 'package:piggram_mobile/pages/other_user_profile/bloc/other_user_profile_bloc.dart';
import 'package:piggram_mobile/pages/other_user_profile/other_user_profile.dart';

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
                return PostList(
                  posts: state.posts,
                  likes: state.likes,
                );
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
  final List<List<UserData>> likes;
  const PostList({Key? key, required this.posts, required this.likes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> posts = [];
    for (var i = 0; i < this.posts.length; i++) {
      posts.add(Post(post: this.posts[i], likes: this.likes[i]));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: posts,
    );
  }
}

class Post extends StatelessWidget {
  final PostData post;
  List<UserData> likes;
  Post({Key? key, required this.post, required this.likes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Column(
        children: [
          PostHead(post: post),
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
                          this.likes = state.likes;
                          this.post.liked = !(this.post.liked!);
                        }
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: 50,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: this.likes.length,
                                  itemBuilder: (context, ind) =>
                                      CircularIcon(user: likes[ind]))),
                          GestureDetector(
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
                              text: '${this.likes.length}',
                              color: (this.post.liked!) ? Colors.blue : null,
                            ),
                          ),
                        ],
                      );
                    },
                    listener: (context, state) {}),
                GestureDetector(
                  onTap: () {
                    BlocProvider.of<CommentsBloc>(context)
                        .add(CommentsLoadEvent(this.post.id!));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) =>
                                CommentPage(post: this.post))));
                  },
                  child: PostActionButton(
                    icon: Icons.comment,
                    text: '',
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PostHead extends StatelessWidget {
  const PostHead({
    Key? key,
    required this.post,
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
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Center(child: Image.network(post.image)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(post.description),
        ),
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
    return TextButton(
      onPressed: () {
        BlocProvider.of<OtherUserProfileBloc>(context)
            .add(OtherUserProfileLoad(userId: userId));
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
