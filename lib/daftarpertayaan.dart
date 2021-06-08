import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:grosir/Nikita/NsGlobal.dart';

import 'Api/apiservice.dart';
import 'Nikita/Nson.dart';
import 'Nikita/app.dart';
import 'package:grosir/Nikita/app.dart';
import 'UI/CustomIcons.dart';
import 'UI/SocialIcons.dart';
import 'UI/function_util.dart';

class DaftarPertanyaan extends StatefulWidget {
  @override
  _DaftarPertanyaanState createState() => _DaftarPertanyaanState();
}

class _DaftarPertanyaanState extends State<DaftarPertanyaan> {
  Nson daftarNson = Nson.newObject();
  Nson kebutuhanList = Nson.newArray();
  Nson pembelianList = Nson.newArray();
  Nson minatList = Nson.newArray();
  Nson rataList = Nson.newArray();
  Nson mediaList = Nson.newArray();
  var kebutuhanVal;
  var pembelianVal;
  var minatVal;
  var rataVal;
  var mediaVal;

  @override
  void initState() {
    super.initState();
    this._onLoading();
  }

  Future _onLoading() async {
    //App.showBusy(context);
    ApiService apiService = ApiService();
    //var response = await apiService.loginMasuk("baihakitanjung12@gmail.com", "123456789") ;
    final _kebutuhanList = await apiService.questionOneApi();
    final _pembelianList = await apiService.questionTwoApi();
    final _minatList = await apiService.questionThreeApi();
    final _rataList = await apiService.questionFourApi();
    final _mediaList = await apiService.questionFiveApi();
    setState(() {
      kebutuhanList = _kebutuhanList;
      pembelianList = _pembelianList;
      minatList = _minatList;
      rataList = _rataList;
      mediaList = _mediaList;
      kebutuhanVal = kebutuhanList.get('data').getIn(0).asMap();
      pembelianVal = pembelianList.get('data').getIn(0).asMap();
      minatVal = minatList.get('data').getIn(0).asMap();
      rataVal = rataList.get('data').getIn(0).asMap();
      mediaVal = mediaList.get('data').getIn(0).asMap();
      daftarNson.set('kebutuhankendaraan', kebutuhanVal["code"]);
      daftarNson.set('pembeliankebutuhankendaraan', pembelianVal["code"]);
      daftarNson.set('usiabisnis', minatVal["code"]);
      daftarNson.set('ratapenjualan', rataVal["code"]);
      daftarNson.set('perputaranunit', mediaVal["code"]);
    });
  }

  Future _onSelect(String field, var _nSelectedVal) async {
    //App.showBusy(context);
    if (FunctionUtil.equalsIgnoreCase(field, 'kebutuhankendaraan')) {
      setState(() {
        kebutuhanVal = _nSelectedVal;
      });
      daftarNson.set(field, _nSelectedVal["code"]);
    }
    if (FunctionUtil.equalsIgnoreCase(field, 'pembeliankebutuhankendaraan')) {
      setState(() {
        pembelianVal = _nSelectedVal;
      });
      daftarNson.set(field, _nSelectedVal["code"]);
    }
    if (FunctionUtil.equalsIgnoreCase(field, 'usiabisnis')) {
      setState(() {
        minatVal = _nSelectedVal;
      });
      daftarNson.set(field, _nSelectedVal["code"]);
    }
    if (FunctionUtil.equalsIgnoreCase(field, 'ratapenjualan')) {
      setState(() {
        rataVal = _nSelectedVal;
      });
      daftarNson.set(field, _nSelectedVal["code"]);
    }
    if (FunctionUtil.equalsIgnoreCase(field, 'perputaranunit')) {
      setState(() {
        mediaVal = _nSelectedVal;
      });
      daftarNson.set(field, _nSelectedVal["code"]);
    }
  }
  void _onNext()async{
    ApiService apiService = ApiService();
    //Nson _nson = await apiService.saveDataRegisterApi(daftarNson);
    var response =  await apiService.saveDataRegisterRes(daftarNson);
    Nson _nson = await apiService.getNson(response);
    print(response.body);
    daftarNson.set('userId', _nson.get('userId'));
    //App.showBusy(context);
    if(FunctionUtil.equalsIgnoreCase(_nson.get('message').asString(), 'success')){
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed('/otp', arguments: {'daftarNson': daftarNson});
    }else{
      Navigator.of(context).pop();
      App.showDialogBox(context, _nson.get('description').asString(), "",
          onClick: () async {
            Navigator.of(context).pop();
          });
    }
  }

