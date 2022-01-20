import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<SignupPage> {

  bool _checkbox = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference ref = FirebaseDatabase.instance.reference();

  var emailEditingController = TextEditingController();
  var nameEditingController = TextEditingController();
  var passwordEditingController = TextEditingController();
  var phoneEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10),
              child: TextField(
                controller: emailEditingController,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: TextField(
                controller: passwordEditingController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: TextField(
                controller: nameEditingController,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: TextField(
                controller: phoneEditingController,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone',
                ),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: _checkbox,
                  onChanged: (value) {
                    setState(() {
                      _checkbox = !_checkbox;
                    });
                  },
                ),
                Text('I am an employer'),
              ],
            ),
            Container(
              width: 200,
              margin: EdgeInsets.only(top: 5),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blueAccent)
                ),
                child: Text("Sign Up"),
                onPressed: () {
                  print(emailEditingController.text.toString());
                  print(nameEditingController.text.toString());
                  print(passwordEditingController.text.toString());

                  _auth.createUserWithEmailAndPassword(
                    email: emailEditingController.text.toString(),
                    password: passwordEditingController.text.toString())
                    .then((value) {
                      print("Successfully signed up! " + value.user!.uid);

                      // Create a user in the database
                      if(!_checkbox) {
                        ref.child("interviewees/" + value.user!.uid).set({
                          "name": nameEditingController.text.toString(),
                          "email": emailEditingController.text.toString(),
                          "phone": phoneEditingController.text.toString()
                        }).then((res) {
                          print(
                              "Successfully created an interviewee in the database.");
                        }).catchError((e) {
                          print(
                              "Failed to create an interviewee in the database.");
                        });
                      }
                      else{
                        ref.child("employers/" + value.user!.uid).set({
                          "name": nameEditingController.text.toString()
                        }).then((res) {
                          print(
                              "Successfully created an employer in the database.");
                        }).catchError((e) {
                          print(
                              "Failed to create an employer in the database.");
                        });
                      }

                      passwordEditingController.text = "";
                      Navigator.pushReplacementNamed(context, "/homepage");
                    }).catchError((e) {
                      print("Failed to sign up! " + e.toString());
                    });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}