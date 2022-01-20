import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';

class PostJob extends StatefulWidget {
  PostJob({Key? key, required this.title, required this.currentUid}) : super(key: key);

  final String title;
  final String currentUid;

  @override
  _PostJobState createState() => _PostJobState();
}

class _PostJobState extends State<PostJob> {
  var titleEditingController = TextEditingController();
  var descriptionEditingController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference ref = FirebaseDatabase.instance.reference();

  // getCurrentUser() async {
  //   final User? user = await _auth.currentUser;
  //   final uid = user!.uid;
  //   // Similarly we can get email as well
  //   //final uemail = user.email;
  //   print(uid);
  //   //print(uemail);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10),
              child: TextField(
                controller: titleEditingController,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: TextField(
                controller: descriptionEditingController,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
              ),
            ),
            Container(
              width: 200,
              margin: EdgeInsets.only(top: 5),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blueAccent)
                ),
                child: Text("Post"),
                onPressed: () {
                  print(titleEditingController.text.toString());
                  print(descriptionEditingController.text.toString());
                  final User? user = _auth.currentUser;
                  final uid = user!.uid;
                  final jobId = new DateTime.now().millisecondsSinceEpoch.toString();

                  // post a job in the database
                  ref.child("jobs/"+
                      jobId).set({
                    "employerId": uid,
                    "title": titleEditingController.text.toString(),
                    "description": descriptionEditingController.text.toString()
                  }).then((res) {
                    print(
                        "Successfully posted a job in the database.");
                  }).catchError((e) {
                    print(
                        "Failed to post a job in the database.");
                  });
                  ref.child("employers/" + uid + "/jobs/" + jobId).set({
                    "title": titleEditingController.text.toString(),
                    "jobId": jobId
                  }).then((res) {
                    print(
                        "Successfully posted a job in the database.");
                  }).catchError((e) {
                    print(
                        "Failed to post a job in the database.");
                  });

                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}