// import 'dart:async';
// import 'dart:io';
//
// import 'package:camera/camera.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:path/path.dart' show join;
// import 'package:path_provider/path_provider.dart';
//
// // A screen that allows users to take a picture using a given camera.
// class TakePictureScreen extends StatefulWidget {
//   final CameraDescription camera;
//
//   const TakePictureScreen({
//     Key? key,
//     required this.camera,
//   }) : super(key: key);
//
//   @override
//   TakePictureScreenState createState() => TakePictureScreenState();
// }
//
// class TakePictureScreenState extends State<TakePictureScreen> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     // To display the current output from the Camera,
//     // create a CameraController.
//     _controller = CameraController(
//       // Get a specific camera from the list of available cameras.
//       widget.camera,
//       // Define the resolution to use.
//       ResolutionPreset.medium,
//     );
//
//     // Next, initialize the controller. This returns a Future.
//     _initializeControllerFuture = _controller.initialize();
//   }
//
//   @override
//   void dispose() {
//     // Dispose of the controller when the widget is disposed.
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Take a picture')),
//       // Wait until the controller is initialized before displaying the
//       // camera preview. Use a FutureBuilder to display a loading spinner
//       // until the controller has finished initializing.
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             // If the Future is complete, display the preview.
//             return CameraPreview(_controller);
//           } else {
//             // Otherwise, display a loading indicator.
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.camera_alt),
//         // Provide an onPressed callback.
//         onPressed: () async {
//           // Take the Picture in a try / catch block. If anything goes wrong,
//           // catch the error.
//           try {
//             // Ensure that the camera is initialized.
//             await _initializeControllerFuture;
//
//             // Construct the path where the image should be saved using the
//             // pattern package.
//             final path = join(
//               // Store the picture in the temp directory.
//               // Find the temp directory using the `path_provider` plugin.
//               (await getTemporaryDirectory()).path,
//               '${DateTime.now()}.png',
//             );
//
//             // Attempt to take a picture and log where it's been saved.
//             await _controller.takePicture(path);
//
//             // If the picture was taken, display it on a new screen.
//             final result = await Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => DisplayPictureScreen(imagePath: path),
//               ),
//             );
//
//             Navigator.pop(context, result);
//           } catch (e) {
//             // If an error occurs, log the error to the console.
//             print(e);
//           }
//         },
//       ),
//     );
//   }
// }
//
// // A widget that displays the picture taken by the user.
// class DisplayPictureScreen extends StatelessWidget {
//   final String imagePath;
//
//   const DisplayPictureScreen({Key? key, required this.imagePath}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: Text('Display the Picture')),
//         // The image is stored as a file on the device. Use the `Image.file`
//         // constructor with the given path to display the image.
//         body: Column(
//           children: [
//             Image.file(File(imagePath)),
//             Text('${imagePath}'),
//             RaisedButton(
//               child: Text("Upload"),
//               onPressed: () async {
//                 var fileToUpload = File(imagePath);
//                 var fileName = "profile-" + DateTime.now().millisecondsSinceEpoch.toString() + '.png';
//                 UploadTask uploadTask = FirebaseStorage.instance.ref().child("profile/" + fileName).putFile(fileToUpload);
//                 print(uploadTask);
//                 var imageUrl = await (await uploadTask).ref.getDownloadURL();
//                 var url = imageUrl.toString();
//                 print(url);
//                 // FirebaseStorage.instance.ref().child("profile/" + fileName).putFile(fileToUpload).snapshotEvents.listen((event) {
//                 //   if (event.runtimeType == StreamSubscription.) {
//                 //     FirebaseStorage.instance.ref().child("profile/" + fileName).getDownloadURL()
//                 //         .then((value) {
//                 //       print("URL: " + value.toString());
//                 //       Navigator.pop(context, value.toString());
//                 //     }).catchError((error) {
//                 //       print("Failed to get the URL");
//                 //     });
//                 //   }
//                 // });
//               },
//             )
//           ],
//         )
//     );
//   }
// }