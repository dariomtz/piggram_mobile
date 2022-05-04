import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggram_mobile/pages/auth/bloc/auth_bloc.dart';
import 'package:piggram_mobile/components/file/image_handler.dart';

class FirstSignIn extends StatelessWidget {
  FirstSignIn(
      {Key? key,
      this.image,
      this.name,
      this.username,
      this.description,
      this.dateOfBirth})
      : super(key: key);

  Uint8List? image;
  String? name, username, description;
  DateTime? dateOfBirth;

  @override
  Widget build(BuildContext context) {
    this.dateOfBirth = DateTime.now();
    final _nameController = TextEditingController(text: this.name);
    final _usernameController = TextEditingController(text: this.username);
    final _descriptionController =
        TextEditingController(text: this.description);

    return Scaffold(
      appBar: AppBar(title: Text('Complete Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ImageHandeler(onLoaded: (image) {
              this.image = image;
            }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  filled: true,
                  hintText: "Insert name",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  filled: true,
                  hintText: "Insert username",
                ),
              ),
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
              onPressed: () async {
                final DateTime? selected = await showDatePicker(
                  context: context,
                  initialDate: this.dateOfBirth!,
                  firstDate: DateTime(1920),
                  lastDate: DateTime.now(),
                );
                if (selected != null) {
                  this.dateOfBirth = selected;
                }
              },
              child: Text('Set birthday'),
            ),
            ElevatedButton(
              onPressed: () {
                try {
                  BlocProvider.of<AuthBloc>(context).add(AuthCreateUserEvent(
                      name: _nameController.text,
                      username: _usernameController.text,
                      description: _descriptionController.text,
                      image: image!,
                      dateOfBirth: dateOfBirth!));
                } catch (err) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Not all fields are filled")));
                }
              },
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
