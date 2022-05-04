import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggram_mobile/data/post.dart';
import 'package:piggram_mobile/data/user.dart';
import 'package:piggram_mobile/components/posts.dart';
import 'package:piggram_mobile/pages/main/home_page/bloc/home_page_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        BlocBuilder<HomePageBloc, HomePageState>(
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
                likeds: state.likeds,
              );
            }
            return Container();
          },
        ),
      ],
    );
  }
}

class PostList extends StatelessWidget {
  final List<PostData> posts;
  final List<List<UserData>> likes;
  final List<bool> likeds;
  const PostList(
      {Key? key,
      required this.posts,
      required this.likes,
      required this.likeds})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> posts = [];
    for (var i = 0; i < this.posts.length; i++) {
      posts.add(Post(
          post: this.posts[i], likes: this.likes[i], liked: this.likeds[i]));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: posts,
    );
  }
}
