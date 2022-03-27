import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.person,
                size: 90,
              ),
            ),
            ProfileStat(
              num: 123,
              name: 'Posts',
            ),
            ProfileStat(
              num: 456,
              name: 'Followers',
            ),
            ProfileStat(
              num: 789,
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
                'Dario Martinez',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                '@dariongo',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
              ),
              Text(
                  'Hi my name is Dario and I love tacos. Follow me if you love tacos too!'),
            ],
          ),
        ),
        Row(
          children: [
            PictureMiniature(
              url:
                  'https://www.pequerecetas.com/wp-content/uploads/2020/10/tacos-mexicanos.jpg',
            ),
            PictureMiniature(
              url:
                  'https://www.pequerecetas.com/wp-content/uploads/2020/10/tacos-mexicanos.jpg',
            ),
            PictureMiniature(
              url:
                  'https://www.pequerecetas.com/wp-content/uploads/2020/10/tacos-mexicanos.jpg',
            ),
          ],
        ),
        Row(
          children: [
            PictureMiniature(
              url:
                  'https://www.pequerecetas.com/wp-content/uploads/2020/10/tacos-mexicanos.jpg',
            ),
            PictureMiniature(
              url:
                  'https://www.pequerecetas.com/wp-content/uploads/2020/10/tacos-mexicanos.jpg',
            ),
            PictureMiniature(
              url:
                  'https://www.pequerecetas.com/wp-content/uploads/2020/10/tacos-mexicanos.jpg',
            ),
          ],
        ),
        Row(
          children: [
            PictureMiniature(
              url:
                  'https://www.pequerecetas.com/wp-content/uploads/2020/10/tacos-mexicanos.jpg',
            ),
          ],
        ),
      ],
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
