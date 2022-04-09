import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Post(),
        Post(),
      ],
    );
  }
}

class Post extends StatelessWidget {
  const Post({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  size: 40,
                ),
                Text(
                  'dariongo',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Image.network(
              'https://www.pequerecetas.com/wp-content/uploads/2020/10/tacos-mexicanos.jpg'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                PostActionButton(
                  icon: Icons.thumb_up,
                ),
                PostActionButton(
                  icon: Icons.thumb_down,
                ),
                PostActionButton(
                  icon: Icons.comment,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PostActionButton extends StatelessWidget {
  final IconData icon;
  const PostActionButton({
    Key? key,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Icon(
        icon,
        size: 30,
      ),
    );
  }
}
