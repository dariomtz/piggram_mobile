import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggram_mobile/file/bloc/image_handler.dart';
import 'package:piggram_mobile/home/Post_page/bloc/post_bloc.dart';

class PostPage extends StatelessWidget {
  PostPage({Key? key}) : super(key: key);
  Uint8List? image;
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Post")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ImageHandeler(
              image: this.image,
              onLoaded: (image) {
                this.image = image;
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  filled: true,
                  hintText: "Insert description",
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                try {
                  BlocProvider.of<PostBloc>(context).add(PostSubmitEvent(
                      description: _descriptionController.text,
                      image: this.image!));
                } catch (err) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                        SnackBar(content: Text("Not all fields are filled")));
                }
              },
              child: Text('Create'),
            ),
            BlocConsumer<PostBloc, PostState>(builder: (context, state) {
              return Container();
            }, listener: (context, state) {
              if (state is PostUploadedState) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text("Post Uploaded")));
                Navigator.of(context).pop();
              }
              if (state is PostErrorState) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(state.error)));
              }
            })
          ],
        ),
      ),
    );
  }
}