  void _validation(){

  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    daftarNson = arguments["daftarNson"];

    print(daftarNson.asString());
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Data Diri',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            "Daftar Pertanyaan",
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
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(left: 1.0, right: 1.0),
                        child: Image.asset(
                          "assets/images/step5.png",
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ],
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: 80,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  child: Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                child: _showContent(context),
              )),
            ],
          ),
        ),
        bottomSheet: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(25),
          child: Padding(
            padding: EdgeInsets.only(),
            child: InkWell(
              onTap: () {
                //print('hello');
                App.showBusy(context);
                 _onNext();
                //print(daftarNson.toJson());
                //Navigator.of(context).pushNamed('/otp', arguments: {'daftarNson': daftarNson});
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
                    'Selanjutnya',
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
      debugShowCheckedModeBanner: false,
    );
  }

  Widget _Combo(IconData icon, String label, id, var firstVal, {Nson val}) {
    List _combo = [];
    /*val
        .asList()
        .length > 0
        ? _combo = val.get('data').asList()
        : _combo.add({'first': 'Select'});*/
    //_combo.add(map);
    _combo = val.get('data').asList();
    print(_combo.toString() + ' and ' + firstVal.toString());
    return Column(children: <Widget>[
      SizedBox(
        height: 15,
      ),
      Container(
        margin: EdgeInsets.only(left: 12, right: 12),
        width: MediaQuery.of(context).size.width - 48,
        child: Text(
          label,
          style: TextStyle(color: Colors.black54),
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width - 48,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: 12,
            ),
            Icon(
              icon,
              color: Colors.black,
            ),
            SizedBox(
              width: 12,
            ),
            Column(mainAxisSize: MainAxisSize.min, children: [
              DropdownButton(
                hint: Container(
                  width: 260,
                  child: Text(''),
                ),
                value: firstVal,
                items: _combo.map((value) {
                  return DropdownMenuItem(
                    child: Text(value['name']),
                    value: value,
                  );
                }).toList(),
                onChanged: (value) {
                  _onSelect(id, value);
                },
              ),
            ]),
          ],
        ),
      )
    ]);
  }

  Widget _Buton(String text, VoidCallback callback) {
    return Column(children: <Widget>[
      SizedBox(
        height: 30,
      ),
      Container(
        child: Padding(
          padding: EdgeInsets.only(),
          child: InkWell(
            onTap: callback,
            /*() {
                  print('hello');
                  AwesomeDialog(
                      context: context,
                      dialogType: DialogType.INFO,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Daftar berhasil',
                      desc: 'Registrasi berhasil',
                      btnOkOnPress: () {},
                      dismissOnTouchOutside: false
                  )..show();

                }*/
            child: new Container(
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              decoration: new BoxDecoration(
                color: Color.fromARGB(255, 148, 193, 44),
                border: new Border.all(
                    color: Color.fromARGB(255, 148, 193, 44), width: 1.0),
                borderRadius: new BorderRadius.circular(10.0),
              ),
              child: new Center(
                child: new Text(
                  text,
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
    ]);
  }

  Widget _Textbox(IconData icon, String label) {
    return Column(children: <Widget>[
      SizedBox(
        height: 15,
      ),
      Container(
        child: Padding(
          padding: EdgeInsets.only(),
          child: TextField(
            style: TextStyle(color: Theme.of(context).accentColor),
            controller: null,
            decoration: InputDecoration(
              labelText: label,
              hintStyle: CustomTextStyle.formField(context),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).accentColor, width: 1.0)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).accentColor, width: 1.0)),
              prefixIcon: Icon(
                icon,
                color: Colors.black,
              ),
            ),
            obscureText: false,
          ),
        ),
      )
    ]);
  }

  Widget _showContent(context) {
    bool syaratketentuan = false;
    return Column(
      children: <Widget>[
        _Combo(
            Icons.credit_card,
            "1. Jumlah kebutuhan kendaraan dalam sebulan? ",
            'kebutuhankendaraan',
            kebutuhanVal,
            val: kebutuhanList),
        _Combo(
            Icons.credit_card,
            "2. Pembelian kebutuhan kendaraan dilakukan? ",
            'pembeliankebutuhankendaraan',
            pembelianVal,
            val: pembelianList),
        _Combo(Icons.call, "3. Minat Jenis Mobil?", 'usiabisnis', minatVal,
            val: minatList),
        _Combo(
            Icons.credit_card,
            "4. Rata-rata jumlah penjualan kendaraan dalam sebulan?",
            'ratapenjualan',
            rataVal,
            val: rataList),
        _Combo(Icons.refresh, "5. Mengetahui Grosir Mobil dari media?",
            'perputaranunit', mediaVal,
            val: mediaList),

        /* _Buton("Selanjutnya" , (){
              print('profile usaha');
              Navigator.of(context).pushNamed('/otp');
            }),
*/
        SizedBox(
          height: 100,
        ),
      ],
    );
  }

  Widget emailErrorText() => Text("Controller.displayErrorEmailLogIn");
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
