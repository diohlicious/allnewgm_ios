import 'package:flutter/material.dart';
//import 'package:camera_camera/camera_camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraWidget extends StatefulWidget {
  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}
class _CameraWidgetState extends State<CameraWidget>{

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(),/*CameraCamera(
            onFile: (file) async {
              print(file?.path);
              Navigator.of(context).popAndPushNamed('/display', arguments: {"image": file});
            }
        ),*/
    );
  }
}