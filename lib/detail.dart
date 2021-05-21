import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grosir/Api/apiservice.dart';
import 'dart:io';
import 'package:grosir/Nikita/NsGlobal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grosir/Nikita/Nson.dart';
import 'package:grosir/Nikita/app.dart';
import 'package:grosir/UI/WCounter.dart';

import 'UI/CustomIcons.dart';
import 'UI/SocialIcons.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Detail extends StatefulWidget {
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Nson mySLides = Nson.newArray();
  int slideIndex = 0;
  PageController controller;
  Nson nPopulate = Nson.newArray();
  String ohid = "";
  String kik = "";
  Nson args = Nson.newObject();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //controller = new PageController();
    controller = new PageController(
      initialPage: slideIndex,
      keepPage: false,
      viewportFraction: 0.7,
    );
  }

  void showImage(String title, String url, Nson raw, int index) {
    Navigator.pushNamed(context, "/viewer",
        arguments: {'nama': title, 'url': url, 'raw': raw, 'index': index});
  }

  Future<Nson> _reload() async {
    const int max = 50;

    //live
    Nson args = Nson.newObject();
    args.set("ohid", ohid);
    args.set("kik", kik);

    Nson nson = await ApiService.get().liveVehicleDetailApi(args);
    nPopulate = nson.get("data");
    //String s = nson.toJson();
    App.log(nson.toStream());

    nson = await ApiService.get().timeServerApi(args);
    App.log(nson.get("data").get("time_server").asString());
    int lead = App.wcounterlead(nson.get("data").get("time_server").asString());
    nPopulate.set("lead", lead);

    mySLides = nPopulate.get("images");

    return Nson.newObject();
  }

  void tawar(Nson args, nPopulate) {
    Navigator.pushNamed(
      context,
      "/tawar",
      arguments: {'args': args.asMap(), 'populate': nPopulate.asMap()},
    );
  }

  void setFavUnFav(Nson data, int fav) async {
    const int max = 50;

    Nson args = Nson.newObject();
    args.set("userid", await App.getSetting("userid"));
    args.set("kik", data.get("kik").asString());
    args.set("agreement_no", data.get("agreementno").asString());
    args.set("gm_openhouse_id", data.get("openhouseid").asString());
    args.set("isfavorit", fav == 1 ? 0 : 1);

    Nson nson = await ApiService.get().setAndUnsetFavoriteApi(args);
    App.log(nson.toStream());

    await _reload();

    setState(() {});
  }

  Widget _Content() {
    return SingleChildScrollView(
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
    );
  }
  List<bool> _isOpen = [false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    App.log("buildDetail");
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    args = Nson(arguments);
    App.log(args.asString());

    ohid = args.get("ohid").asString();
    kik = args.get("kik").asString();

    return FutureBuilder<Nson>(
      future: _reload(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "",
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    fontSize: 28),
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
              actions: [
                IconButton(
                  icon: CircleAvatar(
                    child: Icon(nPopulate.get("is_favorite").asInteger() == 1
                        ? Icons.favorite
                        : Icons.favorite_border),
                    backgroundColor: Colors.white,
                    foregroundColor:
                        nPopulate.get("is_favorite").asInteger() == 1
                            ? Colors.red
                            : Colors.grey,
                  ),
                  /* Image.asset(
                "assets/images/fav.png",
                fit: BoxFit.cover,
              ),*/
                  onPressed: () {
                    // do something

                    setFavUnFav(
                        nPopulate, nPopulate.get("is_favorite").asInteger());
                  },
                )
              ],
            ),
            resizeToAvoidBottomInset: false,
            body: _Content(),
            bottomSheet: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(25),
              child: Padding(
                padding: EdgeInsets.only(),
                child: InkWell(
                  onTap: () {
                    print('hello');
                    //Navigator.of(context).pushNamed('/tawar');
                    args.set("lead", nPopulate.get("lead").asInteger());
                    args.set(
                        "start_date", nPopulate.get("start_date").asString());
                    tawar(args, nPopulate);
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
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Text("${snapshot.error}"),
          );
        }

        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
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

  List<Widget> getChilds(String key) {
    List<Widget> children = List();
    for (var i = 0; i < nPopulate.get(key).size(); i++) {
      children.add(textViewIcon(
          context,
          nPopulate.get(key).getIn(i).get("item").asString(),
          nPopulate.get(key).getIn(i).get("description").asString(),
          nPopulate.get(key).getIn(i).get("status").asString() == '1'));
    }
    return children;
  }

  List<Widget> getChildsImage() {
    String key = 'image_broken';
    List<Widget> children = List();
    for (var i = 0; i < nPopulate.get(key).size(); i = i + 2) {
      children.add(imageViewOnly(
          nPopulate.get(key).getIn(i),
          i + 1 >= nPopulate.get(key).size()
              ? Nson(null)
              : nPopulate
                  .get(key)
                  .getIn(i + 1 < nPopulate.get(key).size() ? i + 1 : i)));
    }

    return children;
  }

  Widget _content(context) {
    /*List<Widget> children = List ();
    for (var i = 0; i < nPopulate.get("vehicle_body").size(); i++) {
      children.add(textViewIcon(context, nPopulate.get("vehicle_body").getIn(i).get("item").asString(), nPopulate.get("vehicle_body").getIn(i).get("description").asString(),  nPopulate.get("vehicle_body").getIn(i).get("status").asString() == '1') );
    }*/
    //bool _isExpanded = false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(right: 20),
                width: MediaQuery.of(context).size.width * 0.80,
                child: Text(nPopulate.get("vehicle_name").asString(),
                    //overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 22)),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(top: 0, right: 5),
                child: CircleAvatar(
                  child: Text(
                    nPopulate.get("grade").asString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  backgroundColor: Color.fromARGB(255, 230, 36, 44),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(nPopulate.get("kik").asString(),
                style: TextStyle(
                    fontFamily: "Nunito",
                    color: Color.fromARGB(255, 143, 143, 143),
                    fontWeight: FontWeight.w500,
                    fontSize: 16)),
            SizedBox(
              width: 5,
            ),
            Text("Jakarta",
                style: TextStyle(
                    color: Color.fromARGB(255, 230, 36, 44),
                    fontWeight: FontWeight.w500,
                    fontSize: 16)),
          ],
        ),

        SizedBox(
          height: 20,
        ),

        Text("Harga awal",
            style: TextStyle(
                fontFamily: "Nunito",
                color: Color.fromARGB(255, 143, 143, 143),
                fontWeight: FontWeight.w500,
                fontSize: 15)),
        SizedBox(
          height: 10,
        ),
//nPopulate.get("kik").asString()
        Text('Rp.' + App.formatCurrency(nPopulate.get("harga_awal").asDouble()),
            style: TextStyle(
                fontFamily: "Nunito",
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 20)),
        SizedBox(
          height: 10,
        ),
        Text("Harga sekarang",
            style: TextStyle(
                fontFamily: "Nunito",
                color: Color.fromARGB(255, 143, 143, 143),
                fontWeight: FontWeight.w500,
                fontSize: 15)),

        SizedBox(
          height: 10,
        ),

        Stack(
          children: [
            Text(
              'Rp.' +
                  App.formatCurrency(nPopulate.get("PriceNow").asDouble()),
              style: const TextStyle(
                  fontFamily: "Nunito",
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                color: Colors.red,
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
                    WCounter(
                      builds: (value, duration) => Text(
                        value,
                        style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      start: nPopulate.get("end_date").asString(),
                      lead: nPopulate.get("lead").asInteger(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),

        SizedBox(
          height: 10,
        ),

        //viewpager
        Container(
          height: 230,
          child: new PageView.builder(
              onPageChanged: (value) {
                setState(() {
                  slideIndex = value;
                });
              },
              controller: controller,
              itemCount: mySLides.size(),
              itemBuilder: (context, index) => _carouselBuilder(
                  index,
                  controller,
                  InkWell(
                    onTap: () {
                      showImage(
                          mySLides.getIn(index).get("description").asString(),
                          mySLides.getIn(index).get("url_image").asString(),
                          mySLides,
                          index);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      decoration: BoxDecoration(
                        /*color: const Color(0xff7c94b6),*/
                        image: DecorationImage(
                          image: NetworkImage(mySLides
                              .getIn(index)
                              .get("url_image")
                              .asString()),
                          /*image: AssetImage(imageFile),*/
                          fit: BoxFit.fill,
                        ),
                        border: Border.all(
                          color: Colors.black,
                          width: 0,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      //padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // Image.asset(imagePath),
                          Text('')
                        ],
                      ),
                    ),
                  ))),
        ),

        SizedBox(
          height: 20,
        ),
        Text("Deskripsi Kendaraan:", style: TextStyle(fontSize: 20)),
        SizedBox(
          height: 20,
        ),

        Text(
            nPopulate
                .get("vehicle_summary")
                .asString()
                .replaceAll(",", "\r\n-"),
            style: TextStyle(fontSize: 18, height: 1.3)),
        /* SizedBox(  height:10, ),
        Text("- Bodykit belakang baret",  style:  TextStyle(  fontSize: 18)   ),
        SizedBox(  height:10, ),
        Text("- Tidak ada dongkrak",  style:  TextStyle(  fontSize: 18)   ),
        SizedBox(  height:10, ),*/
        SizedBox(
          height: 10,
        ),
        ExpansionPanelList(
          animationDuration: Duration(seconds: 1),
          expansionCallback: (i, _isExpanded) =>
              setState(() { _isOpen[i] = !_isExpanded; print(_isOpen);}),
          children: [
            ExpansionPanel(
              isExpanded: _isOpen[0],
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text('Data Mobil'),
                );
              },
              body: Column(
                children: [
                  textViewOnly(context, "ID Nomor",
                      nPopulate.get("vehicle_data").get("id_nomor").asString()),
                  textViewOnly(
                      context,
                      "No. Polisi	",
                      nPopulate
                          .get("vehicle_data")
                          .get("nomor_polisi")
                          .asString()),
                  textViewOnly(context, "Skor",
                      nPopulate.get("vehicle_data").get("grade").asString()),
                  textViewOnly(context, "Year",
                      nPopulate.get("vehicle_data").get("tahun").asString()),
                  textViewOnly(
                      context,
                      "Transmition",
                      nPopulate
                          .get("vehicle_data")
                          .get("transmisi")
                          .asString()),
                  textViewOnly(context, "Color",
                      nPopulate.get("vehicle_data").get("color").asString()),
                  textViewOnly(context, "KM",
                      nPopulate.get("vehicle_data").get("km").asString()),
                  textViewOnly(
                      context,
                      "Kepemilikan",
                      nPopulate
                          .get("vehicle_data")
                          .get("kepemilikan")
                          .asString()),
                  textViewOnly(context, "lokasi",
                      nPopulate.get("vehicle_data").get("lokasi").asString()),
                  textViewOnly(context, "Stnk",
                      nPopulate.get("vehicle_data").get("stnk").asString()),
                ],
              ),
            ),
            ExpansionPanel(
              isExpanded: _isOpen[1],
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text('Body'),
                );
              },
              body: Column(children: getChilds("vehicle_body")
                  /*[
              textViewIcon(context,nPopulate.get("vehicle_body").getIn(0).get("item").asString(), nPopulate.get("vehicle_body").getIn(0).get("description").asString(),  nPopulate.get("vehicle_body").getIn(0).get("status").asString() == '1'),
              textViewIcon(context, "Electric Mirror", "OK", true),
              textViewIcon(context, "Cat Body", "Penyok dan baret", false),
              textViewIcon(context, "Panel Pintu", "Repaint", false),
              textViewIcon(context, "Handle Pintu", "OK", true),
              textViewIcon(context, "Bemper Belakang", "OK", true),
            ],*/
                  ),
            ),
            ExpansionPanel(
              isExpanded: _isOpen[2],
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text('Interior'),
                );
              },
              body: Column(
                  children: getChilds(
                      "vehicle_interior") /*[
              textViewIcon(context, "Power Window", "OK", true),
              textViewIcon(context, "Electric Mirror", "OK", true),
              textViewIcon(context, "Power Window", "OK", true),
              textViewIcon(context, "Electric Mirror", "OK", true),
              textViewIcon(context, "Power Window", "OK", true),
              textViewIcon(context, "Electric Mirror", "OK", true),
            ],*/
                  ),
            ),
            ExpansionPanel(
              isExpanded: _isOpen[3],
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text('Mesin'),
                );
              },
              body: Column(
                  children: getChilds(
                      "vehicle_mesin") /* [
              textViewIcon(context, "Power Window", "OK", true),
              textViewIcon(context, "Electric Mirror", "OK", true),
              textViewIcon(context, "Power Window", "OK", false),
              textViewIcon(context, "Electric Mirror", "OK", true),
              textViewIcon(context, "Power Window", "OK", true),
              textViewIcon(context, "Electric Mirror", "OK", true),
            ],*/
                  ),
            ),

            /*ExpansionPanel(
            isExpanded: true,
            headerBuilder:(BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text('Lain-lain'),
              );
            },
            body:  Column(children: [
              textViewIcon(context, "Power Window", "OK", true),
              textViewIcon(context, "Electric Mirror", "OK", true),
            ],),
          ),*/

            ExpansionPanel(
              isExpanded: _isOpen[4],
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text('Foto Kerusakaan'),
                );
              },
              body: Column(
                  children:
                      getChildsImage() /* [
              imageViewOnly(context, ""),
              imageViewOnly(context, ""),
              imageViewOnly(context, ""),
              imageViewOnly(context, ""),

            ],*/
                  ),
            ),
          ],
        ),

        //textViewFilter(context, "Merek", "Toyota"),
        SizedBox(
          height: 20,
        ),

        SizedBox(
          height: (80),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                horizontalLine(),
                Text("Masuk", style: CustomTextStyle.body(context)),
                horizontalLine()
              ],
            ),
          ),
        ),
        SizedBox(
          height: (30),
        ),
        /*Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: InkWell(
              onTap: () {
                print('hello');
                Navigator.of(context).pushNamed("/tawar");
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
                child: new Center(child: new
                Text('Tawar',
                  style: new TextStyle(fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                      color: Colors.white),),),
              ),
            ),
          ),
        ),*/
        SizedBox(
          height: 60,
        ),
      ],
    );
  }

  imageViewOnly(Nson imag1, Nson imag2) {
    Nson image1 = Nson.newObject();
    Nson image2 = Nson.newObject();
    Nson imagList = Nson.newArray();
    image1.set("description", imag1.get("description").asString());
    image1.set("url_image", imag1.get("url_image").asString());
    image2.set("description", imag2.get("description").asString());
    image2.set("url_image", imag2.get("url_image").asString());
    imagList.add(imag1);
    imagList.add(imag2);
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        //Center Row contents horizontally,
        crossAxisAlignment: CrossAxisAlignment.center,
        //Center Row contents vertically,
        children: [
          Column(
            children: [
              InkWell(
                onTap: () {
                  showImage(imag1.get("description").asString(),
                      imag1.get("url_image").asString(), imagList, 0);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 150,
                  height: 120,
                  margin: const EdgeInsets.only(left: 0.0, right: 10.0),
                  child: Image.network(imag1.get("url_image").asString()),
                  /*Image.asset(
                  "assets/images/im1.png",
                  fit: BoxFit.fitWidth,
                ),*/
                ),
              ),
            ],
          ),
          Column(
            children: [
              imag2.isNull()
                  ? Container(
                      width: 150,
                      height: 120,
                    )
                  : InkWell(
                      onTap: () {
                        showImage(imag2.get("description").asString(),
                            imag2.get("url_image").asString(), imagList, 1);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 150,
                        height: 120,
                        margin: const EdgeInsets.only(left: 10.0, right: 0.0),
                        child: Image.network(imag2.get("url_image").asString()),
                        /* Image.asset(
                  "assets/images/im2.png",
                  fit: BoxFit.fill,
                ),*/
                      ),
                    ),
            ],
          )
        ],
      ),
    );
  }

  textViewOnly(context, String text, String val) {
    return Container(
      padding: EdgeInsets.only(top: 5, right: 5, bottom: 5, left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        //Center Row contents horizontally,
        crossAxisAlignment: CrossAxisAlignment.center,
        //Center Row contents vertically,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2 - 35,
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

  textViewIcon(context, String text, String val, bool b) {
    return Container(
      padding: EdgeInsets.only(top: 5, right: 5, bottom: 5, left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        //Center Row contents horizontally,
        crossAxisAlignment: CrossAxisAlignment.center,
        //Center Row contents vertically,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2 - 35,
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

  Widget _carouselBuilder(
      int index, PageController controller, Widget customCardWidget) {
    return new AnimatedBuilder(
      animation: controller,
      child: customCardWidget,
      builder: (context, child) {
        double value = 1.0;
        if (controller.position.haveDimensions) {
          value = controller.page - index;
          value = (1 - (value.abs() * .30)).clamp(0.0, 1.0);
        }
        return new Center(
          child: new SizedBox(
            height: Curves.easeOut.transform(value) * 300,
            width: Curves.easeOut.transform(value) * 350,
            child: child,
          ),
        );
      },
    );
  }

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: (120),
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
    const String imageFile = 'assets/images/mx.png';

    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
        /*color: const Color(0xff7c94b6),*/
        image: const DecorationImage(
          image: NetworkImage(''),
          /*image: AssetImage(imageFile),*/
          fit: BoxFit.fill,
        ),
        border: Border.all(
          color: Colors.black,
          width: 0,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      //padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Image.asset(imagePath),
          Text('')
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
