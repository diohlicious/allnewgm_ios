import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grosir/Api/apiservice.dart';
import 'dart:io';
import 'package:grosir/Nikita/NsGlobal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grosir/Nikita/Nson.dart';
import 'package:grosir/Nikita/app.dart';
import 'package:grosir/UI/WCounter.dart';
import 'package:intl/intl.dart';

import 'UI/CustomIcons.dart';
import 'UI/SocialIcons.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Tawar extends StatefulWidget {
  @override
  _TawarState createState() => _TawarState();
}

enum StepTawar { NOL, SATU, DUAL }

class _TawarState extends State<Tawar> {
  List<Widget> _listBidder = [];
  Nson args = Nson.newObject();
  TextEditingController tawarText = TextEditingController();
  StepTawar _stepTawar = StepTawar.NOL;
  bool _isVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void fetchBidder(Map _nPopulate) {
    var _data = Nson(_nPopulate);
    for (var i = 0; i < _data.get("user_bid").size(); i++) {
      var dateTime = DateTime.parse(
          _data.get("user_bid").getIn(i).get("date_bid").asString());
      setState(() {
        _listBidder.add(
          //date_bid
          textViewTawar(
              context,
              _data.get("openhouseid").asString(),
              App.formatCurrency(
                  _data.get("user_bid").getIn(i).get("price_bid").asDouble()),
              DateFormat('dd-MM-yyyy HH:mm').format(dateTime),
              //args.get("user_bid").getIn(i).get("date_bid").asString(),
              i == 0 ? Colors.red : Colors.black),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    /*SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1304, allowFontScaling: true)
          ..init(context);*/

    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      args = Nson(arguments['args']);
    } else {
      args = App.Arguments.get("args");
    }
    App.log(args.asString());

    if (tawarText.text == '') {
      tawarText.text = App.formatCurrency(args.get("PriceNow").asDouble());
    }
    fetchBidder(arguments['populate']);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tawar",
          style: TextStyle(
              fontWeight: FontWeight.w800, color: Colors.black, fontSize: 28),
        ),
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: (10),
            ),
            Container(
                child: Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: _content(context),
            )),
          ],
        ),
      ),
    );
    /*MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:
      Scaffold(
        appBar: AppBar(
          title: Text(
            "Tawar",
            style: TextStyle(
                fontWeight: FontWeight.w800, color: Colors.black, fontSize: 28),
          ),
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
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: (10),
              ),
              Container(
                  child: Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: _content(context),
              )),
            ],
          ),
        ),
      ),
      debugShowCheckedModeBanner: true,
    );*/
  }

  Widget textViewFilter(context, String text, String val) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center, //Center Row contents horizontally,
      crossAxisAlignment:
          CrossAxisAlignment.center, //Center Row contents vertically,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2 - 20,
          child: Text(text,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.w500,
                  fontSize: 20)),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 2 - 30,
          child: Text(val,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black45,
                  fontSize: 20)),
        ),
        Icon(
          Icons.navigate_next,
          color: Colors.black54,
        ),
      ],
    );
  }

  void afterberhasil() {
    //Navigator.of(context).pushNamed('/home');
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/home', (Route<dynamic> route) => false,
        arguments: {'keranjang': true});
  }

  void tawar(Nson data) async {
    //LiveNegoMobile
    Map m = {
      "open_house_id": 932, //ohid
      "kik": 1, //kik
      "agreement_no": "5672000775", //agreement_no
      "bid_price": 76200000
    };
    Nson args = Nson.newObject();
    args.set("open_house_id", data.get("ohid").asString());
    args.set("kik", data.get("kik").asString());
    args.set("agreement_no", data.get("agreement_no").asString());
    args.set("bid_price", App.replace(tawarText.text, ",", ""));
    App.log(args.toStream());

    App.showBusy(context);
    Nson nson = await ApiService.get().liveNegoApi(args);
    App.log(nson.toStream());

    Navigator.pop(context);
    if (nson.get("message").asString() == 'success') {
      AwesomeDialog(
          context: context,
          dialogType: DialogType.NO_HEADER,
          animType: AnimType.BOTTOMSLIDE,
          body: Column(
            children: [
              Text('Berhasil Menawar ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: "Nunito",
                      height: 1.2,
                      fontSize: 22)),
              SizedBox(height: 10),
              Text(
                  data.get("vehicle_name").asString() +
                      '  seharga  Rp ' +
                      tawarText.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: "Nunito",
                      height: 1.5,
                      fontSize: 14,
                      color: Color.fromARGB(255, 143, 143, 143)))
            ],
          ),
          btnOk: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(25),
            child: Padding(
              padding: EdgeInsets.only(),
              child: InkWell(
                onTap: () {
                  print('hello');

                  afterberhasil();
                },
                child: new Container(
                  width: 100.0,
                  height: 50.0,
                  decoration: new BoxDecoration(
                    color: Color.fromARGB(255, 10, 132, 254),
                    border: new Border.all(
                        color: Color.fromARGB(255, 10, 132, 254), width: 1.0),
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: new Center(
                    child: new Text(
                      'Keranjang',
                      style: new TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
          btnOkOnPress: () {
            Navigator.of(context).pop();
          },
          dismissOnTouchOutside: false)
        ..show();
    } else {
      App.showError(nson.get("description").asString());
    }
  }

  void buyNow(Nson data) async {
    //LiveBuyNowMobile
    Map m = {
      "open_house_id": 922,
      "kik": "20201022IK02001015",
      "agreement_no": "4621806056",
      "bid_price": 65000000
    };
    Nson args = Nson.newObject();
    args.set("open_house_id", data.get("ohid").asString());
    args.set("kik", data.get("kik").asString());
    args.set("agreement_no", data.get("agreement_no").asString());
    args.set("bid_price", data.get("open_price").asDouble());
    App.log(args.toStream());

    App.showBusy(context);
    Nson nson = await ApiService.get().liveBuyNowApi(args);
    App.log(nson.toStream());

    Navigator.pop(context);
    if (nson.get("message").asString() == 'success') {
      AwesomeDialog(
          context: context,
          dialogType: DialogType.NO_HEADER,
          animType: AnimType.BOTTOMSLIDE,
          body: Column(
            children: [
              Text('Berhasil',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: "Nunito",
                      height: 1.2,
                      fontSize: 22)),
              SizedBox(height: 10),
              Text(
                  data.get("vehicle_name").asString() +
                      '  seharga  Rp ' +
                      App.formatCurrency(data.get("open_price").asDouble()),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: "Nunito",
                      height: 1.5,
                      fontSize: 14,
                      color: Color.fromARGB(255, 143, 143, 143)))
            ],
          ),
          btnOk: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(25),
            child: Padding(
              padding: EdgeInsets.only(),
              child: InkWell(
                onTap: () {
                  afterberhasil();
                },
                child: new Container(
                  width: 100.0,
                  height: 50.0,
                  decoration: new BoxDecoration(
                    color: Color.fromARGB(255, 10, 132, 254),
                    border: new Border.all(
                        color: Color.fromARGB(255, 10, 132, 254), width: 1.0),
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: new Center(
                    child: new Text(
                      'Keranjang',
                      style: new TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
          btnOkOnPress: () {
            Navigator.of(context).pop();
          },
          dismissOnTouchOutside: false)
        ..show();
    } else {
      App.showError(nson.get("description").asString());
    }
  }

  Widget _content(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text("Waktu Penawaran",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        SizedBox(height: 30),
        Center(
          child: Column(
            children: [
              Column(
                children: [
                  Column(
                    children: [
                      Column(
                        children: [
                          WCounter(
                            builds: (value, duration) => Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  _timeView(duration
                                      .get("Days")
                                      .asString()
                                      .substring(0, 1)),
                                  _timeView(duration
                                      .get("Days")
                                      .asString()
                                      .substring(1, 2)),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  _timeView(duration
                                      .get("Hours")
                                      .asString()
                                      .substring(0, 1)),
                                  _timeView(duration
                                      .get("Hours")
                                      .asString()
                                      .substring(1, 2)),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  _timeView(duration
                                      .get("Minutes")
                                      .asString()
                                      .substring(0, 1)),
                                  _timeView(duration
                                      .get("Minutes")
                                      .asString()
                                      .substring(1, 2)),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  _timeView(duration
                                      .get("Seconds")
                                      .asString()
                                      .substring(0, 1)),
                                  _timeView(duration
                                      .get("Seconds")
                                      .asString()
                                      .substring(1, 2)),
                                  SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                            ),
                            start: args.get("end_date").asString(),
                            lead: args.get("lead").asInteger(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text("Penawaran Anda",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        SizedBox(
          height: (50),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Expanded(
                flex: 3,
                child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Radio(
                          value: StepTawar.NOL,
                          groupValue: _stepTawar,
                          onChanged: (StepTawar value) {
                            setState(() {
                              _stepTawar = value;
                            });
                          },
                        ),
                        Text("500.000")
                      ],
                    ))),
            Expanded(
                flex: 3,
                child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Radio(
                          value: StepTawar.SATU,
                          groupValue: _stepTawar,
                          onChanged: (StepTawar value) {
                            setState(() {
                              _stepTawar = value;
                            });
                          },
                        ),
                        Text("1.000.000")
                      ],
                    ))),
            Expanded(
                flex: 3,
                child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Radio(
                          value: StepTawar.DUAL,
                          groupValue: _stepTawar,
                          onChanged: (StepTawar value) {
                            setState(() {
                              _stepTawar = value;
                            });
                          },
                        ),
                        Text("1.500.000")
                      ],
                    ))),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
        SizedBox(
          height: (50),
        ),
        Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  String s = tawarText.text.replaceAll(".", "");
                  s = s.replaceAll(",", "");
                  _isVisible = true;
                  double i = App.getDouble(s);
                  i -= (_stepTawar == StepTawar.NOL
                      ? 500000
                      : (_stepTawar == StepTawar.SATU ? 1000000 : 1500000));
                  if (i > args.get("PriceNow").asDouble()) {
                    tawarText.text = App.formatCurrency(i);
                    setState(() {});
                  } else {
                    tawarText.text =
                        App.formatCurrency(args.get("PriceNow").asDouble());
                    App.showError('Kembali Ke Penawaran Tertinggi');
                  }
                },
                child: Icon(
                  Icons.remove_circle_outline,
                  size: 48,
                  color: Colors.black54,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: MediaQuery.of(context).size.width - 100,
                child: TextField(
                  enabled: true,
                  readOnly: true,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).accentColor),
                  controller: tawarText,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        tawarText.text =
                            App.formatCurrency(args.get("PriceNow").asDouble());
                        print(args.get("PriceNow").asString());
                      },
                      child: Icon(Icons.clear),
                    ),
                    hintStyle: CustomTextStyle.formField(context),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).accentColor, width: 1.0)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).accentColor, width: 1.0)),
                  ),
                  obscureText: false,
                ),
              ),
            ),
            Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    String s = tawarText.text.replaceAll(".", "");
                    s = s.replaceAll(",", "");
                    double i = App.getDouble(s);
                    i += (_stepTawar == StepTawar.NOL
                        ? 500000
                        : (_stepTawar == StepTawar.SATU ? 1000000 : 1500000));
                    if (i < args.get("open_price").asDouble()) {
                      tawarText.text = App.formatCurrency(i);
                      setState(() {});
                    } else {
                      tawarText.text =
                          App.formatCurrency(args.get("open_price").asDouble());
                      App.showError(
                          'Maximal Nego: Rp. ${App.formatCurrency(args.get("open_price").asDouble())} \n Silahkan Langsung BUY NOW');
                      setState(() {
                        _isVisible = false;
                      });
                    }
                  },
                  child: Icon(
                    Icons.add_circle_outline,
                    size: 48,
                    color: Colors.black54,
                  ),
                )),
          ],
        ),
        SizedBox(
          height: (80),
        ),
        SizedBox(
          height: 20,
        ),
        Visibility(
          visible: _isVisible,
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(),
              child: InkWell(
                onTap: () {
                  //Navigator.of(context).pop();
                  AwesomeDialog(
                          context: context,
                          dialogType: DialogType.NO_HEADER,
                          animType: AnimType.BOTTOMSLIDE,
                          body: Column(
                            children: [
                              Text('Waktu Penawaran',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Nunito",
                                      height: 1.2,
                                      fontSize: 14)),
                              SizedBox(height: 20),
                              WCounter(
                                builds: (value, duration) => Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      _timeView(duration
                                          .get("Days")
                                          .asString()
                                          .substring(0, 1)),
                                      _timeView(duration
                                          .get("Days")
                                          .asString()
                                          .substring(1, 2)),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      _timeView(duration
                                          .get("Hours")
                                          .asString()
                                          .substring(0, 1)),
                                      _timeView(duration
                                          .get("Hours")
                                          .asString()
                                          .substring(1, 2)),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      _timeView(duration
                                          .get("Minutes")
                                          .asString()
                                          .substring(0, 1)),
                                      _timeView(duration
                                          .get("Minutes")
                                          .asString()
                                          .substring(1, 2)),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      _timeView(duration
                                          .get("Seconds")
                                          .asString()
                                          .substring(0, 1)),
                                      _timeView(duration
                                          .get("Seconds")
                                          .asString()
                                          .substring(1, 2)),
                                      SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                start: args.get("end_date").asString(),
                                lead: args.get("lead").asInteger(),
                              ),
                              SizedBox(height: 20),
                              Text('Apakah Anda ingin  menawar? ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Nunito",
                                      height: 1.2,
                                      fontSize: 22)),
                              SizedBox(height: 10),
                              Text(
                                  args.get("vehicle_name").asString() +
                                      '  seharga  Rp ' +
                                      tawarText.text,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Nunito",
                                      height: 1.5,
                                      fontSize: 14,
                                      color:
                                          Color.fromARGB(255, 143, 143, 143)))
                            ],
                          ),
                          btnOk: Container(
                            child: Padding(
                              padding: EdgeInsets.only(),
                              child: InkWell(
                                onTap: () {
                                  tawar(args);
                                },
                                child: new Container(
                                  width: 100.0,
                                  height: 50.0,
                                  decoration: new BoxDecoration(
                                    color: Colors.blue,
                                    border: new Border.all(
                                        color: Colors.blue, width: 1.0),
                                    borderRadius:
                                        new BorderRadius.circular(10.0),
                                  ),
                                  child: new Center(
                                    child: new Text(
                                      'Tawar',
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18.0,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          dismissOnTouchOutside: true)
                      .show();
                },
                child: new Container(
                  width: 100.0,
                  height: 50.0,
                  decoration: new BoxDecoration(
                    color: Color.fromARGB(255, 10, 132, 254),
                    border: new Border.all(
                        color: Color.fromARGB(255, 10, 132, 254), width: 1.0),
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: new Center(
                    child: new Text(
                      'Tawar',
                      style: new TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: InkWell(
              onTap: () {
                AwesomeDialog(
                        context: context,
                        dialogType: DialogType.NO_HEADER,
                        animType: AnimType.BOTTOMSLIDE,
                        body: Column(
                          children: [
                            Text('Apakah anda ingin  Buy Now ? ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Nunito",
                                    height: 1.2,
                                    fontSize: 22)),
                            SizedBox(height: 10),
                            Text(
                                args.get("vehicle_name").asString() +
                                    '  seharga  Rp ' +
                                    App.formatCurrency(
                                        args.get("open_price").asDouble()),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Nunito",
                                    height: 1.5,
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 143, 143, 143)))
                          ],
                        ),
                        btnOk: Container(
                          child: Padding(
                            padding: EdgeInsets.only(),
                            child: InkWell(
                              onTap: () {
                                buyNow(args);
                              },
                              child: new Container(
                                width: 100.0,
                                height: 50.0,
                                decoration: new BoxDecoration(
                                  color: Color.fromARGB(255, 148, 193, 44),
                                  border: new Border.all(
                                      color: Color.fromARGB(255, 148, 193, 44),
                                      width: 1.0),
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                                child: new Center(
                                  child: new Text(
                                    'Buy Now',
                                    style: new TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18.0,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        dismissOnTouchOutside: false)
                    .show();
              },
              child: new Container(
                width: 100.0,
                height: 50.0,
                decoration: new BoxDecoration(
                  color: Color.fromARGB(255, 148, 193, 44),
                  border: new Border.all(
                      color: Color.fromARGB(255, 148, 193, 44), width: 1.0),
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                child: new Center(
                  child: new Text(
                    'Buy Now Rp ' +
                        App.formatCurrency(args.get("open_price").asDouble()),
                    style: new TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text("Penawar",
            textAlign: TextAlign.center, style: TextStyle(fontSize: 14)),
        SizedBox(
          height: 10,
        ),
        Column(
          children: _listBidder,
        ),
        //textViewTawar(context, "Bidder 7539", "RP 116.500.000", Colors.red),
        //textViewTawar(context, "Bidder 7533", "RP 116.000.000", Colors.black),
        //textViewTawar(context, "Bidder 7530", "RP 115.500.000", Colors.black),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  imageViewOnly(context, String text) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, //Center Row contents horizontally,
        crossAxisAlignment:
            CrossAxisAlignment.center, //Center Row contents vertically,
        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: 150,
                height: 120,
                margin: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: Image.asset(
                  "assets/images/im1.png",
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: 150,
                height: 120,
                margin: const EdgeInsets.only(left: 10.0, right: 0.0),
                child: Image.asset(
                  "assets/images/im2.png",
                  fit: BoxFit.fill,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _timeView(dynamic digit) {
    return Container(
      width: 35.0,
      height: 45.0,
      alignment: Alignment.center,
      child: Text(
        digit.toString(),
        style: TextStyle(
          fontSize: 30.0,
          color: Colors.black,
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.white12,
          image: DecorationImage(
            image: AssetImage("assets/images/timebox.png"),
            fit: BoxFit.contain,
          ),
          borderRadius: BorderRadius.all(Radius.circular(7)),
          border: Border.all(
            width: 1.0,
            color: Colors.black12,
          )),
    );
  }

  textViewOnly(context, String text, String val) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, //Center Row contents horizontally,
        crossAxisAlignment:
            CrossAxisAlignment.center, //Center Row contents vertically,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2 - 25,
            child: Text(text,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 14)),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2 - 5,
            child: Text(val,
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  textViewTawar(context, String text, String val, date, Color color) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, //Center Row contents horizontally,
        crossAxisAlignment:
            CrossAxisAlignment.center, //Center Row contents vertically,
        children: [
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2 - 25,
                child: Text('Bidder $text',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w500,
                        fontSize: 12)),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2 - 25,
                child: Text(date,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w500,
                        fontSize: 12)),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2 - 25,
            child: Text(val,
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.w500, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  textViewIcon(context, String text, String val, bool b) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, //Center Row contents horizontally,
        crossAxisAlignment:
            CrossAxisAlignment.center, //Center Row contents vertically,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2 - 25,
            child: Text(text,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 14)),
          ),
          Icon(
            b ? Icons.check_circle : Icons.remove_circle,
            color: b ? Colors.green : Colors.red,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2 - 35,
            child: Text(val,
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil().setWidth(120),
          height: 1.0,
          color: Colors.white.withOpacity(0.6),
        ),
      );

  Widget emailErrorText() => Text("Controller.displayErrorEmailLogIn");

  // Return "OTP" input field
  get _getInputField {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _otpTextField(0),
        _otpTextField(0),
        _otpTextField(0),
        _otpTextField(0),
      ],
    );
  }

  // Returns "Otp custom text field"
  Widget _otpTextField(int digit) {
    return Container(
      width: 35.0,
      height: 45.0,
      alignment: Alignment.center,
      child: Text(
        digit != null ? digit.toString() : "",
        style: TextStyle(
          fontSize: 30.0,
          color: Colors.black,
        ),
      ),
      decoration: BoxDecoration(
          //            color: Colors.grey.withOpacity(0.4),
          border: Border(
              bottom: BorderSide(
        width: 2.0,
        color: Colors.black,
      ))),
    );
  }
}

class CustomTextStyle {
  static TextStyle formField(BuildContext context) {
    return Theme.of(context).textTheme.title.copyWith(
        fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.white);
  }

  static TextStyle title(BuildContext context) {
    return Theme.of(context).textTheme.title.copyWith(
        fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white);
  }

  static TextStyle subTitle(BuildContext context) {
    return Theme.of(context).textTheme.title.copyWith(
        fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white);
  }

  static TextStyle button(BuildContext context) {
    return Theme.of(context).textTheme.title.copyWith(
        fontSize: 20, fontWeight: FontWeight.normal, color: Colors.white);
  }

  static TextStyle body(BuildContext context) {
    return Theme.of(context).textTheme.title.copyWith(
        fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white);
  }
}

class SlideTile extends StatelessWidget {
  String imagePath, title, desc;

  SlideTile({this.imagePath, this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(imagePath),
        ],
      ),
    );
  }
}

class SliderModel {
  String imageAssetPath;
  String title;
  String desc;

  SliderModel({this.imageAssetPath, this.title, this.desc});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String getImageAssetPath() {
    return imageAssetPath;
  }

  String getTitle() {
    return title;
  }

  String getDesc() {
    return desc;
  }
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = new List<SliderModel>();
  SliderModel sliderModel = new SliderModel();

  //1
  sliderModel.setDesc(
      "Dengan Grosir Mobile, cai dan pilih unit\r\nyang anda butuhkan kini lebih mudah");
  sliderModel.setTitle("Selamat Datang Sobat GMob!");
  sliderModel.setImageAssetPath("assets/images/mx.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //2
  sliderModel
      .setDesc("Berikan harga terbaik anda melalui\r\npenawaran atau buy now");
  sliderModel.setTitle("Tawar atau Buy Now");
  sliderModel.setImageAssetPath("assets/images/mx.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //3
  sliderModel.setDesc(
      "Lakukan pembayaran melalu Virtual Account\r\ndan bawa pulang mobil anda!");
  sliderModel.setTitle("Bayar dan Bawa Pulang");
  sliderModel.setImageAssetPath("assets/images/mx.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  return slides;
}
