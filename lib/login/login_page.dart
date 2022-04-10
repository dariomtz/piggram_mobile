import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggram_mobile/auth/bloc/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: 1,
            heightFactor: 1,
            child: Image.network(
              "https://www.gdlgo.com/wp-content/uploads/2021/07/Los-Mejores-Tacos-de-Guadalajara-.jpg",
              fit: BoxFit.fitHeight,
            ),
          ),
          Container(
            color: Color.fromARGB(200, 0, 0, 0),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Center(
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(170, 255, 255, 255)),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      fillColor: Colors.white70,
                      filled: true,
                      hintText: "Insert email",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    autocorrect: false,
                    enableSuggestions: false,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      fillColor: Colors.white70,
                      filled: true,
                      hintText: "Insert password",
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("Register"),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("Sign In"),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context)
                          .add(AuthSignInGoogleEvent());
                    },
                    child: Text("Sign In with Google")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
