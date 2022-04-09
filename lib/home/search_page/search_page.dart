import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/search_page_bloc.dart';

class SearchPage extends StatelessWidget {
  final _nameController = TextEditingController();
  SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      TextField(
        decoration: InputDecoration(
            hintText: "Insert username",
            prefixIcon: IconButton(
              constraints: BoxConstraints.expand(width: 40, height: 40),
              icon: Icon(Icons.search),
              onPressed: () {
                BlocProvider.of<SearchPageBloc>(context).add(
                    SearchPageSearchEvent(nameQuery: _nameController.text));
              },
            )),
        controller: _nameController,
      ),
      BlocConsumer<SearchPageBloc, SearchPageState>(
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
          listener: (context, state) {})
    ]);
  }
}

class SearchResultList extends StatelessWidget {
  final List<Map<String, dynamic>> users;
  const SearchResultList({
    Key? key,
    required this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: users
          .map((user) =>
              SearchResultItem(username: user["username"], name: user["name"]))
          .toList(),
    );
  }
}

class SearchResultItem extends StatelessWidget {
  final String username;
  final String name;
  const SearchResultItem({
    Key? key,
    required this.username,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.person,
              size: 40,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Text(username)
            ],
          )
        ],
      ),
    );
  }
}
