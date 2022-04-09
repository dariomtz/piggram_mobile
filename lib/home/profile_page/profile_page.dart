import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggram_mobile/home/profile_page/bloc/profile_page_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfilePageBloc, ProfilePageState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ProfilePageLoadingState) {
          return CircularProgressIndicator();
        }
        if (state is ProfilePageLoadedState) {
          return Profile(
            name: state.user["name"],
            usename: state.user["username"],
            description: state.user["description"],
            posts: state.posts,
            followers: state.user["followers"],
            following: state.user["following"],
            image: state.user["image"],
            postsCount: state.user["posts"],
          );
        }
        if (state is ProfilePageErrorState) {
          return Center(
            child: Text("Something went wrong try it again"),
          );
        }
        return Center(
          child: Text("Welcome to your profile"),
        );
      },
    );
  }
}

class Profile extends StatelessWidget {
  final String name, usename, description, image;
  final int postsCount, followers, following;
  final List<Map<String, dynamic>> posts;
  const Profile({
    Key? key,
    required this.name,
    required this.usename,
    required this.description,
    required this.image,
    required this.postsCount,
    required this.followers,
    required this.following,
    required this.posts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: image != ""
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(image),
                    )
                  : Icon(
                      Icons.person,
                      size: 90,
                    ),
            ),
            ProfileStat(
              num: postsCount,
              name: 'Posts',
            ),
            ProfileStat(
              num: followers,
              name: 'Followers',
            ),
            ProfileStat(
              num: following,
              name: 'Following',
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                '@' + usename,
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
              ),
              Text(description),
            ],
          ),
        ),
        PictureMiniatureList(
          posts: posts,
        ),
      ],
    );
  }
}

class PictureMiniatureList extends StatelessWidget {
  final List<Map<String, dynamic>> posts;
  const PictureMiniatureList({
    Key? key,
    required this.posts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> column = [];
    List<Widget> row = [];
    for (var i = 0; i < posts.length; i++) {
      if (i % 3 == 0) {
        if (row.isNotEmpty) {
          column.add(
            Row(
              children: row,
            ),
          );
        }
        row = [];
      }
      row.add(PictureMiniature(url: posts[i]["image"]));
    }
    if (row.isNotEmpty) {
      column.add(
        Row(
          children: row,
        ),
      );
    }
    return Column(
      children: column,
    );
  }
}

class PictureMiniature extends StatelessWidget {
  final String url;
  const PictureMiniature({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: Colors.white, width: 1)),
      child: Image.network(
        url,
        width: MediaQuery.of(context).size.width * 0.327,
        height: MediaQuery.of(context).size.width * 0.327,
        fit: BoxFit.cover,
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
