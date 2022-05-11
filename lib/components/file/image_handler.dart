import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:piggram_mobile/components/file/bloc/file_bloc.dart';

class ImageHandeler extends StatelessWidget {
  ImageHandeler({
    Key? key,
    required this.onLoaded,
    this.initials = false,
    this.name = "",
  }) : super(key: key);

  final bool initials;
  final String name;
  final Function(Uint8List) onLoaded;

  @override
  Widget build(BuildContext context) {
    print(name);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<FileBloc, FileState>(
          builder: (context, state) {
            if (state is FileInitial) {
              return GestureDetector(
                onTap: () => showDialog(
                    context: context,
                    builder: (context) => ImageOptionsDialog(
                          name: name,
                          initials: initials,
                        )),
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(117, 39, 39, 39),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    constraints: const BoxConstraints.expand(),
                    child: const Center(
                        child: Icon(
                      Icons.add_a_photo,
                      color: Colors.white,
                      size: 50,
                    )),
                  ),
                ),
              );
            }
            if (state is FileImageFound) {
              onLoaded(state.image);
              return AspectRatio(
                aspectRatio: 1 / 1,
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
                aspectRatio: 1 / 1,
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
              BlocProvider.of<FileBloc>(context).add(FileCleanEvent());
              Navigator.of(context).pop();
            },
            child: Text('Discard')),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Keep'))
      ],
    );
  }
}

class ImageOptionsDialog extends StatelessWidget {
  final String name;
  final bool initials;
  const ImageOptionsDialog(
      {Key? key, required this.name, required this.initials})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Upload a foto'),
      content: Text("Choose an upload option"),
      actions: [
        if (initials)
          Tooltip(
            message: "You can only use this once you have written your name",
            child: TextButton(
              onPressed: name == ""
                  ? null
                  : () {
                      BlocProvider.of<FileBloc>(context)
                          .add(FileGetInitialsEvent(name));
                      Navigator.of(context).pop();
                    },
              child: Text('Initials'),
            ),
          ),
        TextButton(
            onPressed: () {
              BlocProvider.of<FileBloc>(context)
                  .add(FileGetImageEvent(ImageSource.camera));
              Navigator.of(context).pop();
            },
            child: Text('Camera')),
        TextButton(
            onPressed: () {
              BlocProvider.of<FileBloc>(context)
                  .add(FileGetImageEvent(ImageSource.gallery));
              Navigator.of(context).pop();
            },
            child: Text('Gallery')),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'))
      ],
    );
  }
}
