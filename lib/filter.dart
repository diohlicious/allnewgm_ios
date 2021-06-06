import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grosir/Api/apiservice.dart';
import 'dart:io';
import 'package:grosir/Nikita/NsGlobal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grosir/Nikita/Nson.dart';

import 'UI/CustomIcons.dart';
import 'UI/SocialIcons.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:grosir/Nikita/app.dart';

class Filter extends StatefulWidget {
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  TextEditingController kisaranAwal = TextEditingController();
  TextEditingController kisaranAkhir = TextEditingController();
  TextEditingController tahunAwal = TextEditingController();
  TextEditingController tahunAkhir = TextEditingController();
  RangeValues _currentRangeValues = RangeValues(0, 1000000000);
  Nson merkNson = Nson.newArray();
  Nson lokasiNson = Nson.newArray();
  Nson tahunNson = Nson.newArray();
  Nson gradeNson = Nson.newArray();
  double _year = DateTime.now().year.toDouble();
  RangeValues _currentRangeYear = RangeValues(1995, 2020);

  @override
  void initState() {
    super.initState();
    kisaranAwal.text =
        App.formatCurrency(_currentRangeValues.start.roundToDouble());
    kisaranAkhir.text =
        App.formatCurrency(_currentRangeValues.end.roundToDouble());
    tahunAwal.text =
        _currentRangeYear.start.toStringAsFixed(0);
    tahunAkhir.text =
        _currentRangeYear.end.toStringAsFixed(0);
    App.log("initStateFilter");
    _reload();
    this._onLoad();
  }

  _onLoad() async {
    ApiService apiService = ApiService();
    var responseMerk = await apiService.filterMerk();
    merkNson = await apiService.getNson(responseMerk);

    var responseLokasi = await apiService.filterWarehouse();
    lokasiNson = await apiService.getNson(responseLokasi);

    //var responseTahun = await apiService.();
    //tahunNson = await apiService.getNson(responseTahun);

    for (var i = 1995; i <= _year; i++) {
      Nson _nson = Nson.newObject();
      _nson.set('tahun', i);
      tahunNson.add(_nson);
    }
    print(tahunNson.asString());
    var responseGrade = await apiService.filterGrade();
    gradeNson = await apiService.getNson(responseGrade);
  }

  Nson nfilter = Nson.newObject();

  _filterName(String id) {
    switch (id) {
      case 'merek':
        return;
    }
  }

