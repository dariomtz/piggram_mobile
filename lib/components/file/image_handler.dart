import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:piggram_mobile/components/file/bloc/file_bloc.dart';

class ImageHandeler extends StatelessWidget {
  const ImageHandeler({
    Key? key,
    required this.onLoaded,
  }) : super(key: key);

  final Function(Uint8List) onLoaded;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<FileBloc, FileState>(
          builder: (context, state) {
            if (state is FileInitial) {
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(117, 39, 39, 39),
                  ),
                  constraints: const BoxConstraints.expand(),
                  child: const Center(
                    child: Text(
                      "No image found",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            }
            if (state is FileImageFound) {
              onLoaded(state.image);
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: GestureDetector(
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) => ImageDialog(
                            image: state.image,
                          )),
                  child: SingleChildScrollView(
                    child: Image.memory(
                      state.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }
            if (state is FileUploading) {
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(117, 39, 39, 39),
                  ),
                  constraints: const BoxConstraints.expand(),
                  child: const Center(
                    child: Text(
                      "Uploading",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            }
            return AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(117, 39, 39, 39),
                ),
                constraints: const BoxConstraints.expand(),
                child: const Center(
                  child: Text(
                    "...",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<FileBloc>(context)
                      .add(FileGetImageEvent(ImageSource.camera));
                },
                child: Text("Take photo"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<FileBloc>(context)
                      .add(FileGetImageEvent(ImageSource.gallery));
                },
                child: Text("Search photo"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ImageDialog extends StatelessWidget {
  final Uint8List image;
  const ImageDialog({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Image.memory(
        this.image,
        fit: BoxFit.cover,
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('ok'))
      ],
    );
  }
}
