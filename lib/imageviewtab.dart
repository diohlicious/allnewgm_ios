import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewTab extends StatelessWidget{
  final String img;
  final String title;
  const ImageViewTab({Key key, this.img, this.title}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Row(
            children: [
              SizedBox(
                width: 30,
              ),
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.black, fontSize: 18),
              ),
            ],
          ),
        ),
        body: Container(
            child: PhotoView(
              imageProvider: NetworkImage(img),
            )
        ),
      ),
    );
  }
}