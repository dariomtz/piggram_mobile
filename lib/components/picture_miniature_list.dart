import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggram_mobile/components/like/bloc/like_bloc.dart';
import 'package:piggram_mobile/data/post.dart';
import 'package:piggram_mobile/pages/comment_page/bloc/comments_bloc.dart';
import 'package:piggram_mobile/pages/comment_page/comment_page.dart';

class PictureMiniatureList extends StatelessWidget {
  final List<PostData> posts;
  const PictureMiniatureList({
    Key? key,
    required this.posts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Icon(
                Icons.no_photography_rounded,
                size: 90,
              ),
            ),
            Text(
              "No posts",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      );
    }

    List<Widget> column = [];
    List<Widget> row = [];
    for (var i = 0; i < posts.length; i++) {
      row.add(PictureMiniature(post: posts[i]));
      if (i % 3 == 2 || i == posts.length - 1) {
        column.add(
          Row(
            children: row,
          ),
        );
        row = [];
      }
    }

    return Column(
      children: column,
    );
  }
}

class PictureMiniature extends StatelessWidget {
  final PostData post;
  const PictureMiniature({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => CommentPage(
                  post: this.post,
                  likes: [],
                  liked: false,
                )),
          ),
        );
        BlocProvider.of<LikeBloc>(context).add(LikeRefreshEvent(this.post.id!));
        BlocProvider.of<CommentsBloc>(context)
            .add(CommentsLoadEvent(this.post.id!));
      },
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.white, width: 1)),
        child: Image.network(
          post.image,
          width: MediaQuery.of(context).size.width * 0.327,
          height: MediaQuery.of(context).size.width * 0.327,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class ProfileStat extends StatelessWidget {
  final int num;
  final String name;
  const ProfileStat({
    Key? key,
    required this.num,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            num.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(name),
        ],
      ),
    );
  }
}
