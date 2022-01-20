import 'package:flutter/material.dart';

class JobDetailsPage extends StatefulWidget {

  var jobid;

  JobDetailsPage(this.jobid);

  @override
  _JobDetailsPageState createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${widget.jobid['title']}",
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
              fontSize: 40
            ),),
          Text("Employer Info:",
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
            ),),
          Text("${widget.jobid['employerId']}"),
          Text(" "),
          Text("Role Description",
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
            ),),
          Text("${widget.jobid['description']}",
            textAlign: TextAlign.start,
            style: const TextStyle(
                fontWeight: FontWeight.bold
            ),),

        ],
      ),
    );
  }
}