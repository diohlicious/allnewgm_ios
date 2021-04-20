import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grosir/Api/apiservice.dart';
import 'dart:io';
import 'package:grosir/Nikita/NsGlobal.dart';
import 'package:grosir/Nikita/app.dart';

import 'Nikita/Nson.dart';
import 'UI/CustomIcons.dart';
import 'UI/SocialIcons.dart';
import 'model/tipe_usaha_model.dart';

class ProfilUsaha extends StatefulWidget {
  @override
  _ProfilUsahaState createState() => _ProfilUsahaState();
}

class _ProfilUsahaState extends State<ProfilUsaha> {
  Nson daftarNson = Nson.newObject();
  Usaha _valGender;
  List<Usaha> _combo = <Usaha>[];
  TextEditingController dealerNameCtrler = TextEditingController();
  TextEditingController dealerPhoneCtrler = TextEditingController();
  List typeUsahaList = [];

  @override
  void initState() {
    super.initState();
    this._onLoading();
  }

  Future<Nson> _setArgs() async {
    daftarNson.set("tipeusaha", _valGender.code);
    daftarNson.set("namadealer", dealerNameCtrler.text);
    daftarNson.set("notelpondealer", dealerPhoneCtrler.text);
    return daftarNson;
  }

  void _onNext() async {
    _valGender.code.length == 0
        ? App.showDialogBox(context, "Mohon Pilih Tipe Usaha", "",
            onClick: () async {
            Navigator.of(context).pop();
          })
        : dealerNameCtrler.text.length == 0
            ? App.showDialogBox(context, "Mohon Input Nama Dealer", "",
                onClick: () async {
                Navigator.of(context).pop();
              })
            : dealerPhoneCtrler.text.length == 0
                ? App.showDialogBox(context, "Mohon Input Nomor Dealer", "",
                    onClick: () async {
                    Navigator.of(context).pop();
                  })
                : _setArgs().then((value) => Navigator.of(context)
                    .pushNamed('/dokumen', arguments: {"daftarNson": value}));
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
            "Profil Usaha",
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
                          "assets/images/step2.png",
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
                print('hello');
                _onNext();
                //Navigator.of(context).pop();
                //Navigator.of(context).pushNamed('/dokumen', arguments: daftarNson);
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

  void _testPrint() async {
    print('ok');
  }

  Future _onLoading() async {
    //App.showBusy(context);
    ApiService apiService = ApiService();

    //var response = await apiService.loginMasuk("baihakitanjung12@gmail.com", "123456789") ;
    var response = await apiService.tipeusaha();
    print(response.body);
    //Navigator.pop(context); //pop dialog
    if (response.statusCode == 200) {
      //Nson nson = Nson(response.body);
      Nson nson = await apiService.getNson(response);
      setState(() {
        typeUsahaList.addAll(nson.get('data').asList());

        typeUsahaList.forEach((value) {
          Usaha usaha = new Usaha(value["code"], value["name"]);
          _combo.add(usaha);
          print('ini dari atas combo ' + usaha.toString());
        });
        _valGender = _combo[0];
        //_valGender = Usaha(nson.get('data').getIn(0).get('code').asString(), nson.get('data').getIn(0).get('name').asString());
      });
    } else {
      App.showDialogBox(context, "Verifikasi Gagal", "Gagal",
          onClick: () async {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed('/andaberhasil'); //bypass
      });
    }
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

  Widget _Combo(IconData icon, List list) {
    //List _combo = list;
    return Column(children: <Widget>[
      SizedBox(
        height: 15,
      ),
      Container(
        width: MediaQuery.of(context).size.width,
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
              DropdownButton<Usaha>(
                hint: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(''),
                ),
                value: _valGender,
                items: _combo.map((Usaha usaha) {
                  //List<User> users =
                  return DropdownMenuItem(
                    child: Text(usaha.name),
                    value: usaha,
                  );
                }).toList(),
                onChanged: (Usaha value) {
                  setState(() {
                    _valGender = value;
                    //_valcode = value["code"];
                  });
                  print(_valGender.code);
                },
              ),
            ]),
          ],
        ),
      )
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
        _Combo(Icons.add_business, _combo),
        SizedBox(
          height: 15,
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              style: TextStyle(color: Theme.of(context).accentColor),
              controller: dealerNameCtrler,
              decoration: InputDecoration(
                labelText: 'Nama Dealer',
                hintStyle: CustomTextStyle.formField(context),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).accentColor, width: 1.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).accentColor, width: 1.0)),
                prefixIcon: Icon(
                  Icons.add_business,
                  color: Colors.black,
                ),
              ),
              obscureText: false,
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              keyboardType: TextInputType.phone,
              style: TextStyle(color: Theme.of(context).accentColor),
              controller: dealerPhoneCtrler,
              decoration: InputDecoration(
                labelText: 'Nomor Telepon Dealer',
                hintStyle: CustomTextStyle.formField(context),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).accentColor, width: 1.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).accentColor, width: 1.0)),
                prefixIcon: Icon(
                  Icons.phone,
                  color: Colors.black,
                ),
              ),
              obscureText: false,
            ),
          ),
        ),
        SizedBox(
          height: 100,
        ),
        /* _Buton("Selanjutnya" , (){
              print('profile usaha');
              Navigator.of(context).pushNamed('/dokumen');
            }),*/

        SizedBox(
          height: 10,
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
