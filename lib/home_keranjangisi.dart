import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grosir/Api/apiservice.dart';
import 'dart:io';
import 'package:grosir/Nikita/NsGlobal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grosir/Nikita/Nson.dart';
import 'package:grosir/Nikita/app.dart';
import 'package:grosir/UI/WCounter.dart';
import 'package:grosir/menang_bayar.dart';
import 'package:grosir/menang_pembayar.dart';
import 'package:grosir/tawar.dart';
import 'package:intl/intl.dart';

import 'UI/CustomIcons.dart';
import 'UI/SocialIcons.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    this.label,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(child: Text(label)),
            Checkbox(
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class KeranjangIsi extends StatefulWidget {
  @override
  _KeranjangIsiState createState() => _KeranjangIsiState();
}

class _KeranjangIsiState extends State<KeranjangIsi> {
  Nson nPolupate = Nson.newObject();
  int lead = 0;
  Timer timer;
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  String formatted = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formatted = formatter.format(now);
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) => _fetchData());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future _fetchData() async {
    print('Clock Ticking');
    Nson args = Nson.newObject();
    args.set("page", 1);
    args.set("max", 50);

    Nson nson = await ApiService.get().keranjang(args);
    nPolupate = nson.get("data");

    Nson _listNson = Nson.newArray();

    nPolupate.asList().forEach((val) {
      if (val["end_date"].toString().split(RegExp('\\s+'))[0] == formatted) {
        _listNson.add(val);
      }
    });
    //setState(() {
      nPolupate = _listNson;
    //});
    setState(() {

    });
    App.log(nson.toStream());
  }

  Future<Nson> _reload() async {
    if (App.needBuild) {
      App.needBuild = false;
      _fetchData();
    }
    return Nson.newObject();
  }

  Future _filter({String string}) async {
    Nson args = Nson.newObject();

    args.set("page", 1);
    args.set("max", 50);

    Nson _listNson = Nson.newArray();

    Nson nson = await ApiService.get().keranjang(args);
    nPolupate = nson.get("data");

    nPolupate.asList().forEach((val) {
      if (string == 'live' && val["is_live"] == 1) {
        _listNson.add(val);
        print("$string Live");
      } else if (val["category_name"].toString() == string &&
          val["is_live"] == 0 &&
          val["end_date"].toString().split(RegExp('\\s+'))[0] == formatted) {
        _listNson.add(val);
        print("$string");
      } else if (string == 'Semua' &&
          val["end_date"].toString().split(RegExp('\\s+'))[0] == formatted) {
        _listNson.add(val);
        print("$string Semua");
      }
    });
    setState(() {
      nPolupate = _listNson;
      print(nPolupate.asString());
    });
  }

  Future refreshData() async {
    await _reload();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    App.log("buildkeranjang");
    return Container(
      /*onRefresh: refreshData,*/
      child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Text(
                  "Keranjang",
                  style: TextStyle(
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 28),
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () {
                        final action = CupertinoActionSheet(
                          title: Text(
                            "Filter berdasarkan",
                            style: TextStyle(
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          actions: <Widget>[
                            _ListSpinner("Semua", () {
                              _filter(string: 'Semua');
                            }),
                            _ListSpinner("Penawaran Sedang Berlangsung", () {
                              _filter(string: 'live');
                            }),
                            _ListSpinner("Penawaran Diterima", () {
                              _filter(string: 'Menunggu Cetak Invoice');
                              //"Pembayaran Gagal"
                              //"Menunggu Cetak Invoice"
                            }),
                            _ListSpinner("Penawaran Ditolak", () {
                              _filter(string: 'Pembayaran Gagal');
                            }),
                          ],
                          /*cancelButton: CupertinoActionSheetAction(
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),*/
                        );
                        showCupertinoModalPopup(
                            context: context, builder: (context) => action);
                        //Navigator.of(context).pushNamed('/filter');
                      },
                      child: Image.asset('assets/images/filter.png'),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            _buildWidgetRefresh(),
          ],
        ),
      ),
    );
  }

  Widget _ListSpinner(String text, VoidCallback callback) {
    return CupertinoActionSheetAction(
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Nunito",
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      isDefaultAction: true,
      onPressed: () {
        callback();
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildWidgetRefresh() {
    return FutureBuilder(
      future: _reload(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _listConten();
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner.
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _itemList(int index) {
    Widget item;
    if (nPolupate.getIn(index).get("is_live").asInteger() == 1) {
      //sedang berlangsung
      item = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Text(
              'Penawaran Sedang Berlangsung',
              //nPolupate.getIn(index).get("category_name").asString(),
              style: const TextStyle(
                fontSize: 11.0,
                fontFamily: "Nunito",
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          _bisatawar(index),
        ],
      );
    } else {
      item = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Text(
              nPolupate.getIn(index).get("is_live").asInteger() == 1
                  ? 'Penawaran Sedang Berlangsung'
                  : nPolupate.getIn(index).get("category_name").asString(),
              style: const TextStyle(
                fontSize: 11.0,
                fontFamily: "Nunito",
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          _siapbayar(index),
        ],
      );
    }
    return item;
  }

  Widget _listConten() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: _itemList(index),
                );
              },
              itemCount: nPolupate.size(),
            ),
          ),
          nPolupate.size() >= 1 ? Container() : _keranjangkosong(),
        ],
      ),
    );
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

  void setFavUnFav(Nson data, int fav) async {
    const int max = 50;

    int favNow = (fav == 1 ? 0 : 1);

    Nson args = Nson.newObject();
    args.set("userid", await App.getSetting("userid"));
    args.set("kik", data.get("kik").asString());
    args.set("agreement_no", data.get("agreement_no").asString());
    args.set("gm_openhouse_id", data.get("ohid").asString());
    args.set("isfavorit", favNow);
    App.log(data.toStream());
    App.log(args.toStream());
    Nson nson = await ApiService.get().setAndUnsetFavoriteApi(args);
    App.log(nson.toStream());

    //{"message":"success","description":"Sukses menambah favorite"}
    if (nson.get("message").asString() == "success") {
      data.set("IsFavorit", favNow);
      App.needBuild = true;
      setState(() {});
    }

    //refreshData();
  }

  double tertinggi(Nson data) {
    if (data.get("tertinggi").asDouble() == 0) {
      return data.get("bottom_price").asDouble();
    }
    return data.get("tertinggi").asDouble();
  }

  Widget _keranjangkosong() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          /*Container(
              alignment: Alignment.centerLeft,
              child: Text("Keranjang", textAlign: TextAlign.center,style: TextStyle(
                  fontFamily: "Nunito", fontWeight: FontWeight.w700,
                  fontSize: 28
              ),),),*/

          SizedBox(
            height: 40,
          ),
          Text(
            "Keranjang Anda kosong",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w500,
                fontSize: 22),
          ),
          SizedBox(
            height: 20,
          ),
          Image.asset("assets/images/keranjang_kosong.png"),
          SizedBox(
            height: 20,
          ),
          Text(
              "Anda belum melakukan penawaran. ???Telusuri semua kendaraan yang kami tawarkan dan lakukan tawar/buy now",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Nunito",
                color: Color.fromARGB(255, 143, 143, 143),
                fontWeight: FontWeight.w500,
                height: 1.5,
                fontSize: 14,
              )),
          SizedBox(
            height: 10,
          ),
          _Buton("Telusuri Kendaraan", () {}),
        ],
      ),
    );
  }

  Widget _bisatawar(int index) {
    Color color = Colors.white;
    return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            side: BorderSide(width: 1, color: color)),
        color: color,
        margin: EdgeInsets.all(0.0),
        child: Container(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                    height: 250,
                    margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15)),
                      child: Image.network(
                        nPolupate.getIn(index).get("foto").asString(),
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  padding: EdgeInsets.only(top: 5, right: 5),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.55,
                                child: Text(
                                  nPolupate
                                      .getIn(index)
                                      .get("vehicle_name")
                                      .asString(),
                                  //overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.0,
                                  ),
                                ),
                                margin: EdgeInsets.only(right: 30),
                              ),
                              Row(
                                children: [
                                  Text(
                                    nPolupate
                                        .getIn(index)
                                        .get("kik")
                                        .asString(),
                                    style: const TextStyle(
                                      fontSize: 11.0,
                                      fontFamily: "Nunito",
                                      color: Color.fromARGB(255, 143, 143, 143),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    nPolupate
                                        .getIn(index)
                                        .get("Oto_json")
                                        .get("Lokasi")
                                        .asString()
                                        .split(RegExp('\\s+'))[1],
                                    style: const TextStyle(
                                      fontSize: 11.0,
                                      fontFamily: "Nunito",
                                      color: Color.fromARGB(255, 230, 36, 44),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Harga Awal',
                                style: const TextStyle(
                                  fontSize: 11.0,
                                  fontFamily: "Nunito",
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Rp.' +
                                    App.formatCurrency(nPolupate
                                        .getIn(index)
                                        .get("bottom_price")
                                        .asDouble()),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Harga Sekarang',
                                style: const TextStyle(
                                  fontSize: 11.0,
                                  fontFamily: "Nunito",
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Rp.' +
                                    App.formatCurrency(nPolupate
                                        .getIn(index)
                                        .get("tertinggi")
                                        .asDouble()),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Admin Fee',
                                style: const TextStyle(
                                  fontSize: 11.0,
                                  fontFamily: "Nunito",
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Rp.' +
                                    App.formatCurrency(nPolupate
                                        .getIn(index)
                                        .get("adminfee")
                                        .asDouble()),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Container(
                              alignment: Alignment.centerRight,
                              child: Column(
                                children: [
                                  /* CircleAvatar(
                                child:  Icon(Icons.favorite_border),
                                backgroundColor: Colors.white,),
*/
                                  InkWell(
                                    onTap: () {
                                      App.log(index);
                                      setFavUnFav(
                                          nPolupate.getIn(index),
                                          nPolupate
                                              .getIn(index)
                                              .get("IsFavorit")
                                              .asInteger());
                                    },
                                    child: CircleAvatar(
                                      child: Icon(nPolupate
                                                  .getIn(index)
                                                  .get("IsFavorit")
                                                  .asInteger() ==
                                              1
                                          ? Icons.favorite
                                          : Icons.favorite_border),
                                      backgroundColor: Colors.white,
                                      foregroundColor: nPolupate
                                                  .getIn(index)
                                                  .get("IsFavorit")
                                                  .asInteger() ==
                                              1
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                  ),
                                  CircleAvatar(
                                    child: Text(
                                      nPolupate
                                          .getIn(index)
                                          .get("grade")
                                          .asString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                    ),
                                    backgroundColor:
                                        Color.fromARGB(255, 230, 36, 44),
                                  ),
                                ],
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      WCounter(
                        builds: (value, duration) => Container(
                          margin: EdgeInsets.only(right: 5),
                          child: Padding(
                            padding: EdgeInsets.only(),
                            child: new Container(
                              width: MediaQuery.of(context).size.width,
                              height: 25.0,
                              decoration: new BoxDecoration(
                                color: Colors.red,
                                border: new Border.all(
                                    color: Colors.red, width: 1.0),
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              child: new Center(
                                child: Container(
                                  color: Colors.red,
                                  margin: EdgeInsets.only(right: 10),
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        value,
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        start:
                            nPolupate.getIn(index).get("end_date").asString(),
                        lead: lead,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      /*Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: () {
                                double i =
                                    tertinggi(nPolupate.getIn(index)) - 500000;
                                nPolupate.getIn(index).set("tertinggi", i);
                                setState(() {});
                              },
                              child: Icon(
                                Icons.remove_circle_outline,
                                size: 32,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 50,
                            right: 50,
                            bottom: 1,
                            top: 1,
                            child: Container(
                              padding: EdgeInsets.only(bottom: 5),
                              *//*  width: MediaQuery.of(context).size.width - 120,*//*
                              child: TextField(
                                enabled: false,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).accentColor),
                                controller: TextEditingController(
                                    text: "Rp. " +
                                        App.formatCurrency(
                                            tertinggi(nPolupate.getIn(index)))),
                                decoration: InputDecoration(
                                  //hintStyle: CustomTextStyle.formField(context),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).accentColor,
                                          width: 1.0)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).accentColor,
                                          width: 1.0)),
                                ),
                                obscureText: false,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                double i =
                                    tertinggi(nPolupate.getIn(index)) + 500000;
                                nPolupate.getIn(index).set("tertinggi", i);
                                setState(() {});
                              },
                              child: Icon(
                                Icons.add_circle_outline,
                                size: 32,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),*/
                      SizedBox(
                        height: 5,
                      ),
                      _butontawar("Tawar", '', Color.fromARGB(255, 10, 132, 254), () {
                        lanjutTawar(index);
                      }),
                      _butontawar("Buy Now", 'Rp. '+ App.formatCurrency(nPolupate.getIn(index).get('open_price').asDouble()), Color.fromARGB(255, 148, 193, 44), () {
                        //buyNow(index);
                        _buyConfirm(index);
                      })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buttonGreen(String text) {
    return Column(children: <Widget>[
      Container(
        child: Padding(
          padding: EdgeInsets.only(),
          child: new Container(
            width: MediaQuery.of(context).size.width,
            height: 40.0,
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
                    fontSize: 12.0,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  Future buyNow(int index) async {
    App.Arguments.set("args", nPolupate.getIn(index));
    Nson data = nPolupate.getIn(index);
    //LiveBuyNowMobile
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
                      '??? seharga??? Rp ' +
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
                  //disini
                  _filter(string: 'Semua').then((value) =>
                      Navigator.of(context).pop());
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

  Widget _butontawar(String text, price, Color color,  VoidCallback callback) {
    return Column(children: <Widget>[
      Container(
        margin: EdgeInsets.all(2),
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
              height: 30.0,
              decoration: new BoxDecoration(
                color: color,
                border: new Border.all(
                    color: color, width: 1.0),
                borderRadius: new BorderRadius.circular(10.0),
              ),
              child: new Center(
                child: new Text(
                  '$text $price',
                  style: new TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  Future _buyConfirm(int index){
    Nson args = nPolupate.getIn(index);
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.NO_HEADER,
        animType: AnimType.BOTTOMSLIDE,
        dismissOnTouchOutside: true,
        body: Column(
          children: [
            Text('Apakah anda ingin??? Buy Now ? ',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: "Nunito",
                    height: 1.2,
                    fontSize: 22)),
            SizedBox(height: 10),
            Text(
                args.get("vehicle_name").asString() +
                    '??? seharga??? Rp ' +
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
              onTap: (){
                buyNow(index);
                Navigator.of(context).pop();
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
        ),)
        .show();
  }

  Widget _siapbayar(int index) {
    Color color = Colors.white;
    return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            side: BorderSide(width: 1, color: color)),
        color: color,
        margin: EdgeInsets.all(0.0),
        child: Container(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                    height: 180,
                    margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15)),
                      child: Image.network(
                        nPolupate.getIn(index).get("foto").asString(),
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  padding: EdgeInsets.only(top: 10, right: 5),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.55,
                                child: Text(
                                  nPolupate
                                      .getIn(index)
                                      .get("vehicle_name")
                                      .asString(),
                                  //overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.0,
                                  ),
                                ),
                                margin: EdgeInsets.only(right: 30),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 3),
                                child: Row(
                                  children: [
                                    Text(
                                      nPolupate
                                          .getIn(index)
                                          .get("kik")
                                          .asString(),
                                      style: const TextStyle(
                                        fontSize: 11.0,
                                        fontFamily: "Nunito",
                                        color:
                                            Color.fromARGB(255, 143, 143, 143),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      nPolupate
                                          .getIn(index)
                                          .get("Oto_json")
                                          .get("Lokasi")
                                          .asString()
                                          .split(RegExp('\\s+'))[1],
                                      style: const TextStyle(
                                        fontSize: 11.0,
                                        fontFamily: "Nunito",
                                        color:
                                            Color.fromARGB(255, 148, 193, 44),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Dimenangkan seharga',
                                style: const TextStyle(
                                  fontSize: 11.0,
                                  fontFamily: "Nunito",
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                'Rp.' +
                                    App.formatCurrency(nPolupate
                                        .getIn(index)
                                        .get("tertinggi")
                                        .asDouble()),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Admin Fee',
                                style: const TextStyle(
                                  fontSize: 11.0,
                                  fontFamily: "Nunito",
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                'Rp.' +
                                    App.formatCurrency(nPolupate
                                        .getIn(index)
                                        .get("adminfee")
                                        .asDouble()),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Total Pembayaran',
                                style: const TextStyle(
                                  fontSize: 11.0,
                                  fontFamily: "Nunito",
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                'Rp.' +
                                    App.formatCurrency(nPolupate
                                        .getIn(index)
                                        .get("totalbayar")
                                        .asDouble()),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: CircleAvatar(
                                child: Text(
                                  nPolupate
                                      .getIn(index)
                                      .get("grade")
                                      .asString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                                backgroundColor:
                                    Color.fromARGB(255, 148, 193, 44),
                              ),
                            ),
                          ), //grade
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      InkWell(
                        onTap: () {
                          lanjutPembayaran(index);
                        },
                        child: _buttonGreen("Lanjut Pembayaran"),
                      ),
                      /* _buttonGreen(  "Lanjut Pembayaran", () {
                      App.log(index);
                      lanjutPembayaran(index);
                    }),*/
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void tawar(Nson data) async {
    //LiveNegoMobile
    Map m = {
      "open_house_id": 932, //ohid
      "kik": 1, //kik
      "agreement_no": "5672000775", //agreement_no
      "bid_price": 76200000
    };
    double bidPrice=data.get("tertinggi").asDouble()+500000;
    Nson args = Nson.newObject();
    args.set("open_house_id", data.get("ohid").asString());
    args.set("kik", data.get("kik").asString());
    args.set("agreement_no", data.get("agreement_no").asString());
    args.set("bid_price", bidPrice);
    App.log(args.toStream());

    App.showBusy(context);
    Nson nson = await ApiService.get().liveNegoApi(args);
    App.log(nson.toStream());

    Navigator.pop(context);
    if (nson.get("message").asString() == 'success') {
      //refreshData();
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
                      '??? seharga??? Rp ' +
                      App.formatCurrency(bidPrice),
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
                onTap: () async {
                  await _filter(string: 'Semua').then((value) => Navigator.of(context).pop());
                  print('hello');

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
          btnOkOnPress: () async {
            await refreshData().then((value) => Navigator.of(context).pop());
          },
          dismissOnTouchOutside: false)
        ..show();
    } else {
      App.showError(nson.get("description").asString());
    }
  }

  void lanjutTawar(int index) async {
    App.Arguments.set("args", nPolupate.getIn(index));
    tawar(nPolupate.getIn(index));
    /*  Navigator.push(context, new MaterialPageRoute(
        builder: (context) =>
        new Tawar()));*/
/*
    Navigator.of(context)
        .pushNamed("/tawar", arguments: nPolupate.getIn(index).asMap());*/
    /*setState(() {
      Navigator.pushNamed(
          context, "/tawar" ,
          arguments :  nPolupate.getIn(index).asMap());

    });*/
  }

  void lanjutPembayaran(int index) async {
    /* Navigator.push(context, new MaterialPageRoute(
        builder: (context) =>
        new MyHomePage())
    );


    Navigator.of(context).pushNamed('/home-page');
  //or
    Navigator.pushedName(context, '/home-page');*/

    /* Navigator.pushNamed(
        context, "/menangpembayar" ,
        arguments :  nPolupate.getIn(index).asMap());*/

    /*Nson args = Nson.newObject();
    args.set("pilihBANK", "BCA");
    args.set("totamount", 100000000);
    args.set("pilihunitbayar", Nson.newArray().add(  Nson.newObject().set("kik", nPolupate.getIn(index).get("kik").asString()).
              set("bayar", 100000000)
    ));


    App.log(args.toStream());

    App.showBusy(context);
    Nson nson = await ApiService.get().generateVaApi(args) ;
    App.log(nson.toStream());

    //Navigator.pop(context);
    if (nson.get("message").asString() == 'success'){

    }else{

    }*/

    App.Arguments.set("args", nPolupate.getIn(index));
    /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MenangBayar(), settings: RouteSettings(arguments: nPolupate.getIn(index).asMap() ),
        ) ); */
    //App.log(context);
    Nson _nArray = Nson.newArray();
    _nArray.add(nPolupate.getIn(index));
    Navigator.of(context)
        //.pushNamed("/menangbayar", arguments: nPolupate.getIn(index).asMap());
        .pushNamed(  "/menangbayar", arguments:  Nson.newObject().set("array", _nArray).asMap());
  }
}
