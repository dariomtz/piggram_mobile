import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggram_mobile/data/user.dart';
import 'package:piggram_mobile/pages/other_user_profile/bloc/other_user_profile_bloc.dart';
import 'package:piggram_mobile/pages/other_user_profile/other_user_profile.dart';
import 'package:piggram_mobile/pages/tag_page/tag_page.dart';

import 'bloc/search_page_bloc.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _nameController;
  late bool userSearch;

  @override
  void initState() {
    _nameController = TextEditingController();
    userSearch = true;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              onChanged: ((value) => executeSearch(context, value, userSearch)),
              decoration: InputDecoration(
                fillColor: Colors.white,
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
              ),
              controller: _nameController,
            ),
            Row(
              children: [
                Expanded(
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            userSearch = true;
                          });
                          executeSearch(context, _nameController.text, true);
                        },
                        child: Text(
                          "Users",
                          style: TextStyle(
                              color: !userSearch ? Colors.grey : Colors.black,
                              fontSize: 20),
                        ))),
                Expanded(
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            userSearch = false;
                          });
                          executeSearch(context, _nameController.text, false);
                        },
                        child: Text(
                          "Hashtags",
                          style: TextStyle(
                              color: userSearch ? Colors.grey : Colors.black,
                              fontSize: 20),
                        ))),
              ],
            )
          ],
        ),
      ),
      BlocBuilder<SearchPageBloc, SearchPageState>(
        builder: (context, state) {
          if (state is SearchPageLoadingState) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is SearchPageEmptyState) {
            return Center(child: Text("No se encontraron resultados"));
          }
          if (state is SearchPageInitial) {
            return Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Center(
                child: Icon(
                  Icons.search,
                  size: 90,
                ),
              ),
            );
          }
          if (state is SearchPageUserResultState) {
            return SearchResultList(
                cards: state.users.map((u) => UserCardItem(user: u)).toList());
          }
          if (state is SearchPageHashtagResultState) {
            return SearchResultList(
                cards: state.tags.map((t) => TagCardItem(tag: t)).toList());
          }

          return Center(child: Text("Something went wrong try again"));
        },
      ),
    ]);
  }
}

class SearchResultList extends StatelessWidget {
  final List<Widget> cards;
  const SearchResultList({
    Key? key,
    required this.cards,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: cards,
    );
  }
}

class UserCardItem extends StatelessWidget {
  final UserData user;
  const UserCardItem({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<OtherUserProfileBloc>(context)
            .add(OtherUserProfileLoadByUsername(username: user.username));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => OtherUserProfile(
                      username: user.username,
                    ))));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    CircleAvatar(backgroundImage: NetworkImage(user.photoUrl)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.displayName,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text("@${user.username}")
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TagCardItem extends StatelessWidget {
  final String tag;
  const TagCardItem({Key? key, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => TagPage(tag: tag)),
          ),
        );
      },
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Center(
          child: Text(
            "#$tag",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
      )),
    );
  }
}

void executeSearch(context, value, user) {
  if (value == "") {
    BlocProvider.of<SearchPageBloc>(context).add(SearchPageCleanEvent());
  } else if (user) {
    BlocProvider.of<SearchPageBloc>(context)
        .add(SearchPageSearchUserEvent(nameQuery: value));
  } else {
    BlocProvider.of<SearchPageBloc>(context)
        .add(SearchPageSearchHashtagEvent(tagQuery: value));
  }
}
