import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggram_mobile/data/user.dart';
import 'package:piggram_mobile/pages/follows/bloc/follows_bloc.dart';
import 'package:piggram_mobile/pages/main/search_page/search_page.dart';

class FollowsPage extends StatefulWidget {
  final String username;
  final bool showFollowers;
  const FollowsPage(
      {Key? key, required this.showFollowers, required this.username})
      : super(key: key);

  @override
  State<FollowsPage> createState() => _FollowsPageState();
}

class _FollowsPageState extends State<FollowsPage> {
  late bool showFollowers;

  @override
  void initState() {
    showFollowers = widget.showFollowers;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> topBar = [
      Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: (() => setState(() {
                    showFollowers = true;
                  })),
              child: Text(
                "Followers",
                style: TextStyle(
                    color: !showFollowers ? Colors.grey : Colors.black,
                    fontSize: 20),
              ),
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: (() => setState(() {
                    showFollowers = false;
                  })),
              child: Text(
                "Following",
                style: TextStyle(
                    color: showFollowers ? Colors.grey : Colors.black,
                    fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username),
      ),
      body: BlocBuilder<FollowsBloc, FollowsState>(
        builder: ((context, state) {
          if (state is FollowsLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is FollowsLoaded) {
            return ListView(
              children: showFollowers
                  ? [...topBar, ...transformToWidgets(state.followers)]
                  : [...topBar, ...transformToWidgets(state.following)],
            );
          }
          return Text('Something went wrong');
        }),
      ),
    );
  }
}

List<Widget> transformToWidgets(List<UserData> users) {
  if (users.isEmpty) {
    return [
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Icon(
          Icons.person,
          size: 90,
        ),
      ),
      Center(
          child: Text('There arent any users on this list',
              style: TextStyle(
                fontSize: 20,
              ))),
    ];
  }
  return users.map((user) => UserCardItem(user: user)).toList();
}
