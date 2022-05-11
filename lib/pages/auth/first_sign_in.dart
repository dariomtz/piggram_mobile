import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:piggram_mobile/pages/auth/bloc/auth_bloc.dart';
import 'package:piggram_mobile/components/file/image_handler.dart';

class FirstSignIn extends StatefulWidget {
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
  State<FirstSignIn> createState() => _FirstSignInState();
}

class _FirstSignInState extends State<FirstSignIn> {
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  late DateTime? dateOfBirth;
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    dateOfBirth = this.widget.dateOfBirth;
    _nameController = TextEditingController(text: this.widget.name);
    _usernameController = TextEditingController(text: this.widget.username);
    _descriptionController =
        TextEditingController(text: this.widget.description);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Complete Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ImageHandeler(
                initials: true,
                name: _nameController.text,
                onLoaded: (img) {
                  this.widget.image = img;
                }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: ((value) => setState(() {})),
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
            if (dateOfBirth != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text(formatter.format(dateOfBirth!))),
              ),
            ElevatedButton.icon(
              icon: Icon(Icons.calendar_month),
              onPressed: () async {
                final DateTime? selected = await showDatePicker(
                  context: context,
                  initialDate: dateOfBirth ?? DateTime.now(),
                  firstDate: DateTime(1920),
                  lastDate: DateTime.now(),
                );
                if (selected != null) {
                  setState(() {
                    dateOfBirth = selected;
                  });
                }
              },
              label: Text('${dateOfBirth != null ? "Change" : "Set"} birthday'),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                try {
                  BlocProvider.of<AuthBloc>(context).add(AuthCreateUserEvent(
                      name: _nameController.text,
                      username: _usernameController.text,
                      description: _descriptionController.text,
                      image: this.widget.image!,
                      dateOfBirth: dateOfBirth!));
                } catch (err) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Not all fields are filled")));
                }
              },
              label: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
