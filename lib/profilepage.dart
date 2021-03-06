import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
// import 'package:camera/camera.dart';
// import 'package:new_job_app/take_picture_page.dart';



class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {

  var userProfile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    FirebaseDatabase.instance.ref().child("interviewees/" + uid).once()
        .then((ds) {
      print(ds.snapshot.value);
      userProfile = ds.snapshot.value;
      setState(() {
      });
    }).catchError((error) {
      FirebaseDatabase.instance.ref().child("employers/" + uid).once()
          .then((ds) {
        print(ds.snapshot.value);
        userProfile = ds.snapshot.value;
        setState(() {
        });
      }).catchError((error) {
        print("Failed to get the user information.");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              child: GestureDetector(
                onTap: () async {
                  // final cameras = await availableCameras();
                  // final firstCamera = cameras.first;

                  // final result = await Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => TakePictureScreen(camera: firstCamera)),
                  // );

                  // userProfile['image'] = result;
                  setState(() {
                    FirebaseDatabase.instance.ref().child("interviewees/" + userProfile['uid'])
                        .set(userProfile).then((value) {
                      print("Updated the user profile");
                    }).catchError((error) {
                      print("Failed to update the user profile");
                    });
                  });
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(userProfile['image'] == null ? 'https://www.clipartmax.com/png/middle/171-1717870_stockvader-predicted-cron-for-may-user-profile-icon-png.png' : userProfile['image']),
                ),
              ),
            ),
            Text('Name: ${userProfile['name']}'),
            Text('Email: ${userProfile['email']}'),
            Text('Phone: ${userProfile['phone']}'),
          ],
        ),
      ),
    );
  }
}