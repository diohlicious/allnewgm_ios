import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:grosir/Nikita/Nson.dart';
import 'package:grosir/Nikita/app.dart';
import 'package:intl/intl.dart';

typedef Widgetbuild = Widget Function(String value, Nson duration);
class WCounter extends StatefulWidget {
  final Widget child;
  final Widgetbuild  builds  ;
  final String start;
  final int lead;
  final String format;
  WCounter ({this.child, this.builds, this.start, this.lead, this.format});

  @override
  WCounterState createState() => WCounterState();


}

class WCounterState extends State<WCounter>   with WidgetsBindingObserver {
  Timer _timer;
  int _start = 10;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic( oneSec,
          (Timer timer) {
                setState(() {
                   //reload
                });
           },
    );
  }

  @override
  void dispose() {
     _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builds!=null){
        String value = widget.start ;
        try {
          //lead

         /* App.log("WCounterState-widgetstart "+widget.start);
          App.log("WCounterState-widgecomparet "+widget.compare);*/
          DateTime start = DateTime.parse(widget.start);
          DateTime today = DateTime.now();


          int difference = today.difference(start).inSeconds;
          Duration duration = Duration(seconds: difference+widget.lead);
          value = _val(duration);
          Nson n = Nson.newObject();
          n.set("Days", twoDigits(duration.inDays.abs()));
          n.set("Hours", twoDigits(duration.inHours.abs()));
          n.set("Minutes", twoDigits(duration.inMinutes.abs().remainder(60)));
          n.set("Seconds", twoDigits(duration.inSeconds.abs().remainder(60)));


          return Container(child:  widget.builds(value, n));
        } on Exception catch (_) {
          return Container(child:  widget.builds("", Nson.newObject()));
        }


    }
  }
  String twoDigits(int n) => n.abs().toString().padLeft(2, "0");
  String _val(Duration duration) {
    //String twoDigits(int n) => n.abs().toString().padLeft(2, "0");
    String days = duration.inDays.abs().toString();
    String twoDigitMinutes = twoDigits( duration.inMinutes.abs().remainder(60));
    String twoDigitSeconds = twoDigits( duration.inSeconds.abs().remainder(60));
    return "${days} Hari ${twoDigits(duration.inHours.abs())} Jam $twoDigitMinutes Menit $twoDigitSeconds Detik";
  }
}