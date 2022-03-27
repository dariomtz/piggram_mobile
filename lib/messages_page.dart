import 'package:flutter/material.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        MessagePreview(
          name: "Dario Martinez",
          lastMessage: "hahaha nice pankakes",
        ),
        MessagePreview(
          name: "Miguel Gonzalez",
          lastMessage: "I hate pankakes",
        ),
        MessagePreview(
          name: "Tarik Celis",
          lastMessage: "We got pankes on our hands",
        ),
        MessagePreview(
          name: "Shrek",
          lastMessage: "Pankakes are like onions dude",
        ),
        MessagePreview(
          name: "Karl Ramos",
          lastMessage: "I miss tacos",
        ),
        MessagePreview(
          name: "Nataly Salazar",
          lastMessage: "Lets go for chilaquiles!",
        ),
        MessagePreview(
          name: "Tom Holland",
          lastMessage: "Nah dude I have never eaten tortas ahogadas",
        ),
        MessagePreview(
          name: "Peter Parker",
          lastMessage: "yo this lady gave me a burrito LMAO",
        ),
      ],
    );
  }
}

class MessagePreview extends StatelessWidget {
  final String name;
  final String lastMessage;
  const MessagePreview({
    Key? key,
    required this.name,
    required this.lastMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
      child: Row(
        children: [
          Icon(
            Icons.person,
            size: 80,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Text(lastMessage)
            ],
          )
        ],
      ),
    );
  }
}
