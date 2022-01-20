import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:new_job_app/createjob.dart';
import 'package:new_job_app/job_details.dart';
import 'package:new_job_app/profilepage.dart';

import 'main.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  var jobList = [];

  _HomePageState() {
    _refreshJobList();
    ref.child("/jobs").onChildChanged.listen((event) {
      print("data has been changed!");
      _refreshJobList();
    });
    ref.child("/jobs").onChildAdded.listen((event) {
      print("data has been added!");
      _refreshJobList();
    });
    ref.child("/jobs").onChildRemoved.listen((event) {
      print("data has been removed!");
      _refreshJobList();
    });
  }

  void _refreshJobList() {
    FirebaseDatabase.instance.ref().child("/jobs").once().then((ds) {
      print(ds.snapshot);
      print("Key:");
      print(ds.snapshot.key);
      var tempList = [];
      Map<dynamic,dynamic>? jsonResponse= ds.snapshot.value as Map?;

      jsonResponse?.forEach((k, v) {
        tempList.add(v);
      });

      jobList.clear();
      setState(() {
        jobList = tempList;
      });
    }).catchError((e) {
      print("Failed to get the students. " + e.toString());
    });
    Stream<DatabaseEvent> stream = ref.child("/jobs").onValue;
    stream.listen((DatabaseEvent event) {
      print('Event Type: ${event.type}'); // DatabaseEventType.value;
      print('Snapshot: ${event.snapshot}'); // DataSnapshot
    });
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        _auth.signOut();
        Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
        break;
      case 'Profile':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserProfilePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Profile', 'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: jobList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () {
              print("The item is clicked " + index.toString());
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JobDetailsPage(jobList[index])),
              );
            },
            title: Container(
              height: 50,
              margin: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage("https://img.icons8.com/ios-glyphs/30/000000/new-job.png"),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${jobList[index]['title']}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                          '${jobList[index]['description']}',
                        maxLines: 2,
                      )
                    ],
                  ),
                  // Spacer(),
                ],
              ),
            ),
          );
        }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostJob(title : "Post Job Page", currentUid: "",)),
          );
        },
        tooltip: 'Post a new job',
        child: Icon(Icons.add),
      ),
    );
  }
}