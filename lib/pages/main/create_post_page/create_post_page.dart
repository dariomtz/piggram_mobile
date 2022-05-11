import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggram_mobile/pages/main/create_post_page/bloc/post_bloc.dart';
import 'package:piggram_mobile/components/file/bloc/file_bloc.dart';
import 'package:piggram_mobile/components/file/image_handler.dart';

class CreatePostPage extends StatefulWidget {
  CreatePostPage({Key? key}) : super(key: key);

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  Uint8List? image;

  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          ImageHandeler(
            onLoaded: (image) {
              this.image = image;
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLines: 8,
              controller: _descriptionController,
              decoration: InputDecoration(
                fillColor: Colors.white,
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
            style: ElevatedButton.styleFrom(primary: Colors.red),
          ),
          BlocConsumer<PostBloc, PostState>(
            builder: (context, state) {
              return Container();
            },
            listener: (context, state) {
              if (state is PostUploadedState) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text("Post Uploaded")));
                BlocProvider.of<FileBloc>(context).add(FileCleanEvent());
                this.image = null;
                this._descriptionController.text = '';
              }
              if (state is PostErrorState) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
          )
        ],
      ),
    );
  }
}
