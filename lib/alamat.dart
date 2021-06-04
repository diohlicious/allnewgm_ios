import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:grosir/Api/apiservice.dart';
import 'dart:io';
import 'package:grosir/Nikita/NsGlobal.dart';
import 'package:grosir/Nikita/app.dart';

import 'Nikita/Nson.dart';
import 'UI/CustomIcons.dart';
import 'UI/SocialIcons.dart';
import 'UI/function_util.dart';

class Alamat extends StatefulWidget {
  @override
  _AlamatState createState() => _AlamatState();
}

class _AlamatState extends State<Alamat> {
  Nson daftarNson = Nson.newObject();
  TextEditingController alamatCtrler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute
        .of(context)
        .settings
        .arguments as Map;
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
            "Alamat",
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
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        margin: const EdgeInsets.only(left: 1.0, right: 1.0),
                        child: Image.asset(
                          "assets/images/step4.png",
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ],
                  ),
                ),
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
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
          width: MediaQuery
              .of(context)
              .size
              .width,
          margin: EdgeInsets.all(25),
          child: Padding(
            padding: EdgeInsets.only(),
            child: InkWell(
              onTap: () {
                //print('hello');
                _onNext();

                //Navigator.of(context).pushNamed('/daftarpertanyaan');
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

  Map mPropinsi = new Map();
  Nson nProvinsiList = Nson.newArray();
  Nson nKotaList = Nson.newArray();
  Nson nKecamatanList = Nson.newArray();
  Nson nKelurahanList = Nson.newArray();
  var nProvinsiFirst;
  var nKotaFirst;
  var nKecamatanFirst;
  var nKelurahanFirst;

  @override
  void initState() {
    super.initState();
    _onLoading();
  }

  Future<String> _onLoading() async {
    //App.showBusy(context);
    ApiService apiService = ApiService();
    //var response = await apiService.loginMasuk("baihakitanjung12@gmail.com", "123456789") ;
    var response = await apiService.Propinsi();
    mPropinsi = jsonDecode(response.body);
    mPropinsi["data"].forEach((value) {
      Nson nson = Nson.newObject();
      nson.set("province_name", value["province_name"]);
      nson.set("province_name_en", value["province_name_en"]);
      nson.set("province_code", value["province_code"]);
      setState(() {
        nProvinsiList.add(nson);
        nProvinsiFirst = nProvinsiList.getIn(0).asMap();
      });
    });

    //response = await apiService.Kabupaten(province_code:) ;
    //mPropinsi = jsonDecode(response.body);

    //Navigator.pop(context); //pop dialog
    if (response.statusCode == 200) {
      //berhasil disini
    } else {
      App.showDialogBox(context, "Verifikasi Gagal", "Gagal",
          onClick: () async {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/andaberhasil'); //bypass
          });
    }

    return "";
  }

  String comboStr(String label) {
    switch (label) {
      case 'Provinsi':
        return 'province_name'; //HomeView();
      case 'Kabupaten':
        return 'city';
      case 'Kecamatan':
        return 'sub_district';
      case 'Kelurahan':
        return 'urban';
      case 'Kodepos':
        return 'postal_code';
      default:
        return 'first';
    }
  }

  Widget _Combo(IconData icon, label, var firstVal, {Nson val}) {
    List _combo = [];
    //_combo.add({'first':''});
    val
        .asList()
        .length > 0
        ? _combo = val.asList()
        : _combo.add({'first': 'Select'});
    //_combo.add({'first':''});
    return Column(children: <Widget>[
      SizedBox(
        height: 15,
      ),
      Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Row(
          //mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: 12,
            ),
            Icon(
              icon,
              color: Colors.black,
            ),
            SizedBox(
              width: 10,
            ),
            Column(mainAxisSize: MainAxisSize.max, children: [
              DropdownButton(
                hint: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.6,
                  child: Text(label),
                ),
                value: firstVal ?? _combo[0],
                items: _combo.map((value) {
                  //List<User> users =
                  return DropdownMenuItem(
                    child: Text(value[comboStr(label)] ?? value['first']),
                    value: value,
                  );
                }).toList(),
                onChanged: (value) {
                  _onSelect(label, value);
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
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
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
            style: TextStyle(color: Theme
                .of(context)
                .accentColor),
            controller: alamatCtrler,
            decoration: InputDecoration(
              labelText: label,
              hintStyle: CustomTextStyle.formField(context),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme
                          .of(context)
                          .accentColor, width: 1.0)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme
                          .of(context)
                          .accentColor, width: 1.0)),
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

  void _onSelect(String field, var _nSelectedVal) async {
    ApiService apiService = ApiService();
    if (FunctionUtil.equalsIgnoreCase(field, 'provinsi')) {
      var response = await apiService.Kabupaten(
          province_code: _nSelectedVal["province_code"]);
      Map map = jsonDecode(response.body);
      setState(() {
        nProvinsiFirst = _nSelectedVal;
        nKotaList = Nson(map['data']);
        nKotaFirst = nKotaList.getIn(0).asMap();
        nKecamatanList = Nson.newArray();
        nKelurahanList = Nson.newArray();
        nKecamatanFirst = null;
        nKelurahanFirst = null;
      });
      daftarNson.set("propinsi", _nSelectedVal["province_name"]);
      print(nKotaList.asString());
    }
    if (FunctionUtil.equalsIgnoreCase(field, 'kabupaten')) {
      //nKotaFirst =_nSelectedVal;
      var response = await apiService.Kecamatan(city: _nSelectedVal["city"]);
      Map map = jsonDecode(response.body);
      setState(() {
        nKotaFirst = _nSelectedVal;
        nKecamatanList = Nson(map['data']);
        nKecamatanFirst = nKecamatanList.getIn(0).asMap();
        nKelurahanList = Nson.newArray();
        nKelurahanFirst = null;
      });
      daftarNson.set("kabupaten", _nSelectedVal["city"]);
      print(nKecamatanList.asString());
    }
    if (FunctionUtil.equalsIgnoreCase(field, 'kecamatan')) {
      var response = await apiService.Kelurahan(
          city: nKotaFirst["city"],
          sub_district: _nSelectedVal["sub_district"]);
      Map map = jsonDecode(response.body);
      setState(() {
        nKecamatanFirst = _nSelectedVal;
        nKelurahanList = Nson(map['data']);
        nKelurahanFirst = nKelurahanList.getIn(0).asMap();
        daftarNson.set('kelurahan',nKelurahanFirst["urban"]);
        daftarNson.set('kodepos',nKelurahanFirst["postal_code"]);
      });
      daftarNson.set("kecamatan", _nSelectedVal["sub_district"]);
      print(nKelurahanList.asString());
    }
    if (FunctionUtil.equalsIgnoreCase(field, 'kelurahan')) {
      setState(() {
        nKelurahanFirst = _nSelectedVal;
      });
      daftarNson.set("kelurahan", _nSelectedVal["urban"]);
      daftarNson.set("kodepos", _nSelectedVal["postal_code"]);
      print(nKelurahanList.asString());
    }
  }

  void _onNext() {
    alamatCtrler.text.length < 7
        ? App.showDialogBox(
        context, "Mohon Isi Alamat Valid", "", onClick: () async {
      Navigator.of(context).pop();
    })
        : nKotaFirst == null
        ? App.showDialogBox(context, "Mohon Pilih Kota", "",
        onClick: () async {
          Navigator.of(context).pop();
        })
        : nKecamatanFirst == null
        ? App.showDialogBox(context, "Mohon Pilih Kecamatan", "",
        onClick: () async {
          Navigator.of(context).pop();
        })
        : daftarNson.get('kelurahan').asString().length == 0 ? App.showDialogBox(context, "Mohon Pilih Kelurahan", "",
        onClick: () async {
          Navigator.of(context).pop();
        }): _setArgs().then((value) => Navigator.of(context)
        .pushNamed('/daftarpertanyaan', arguments: {"daftarNson": value}));
  }

  Future<Nson> _setArgs() async {
    daftarNson.set("alamat", alamatCtrler.text);
    daftarNson.set('verif', '2');
    daftarNson.set('konfirmasi_by', '');
    return daftarNson;
  }

  Widget _showContent(context) {
    bool syaratketentuan = false;
    return Column(
      children: <Widget>[
        _Textbox(Icons.location_on, "Alamat Lengkap"),
        _Combo(Icons.location_on, "Provinsi", nProvinsiFirst,
            val: nProvinsiList),
        _Combo(Icons.location_on, "Kabupaten", nKotaFirst, val: nKotaList),
        _Combo(Icons.location_on, "Kecamatan", nKecamatanFirst,
            val: nKecamatanList),
        _Combo(Icons.location_on, "Kelurahan", nKelurahanFirst,
            val: nKelurahanList),
        _Combo(Icons.location_on, "Kodepos", nKelurahanFirst,
            val: nKelurahanList),

        /* _Buton("Selanjutnya" , (){
              print('profile usaha');
              Navigator.of(context).pushNamed('/daftarpertanyaan');
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
    return Theme
        .of(context)
        .textTheme
        .title
        .copyWith(
        fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.white);
  }

  static TextStyle title(BuildContext context) {
    return Theme
        .of(context)
        .textTheme
        .title
        .copyWith(
        fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white);
  }

  static TextStyle subTitle(BuildContext context) {
    return Theme
        .of(context)
        .textTheme
        .title
        .copyWith(
        fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white);
  }

  static TextStyle button(BuildContext context) {
    return Theme
        .of(context)
        .textTheme
        .title
        .copyWith(
        fontSize: 20, fontWeight: FontWeight.normal, color: Colors.white);
  }

  static TextStyle body(BuildContext context) {
    return Theme
        .of(context)
        .textTheme
        .title
        .copyWith(
        fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white);
  }
}
