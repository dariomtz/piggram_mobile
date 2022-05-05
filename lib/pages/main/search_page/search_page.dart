import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggram_mobile/data/user.dart';
import 'package:piggram_mobile/pages/other_user_profile/bloc/other_user_profile_bloc.dart';
import 'package:piggram_mobile/pages/other_user_profile/other_user_profile.dart';

import 'bloc/search_page_bloc.dart';

class SearchPage extends StatelessWidget {
  final _nameController = TextEditingController();
  SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: TextField(
            onChanged: (value) => BlocProvider.of<SearchPageBloc>(context)
                .add(SearchPageSearchEvent(nameQuery: _nameController.text)),
            decoration: InputDecoration(
              fillColor: Colors.white,
              hintText: "Insert username",
              prefixIcon: Icon(Icons.search),
            ),
            controller: _nameController,
          ),
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
            return Container();
          }
          if (state is SearchPageResultState) {
            return SearchResultList(users: state.users);
          }
          return Center(child: Text("Something went wrong try again"));
        },
      ),
    ]);
  }
}

class SearchResultList extends StatelessWidget {
  final List<UserData> users;
  const SearchResultList({
    Key? key,
    required this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: users
          .map((user) => UserCardItem(
                user: user,
              ))
          .toList(),
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
