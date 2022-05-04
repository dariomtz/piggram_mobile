import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggram_mobile/data/post.dart';
import 'package:piggram_mobile/data/profile.dart';
import 'package:piggram_mobile/pages/auth/bloc/auth_bloc.dart';
import 'package:piggram_mobile/pages/comment_page/bloc/comments_bloc.dart';
import 'package:piggram_mobile/pages/comment_page/comment_page.dart';
import 'package:piggram_mobile/pages/follows/bloc/follows_bloc.dart';
import 'package:piggram_mobile/pages/follows/follows_page.dart';
import 'package:piggram_mobile/components/like/bloc/like_bloc.dart';
import 'package:piggram_mobile/pages/main/profile_page/bloc/profile_page_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePageBloc, ProfilePageState>(
      builder: (context, state) {
        if (state is ProfilePageLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is ProfilePageLoadedState) {
          return Profile(
            actions: [
              ElevatedButton.icon(
                onPressed: () =>
                    BlocProvider.of<AuthBloc>(context).add(AuthSignOutEvent()),
                label: Text("Sign out"),
                icon: Icon(Icons.logout),
              )
            ],
            profileData: state.profileData,
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
  final List<Widget> actions;
  final ProfileData profileData;
  const Profile({
    Key? key,
    required this.profileData,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            children: [
              Row(children: [
                Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(profileData.user.photoUrl),
                    )),
                ProfileStat(
                  num: profileData.posts.length,
                  name: 'Posts',
                ),
                GestureDetector(
                  onTap: () {
                    BlocProvider.of<FollowsBloc>(context).add(FollowsLoad(
                        followers: profileData.followers,
                        following: profileData.following));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => FollowsPage(
                                  username: profileData.user.username,
                                  showFollowers: true,
                                ))));
                  },
                  child: ProfileStat(
                    num: profileData.followers.length,
                    name: 'Followers',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    BlocProvider.of<FollowsBloc>(context).add(FollowsLoad(
                        followers: profileData.followers,
                        following: profileData.following));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => FollowsPage(
                                username: profileData.user.username,
                                showFollowers: false))));
                  },
                  child: ProfileStat(
                    num: profileData.following.length,
                    name: 'Following',
                  ),
                ),
              ]),
              Padding(
                padding:
                    const EdgeInsets.only(left: 6.0, right: 6.0, bottom: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profileData.user.displayName,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      '@' + profileData.user.username,
                      style:
                          TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
                    ),
                    Text(profileData.user.description),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          children: actions
              .map((w) => Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: w,
                  )))
              .toList(),
        ),
        PictureMiniatureList(
          posts: profileData.posts,
        ),
      ],
    );
  }
}

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
        child: Text("There are no post to show"),
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
