import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grosir/Nikita/Nson.dart';
import 'package:grosir/Nikita/app.dart';
import 'package:photo_view/photo_view.dart';

import 'imageviewtab.dart';

class ImageViewer extends StatefulWidget {
  @override
  _sImageViewer createState() => _sImageViewer();
}

class _sImageViewer extends State<ImageViewer> {
  Nson mySLides;
  int slideIndex = 0;
  PageController controller;
  Map arguments;
  List<Widget> _listTab= [];

  @override
  void initState() {
    super.initState();
    //controller = new PageController();
    controller = new PageController(
      initialPage: slideIndex,
      keepPage: false,
      viewportFraction: 0.7,
    );
  }

  @override
  void didChangeDependencies() {
    //final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    arguments = ModalRoute.of(context).settings.arguments as Map;
    //slideIndex = Nson(arguments).get("index").asInteger();
    mySLides = arguments['raw'];
    this.fetchListTab(mySLides);

    super.didChangeDependencies();
  }

  void fetchListTab(Nson _slide) {
    for (var i = 0; i < _slide.size(); i++) {
      setState(() {
        _listTab.add(ImageViewTab(
          img: _slide.getIn(i).get("url_image").asString(),
          title: _slide.getIn(i).get("description").asString(),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: InkWell(
            borderRadius: BorderRadius.circular(30.0),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black54,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: DefaultTabController(
          initialIndex: arguments['index'],
          length: _listTab.length,
          child: TabBarView(
              children: _listTab,
            ),
          ),
        //===

        //===
        //mySLides.getIn(index).get("url_image").asString()
        /*Container(
              child: PhotoView(
                imageProvider: NetworkImage(Nson(arguments).get("url").asString()),
              )
          ),*/
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
