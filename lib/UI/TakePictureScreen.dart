import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TakePictureScreen extends StatefulWidget {
  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  List<CameraDescription> cameras;
  CameraDescription camera;

  @override
  void initState() {
    super.initState();
    this._getAvailableCameras();

    // Next, initialize the controller. This returns a Future.
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();

    super.dispose();
  }

  // get available cameras
  Future<void> _getAvailableCameras() async {
    WidgetsFlutterBinding.ensureInitialized();

    cameras = await availableCameras();
    _initCamera(cameras.first);

  }

  Future<void> _initCamera(CameraDescription description) async {
    _controller = CameraController(description, ResolutionPreset.max);
    try {
      await _controller.initialize();
      // to notify the widgets that camera has been initialized and now camera preview can be done
      setState(() {
        _initializeControllerFuture = _controller.initialize();
      });
    } catch (e) {
      print(e);
    }
  }

  void _switchCamera() {
    // get current lens direction (front / rear)
    final lensDirection = _controller.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }

    if (newDescription != null) {
      _initCamera(newDescription);
    } else {
      print('Asked camera not available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: Stack(
          children: [
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future is complete, display the preview.
                  return CameraPreview(_controller);
                } else {
                  // Otherwise, display a loading indicator.
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: InkWell(
                  onTap: () async {
                    final image = await _controller.takePicture();
                    final result = await Navigator.of(context).pushNamed('/display', arguments: {"image": image});
                    if(result){Navigator.of(context).pop(image?.path);}
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: InkWell(
                  onTap: () {
                    //bloc.changeCamera();
                    _switchCamera();
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.black.withOpacity(0.6),
                    child: Icon(
                      Icons.flip_camera_ios,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ), /**/
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    XFile image = arguments["image"];
    File file = File(image?.path);

    return Scaffold(
      appBar: AppBar(
        title: Text('Save Photo'),
        actions: [
          IconButton(
              icon: Icon(Icons.camera),
              onPressed: () {
                //Navigator.of(context).popAndPushNamed('/take');
                Navigator.of(context).pop(false);
              }),
          IconButton(
              icon: Icon(Icons.save_outlined),
              onPressed: () async {
                //List<int> imageBytes = file.readAsBytesSync();
                //print(imageBytes);
                //String base64Image = base64Encode(imageBytes);
                //final result = await Navigator.of(context).pushNamed('/documentktp',
                //    arguments: {"image": file});
                Navigator.of(context).pop(true)
                ;
              }),
        ],
      ),
      body: Container(
          alignment: Alignment.center,
          child: Image.file(
            file,
          )),
    );
  }
}