  _picker(String id, {Nson val}) {
    print('ok ' + val.asString());
    var _value;
    List _listGender = val.asList();
    List<Widget> _listWidget = [];
    _listGender.forEach((value) {
      _listWidget.add(Text(value[id]));
    });
    _value = _listGender[0][id];
    //var _controller = TextEditingController();
    showModalBottomSheet(
        backgroundColor: Colors.white.withOpacity(0),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 280,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                )),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Row(children: [
                    Spacer(),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            print(_value);
                            nfilter.set(id == 'name' ? 'lokasi' : id, _value);
                          });
                          print(nfilter.get(id).asString());
                          Navigator.pop(context);
                        },
                        child: Text('Confirm',
                            style: TextStyle(color: Color(0xff95c12c)))),
                    SizedBox(
                      width: 38,
                    ),
                  ]),
                ),
                Container(
                  height: 200,
                  child: CupertinoPicker(
                    diameterRatio: 10,
                    useMagnifier: false,
                    backgroundColor: Colors.white.withOpacity(0),
                    onSelectedItemChanged: (value) {
                      setState(() {
                        //_value = value;
                        //_filterName(id);
                        print(value);
                        _value = _listGender[value][id].toString();
                        //_controller.text = value.toString();
                      });
                    },
                    itemExtent: 32.0,
                    children: _listWidget,
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _reload() async {
    String filter = await App.getSetting("filter");
    nfilter = Nson.parseJson(filter);

    /* Nson args = Nson.newObject();
    args.set("page", 1);
    args.set("max", 1);
    args.set("category", 'live');
    args.set("lokasi", nfilter.get("lokasi").asString());
    args.set("tahunstart",  nfilter.containsKey("tahunstart")?  nfilter.get("tahunstart").asInteger() : 2000);
    args.set("tahunend", nfilter.containsKey("tahunend")?  nfilter.get("tahunend").asInteger() : 3000);
    args.set("merek", nfilter.get("merek").asString());
    args.set("hargastart", nfilter.get("hargastart").asInteger());
    args.set("hargaend", nfilter.containsKey("hargaend")?  nfilter.get("hargaend").asInteger() :  1000000000);

*/
    //Nson nson = await ApiService.get().l(args) ;
    //nsonLive = nson.get("data").get("data_live");

    _currentRangeValues = RangeValues(
        nfilter.get("hargastart").asDouble(),
        nfilter.containsKey("hargaend")
            ? nfilter.get("hargaend").asDouble()
            : 1000000000);
    kisaranAwal.text =
        App.formatCurrency(_currentRangeValues.start.roundToDouble());
    kisaranAkhir.text =
        App.formatCurrency(_currentRangeValues.end.roundToDouble());

    setState(() {});
  }

  void _hapus() async {
    await App.delSetting("filter");
    _reload();
  }

  void _filterNow() async {
    //save
    Nson args = Nson.newObject();
    args.set("page", 1);
    args.set("max", 10);
    args.set("category", 'live');
    args.set("lokasi", nfilter.get("lokasi").asString());
    args.set("tahunstart", tahunAwal.text);
    args.set("tahunend", tahunAkhir.text);
    args.set("merek", nfilter.get("merek").asString());
    args.set("hargastart", _currentRangeValues.start.round());
    args.set("hargaend", _currentRangeValues.end.round());

    await App.setSetting("filter", args.toJson());
    Nson res = Nson.newObject();
    Navigator.pop(context, res);
  }

  static Future<Nson> showFilter(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Filter()),
    );
    return result is Nson ? result : Nson.newObject();
  }

  @override
  Widget build(BuildContext context) {
    /*SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    ScreenUtil.instance = ScreenUtil.getInstance()
      ..init(context);
    ScreenUtil.instance =
    ScreenUtil(width: 750, height: 1304, allowFontScaling: true)
      ..init(context);*/

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Filter",
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
        actions: <Widget>[
          FlatButton(
            child: Text("Hapus"),
            onPressed: () {
              _hapus();
            },
          )
        ],
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
      bottomSheet: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.only(),
          child: InkWell(
            onTap: () {
              print('hello');
              //Navigator.of(context).pop();
              _filterNow();
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
                  'Filter',
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
    );
  }

  Widget textViewFilter(context, String text, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      //Center Row contents horizontally,
      crossAxisAlignment: CrossAxisAlignment.center,
      //Center Row contents vertically,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2 - 30,
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
                  fontSize: 16)),
        ),
        Icon(
          Icons.navigate_next,
          color: Colors.black54,
        ),
      ],
    );
  }

  Widget _content(context) {
    //textviewfilter
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: (80),
        ),
        //viewpage
        GestureDetector(
            onTap: () {
              _picker('merek', val: merkNson.get('data'));
            },
            child: textViewFilter(
                context, "Merek", nfilter.get("merek").asString())),
        SizedBox(
          height: 20,
        ),
        GestureDetector(
            onTap: () {
              _picker('name', val: lokasiNson.get('data'));
            },
            child: textViewFilter(
                context, "Lokasi", nfilter.get("lokasi").asString())),
        SizedBox(
          height: 20,
        ),
        Text("Kisaran Harga",
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.w500,
                fontSize: 20)),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: TextField(
                  enabled: false,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      fontSize: 18, color: Theme.of(context).accentColor),
                  controller: kisaranAwal,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    filled: false,
                    hintStyle: new TextStyle(color: Colors.grey[800]),
                    hintText: "Rp.",
                    /* fillColor: Colors.white70*/
                  ),
                  obscureText: false,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 3,
                child: TextField(
                  enabled: false,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      fontSize: 18, color: Theme.of(context).accentColor),
                  controller: kisaranAkhir,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    filled: false,
                    hintStyle: new TextStyle(color: Colors.grey[800]),
                    hintText: "Rp.",
                    /* fillColor: Colors.white70*/
                  ),
                  obscureText: false,
                ),
              ),
            ],
          ),
        ),
        //RangeWidget() ,

        RangeSlider(
          values: _currentRangeValues,
          min: 0,
          max: 1000000000,
          divisions: 1000,
          labels: RangeLabels(
            App.formatCurrency(_currentRangeValues.start.roundToDouble()),
            App.formatCurrency(_currentRangeValues.end.roundToDouble()),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRangeValues = values;
              kisaranAwal.text =
                  App.formatCurrency(_currentRangeValues.start.roundToDouble());
              kisaranAkhir.text =
                  App.formatCurrency(_currentRangeValues.end.roundToDouble());
            });
          },
        ),
        //----------------------------------------------Kisaran Tahun
        Text("Kisaran Tahun",
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.w500,
                fontSize: 20)),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: TextField(
                  enabled: false,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      fontSize: 18, color: Theme.of(context).accentColor),
                  controller: tahunAwal,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    filled: false,
                    hintStyle: new TextStyle(color: Colors.grey[800]),
                    hintText: "Tahun",
                    /* fillColor: Colors.white70*/
                  ),
                  obscureText: false,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 3,
                child: TextField(
                  enabled: false,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      fontSize: 18, color: Theme.of(context).accentColor),
                  controller: tahunAkhir,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    filled: false,
                    hintStyle: new TextStyle(color: Colors.grey[800]),
                    hintText: "Tahun",
                    /* fillColor: Colors.white70*/
                  ),
                  obscureText: false,
                ),
              ),
            ],
          ),
        ),
        //RangeWidget() ,

        RangeSlider(
          values: _currentRangeYear,
          min: 1995,
          max: 2020,
          divisions: 100,
          labels: RangeLabels(
            _currentRangeYear.start.roundToDouble().toStringAsFixed(0),
            _currentRangeYear.end.roundToDouble().toStringAsFixed(0),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRangeYear = values;
              tahunAwal.text =
                  _currentRangeYear.start.roundToDouble().toStringAsFixed(0);
              tahunAkhir.text =
                  _currentRangeYear.end.roundToDouble().toStringAsFixed(0);
            });
          },
        ),
        //----------------------------------------------Kisaran Tahun
        /*GestureDetector(
            onTap: _picker('tahun', val: tahunNson),
            child: textViewFilter(
                context, "Tahun", nfilter.get("tahun").asString())),*/
        SizedBox(
          height: 20,
        ),
        GestureDetector(
            onTap: () {
              _picker('grade', val: gradeNson.get('data'));
            },
            child: textViewFilter(
                context, "Grade", nfilter.get("grade").asString())),

        SizedBox(
          height: 100,
        ),
      ],
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

class RangeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RangeWidget();
}

class _RangeWidget extends State<RangeWidget> {
  RangeValues _currentRangeValues = const RangeValues(50000000, 1000000000);

  static String _valueToString(double value) {
    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        RangeSlider(
          values: _currentRangeValues,
          min: 0,
          max: 1000000000,
          divisions: 1000000,
          labels: RangeLabels(
            App.formatCurrency(_currentRangeValues.start.roundToDouble()),
            App.formatCurrency(_currentRangeValues.end.roundToDouble()),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRangeValues = values;
            });
          },
        )
      ],
    );
  }
}
