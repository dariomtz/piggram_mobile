import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      TextField(
        decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
      ),
      SearchResultItem(
        name: 'Dario Martinez',
        username: 'dariongo',
      ),
      SearchResultItem(
        name: 'Dario Fernandez',
        username: 'dario',
      ),
      SearchResultItem(
        name: 'Dario Gomez',
        username: 'dario_g',
      ),
    ]);
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
