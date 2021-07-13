import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grosir/Api/apiservice.dart';

import 'package:grosir/Nikita/Nson.dart';
import 'package:grosir/Nikita/app.dart';
import 'package:grosir/UI/WCounter.dart';
import 'package:grosir/home_keranjangisi.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'home_info.dart';
import 'home_menang.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  Nson nsonLive = Nson.newArray();

  Nson nsonAkan = Nson.newArray();

  Nson nsonRiwayat = Nson.newArray();
  Nson nsonData = Nson.newObject();
  int pageNo = 1;

  String compare = "";
  int lead = 0;

  List<Nson> mySLides = List<Nson>();
  int slideIndex = 0;
  PageController _pageController;

  final _currentPageNotifier = ValueNotifier<int>(0);
  final _boxHeight = 150.0;

  Nson profile = Nson.newObject();

  void handleValue(String value) {
    App.log(value);
    profile = Nson.parseJson(value).get("data").get("logged_in_user");
    setState(() {
      App.log(profile.toJson());
    });
  }

  void initState() {
    super.initState();
    //scrollController = new ScrollController()..addListener(_scrollListener);
    /*  () async {
        _refreshIndicatorKey.currentState?.show();
    };*/
    refreshData();

    App.getSetting("profile").then((value) => handleValue(value));
    mySLides.add(Nson.newObject());
    mySLides.add(Nson.newObject());
    mySLides.add(Nson.newObject());
    //controller = new PageController();
    _pageController = new PageController(
      initialPage: slideIndex,
      keepPage: false,
      viewportFraction: 1,
    );
  }

  @override
  void dispose() {
    //scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    print(scrollController.position.extentAfter);
    if (scrollController.position.extentAfter < 500) {
      setState(() {
        pageNo += 1;
        _reload();
        print('data habis+loadmore()');
        //items.addAll(new List.generate(42, (index) => 'Inserted $index'));
      });
    }
  }

  loadMore() {
    setState(() {
      pageNo += 1;
      _reload();
    });
    print('data habis+loadmore()');
  }

  TextEditingController search = TextEditingController();
  int _currentIndex = 0;
  int _currentGalery = 0;

  void onTabTapped(int index) {
    App.needBuild = true;
    setState(() {
      _currentIndex = index;
    });
  }

  void onTabTappedGelery(int index) {
    setState(() {
      _currentGalery = index;
    });
  }

  String iifAsset(int curr, String strue, String selse) {
    return _currentIndex == curr
        ? "assets/images/" + strue
        : "assets/images/" + selse;
  }

  Widget _homeReload(Widget widget) {
    if (App.needBuild) {
      App.needBuild = false;
      refreshData();
      return Stack(
        children: [
          widget,
          Center(
            child: Center(child: CircularProgressIndicator()),
          )
        ],
      );
    } else {
      return Stack(
        children: [widget],
      );
    }
  }

  Widget GaleryHome(BuildContext context) {
    //App.log('GaleryHome');
    /* return  FutureBuilder<Nson>(
      future: _reload(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return  _galery(context);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner.
        return Center(child: CircularProgressIndicator(),);
      },
    );*/

    return _galery(context);
  }

  Widget GaleryAkanTayang(BuildContext context) {
    /*return  FutureBuilder<Nson>(
      future: _reload(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return  _galeryAkanTayang(context);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return Center(child: CircularProgressIndicator(),);
      },
    );*/
    return _galeryAkanTayang(context);
  }

  Widget GaleryKeranjangIsi(BuildContext context) {
    return KeranjangIsi();
  }

  Widget GaleryInfo(BuildContext context) {
    /*ApiService apiService = ApiService();
    return  FutureBuilder<Response>(
      future: apiService.ResendOtp() ,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return  Info();
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return Center(child: CircularProgressIndicator(),);
      },
    );*/

    return Info();
  }

  Widget GaleryMenang(BuildContext context) {
    /*ApiService apiService = ApiService();
    return  FutureBuilder<Response>(
      future: apiService.ResendOtp() ,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return  Menang();
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return Center(child: CircularProgressIndicator(),);
      },
    );*/
    App.log('Menang');
    //{"message":"success","description":"Sukses menambah favorite"}
    return Menang();
  }

  /*Widget _buildWidgetItemListData( BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('user.nama'),

          ],
        ),
      ),
    );
  }*/
  Future<Nson> _reload() async {
    //maintenance
    //Nson mtNson = await ApiService().checkMaintenanceApi();
    //if (mtNson.get('is_mobile').asInteger() == 1) {
      const int max = 100;
      //statuscode":302 dan 401 dipaksa relogin
      String filter = await App.getSetting("filter");
      Nson nfilter = Nson.parseJson(filter);
      //live

      args = Nson.newObject();
      args.set("page", 1);
      args.set("max", max);
      args.set("category", 'live');
      args.set("grade", '');
      args.set("lokasi", nfilter.get("lokasi").asString());
      args.set(
          "tahunstart",
          nfilter.containsKey("tahunstart")
              ? nfilter.get("tahunstart").asInteger()
              : 2000);
      args.set(
          "tahunend",
          nfilter.containsKey("tahunend")
              ? nfilter.get("tahunend").asInteger()
              : 3000);
      args.set("merek", nfilter.get("merek").asString());
      args.set("hargastart", nfilter.get("hargastart").asInteger());
      args.set(
          "hargaend",
          nfilter.containsKey("hargaend")
              ? nfilter.get("hargaend").asInteger()
              : 1000000000);

      var response = await ApiService.get().homeLiveApiRaw(args);
      if (response.statusCode == 401) {
        App.showDialogBox(context, 'Message!', 'Session Habis',
            onClick: () async {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/login', (Route<dynamic> route) => false);
        });
      }

      print('here is Status Code: ${response.statusCode}');

      Nson nson = await ApiService.get().homeLiveApi(args);
      print('here home live api ${args.asString()}');
      nsonData = nson.get('data');
      nsonLive = nson.get("data").get("data_live");

      /* nson.get("data").remove("data_live");
    String s = nson.toJson();
    */
      App.log(args.toStream());
      nson.get("data").remove("data_live");
      App.log(nson.toStream());

      //ominsoon
      args = Nson.newObject();
      args.set("page", pageNo);
      args.set("max", max);
      args.set("category", 'akan tayang');
      args.set("lokasi", '');
      args.set("tahunstart", 2000);
      args.set("tahunend", 3000);
      args.set("merek", '');
      args.set("hargastart", 0);
      args.set("grade", '');
      args.set("hargaend", 1000000000);
      nson = await ApiService.get().homeComingSoonApi(args);

      nsonAkan = nson.get("data").get("data_list_event");
      App.log(nson.toStream());

      //hstory
      args = Nson.newObject();
      args.set("page", pageNo);
      args.set("max", max);
      args.set("Ismenang", '');

      nson = await ApiService.get().homeHistoryApi(args);
      nsonRiwayat = nson.get("data").get("data_history");
      //App.log(nson.toStream());

      nson = await ApiService.get().timeServerApi(args);
      //App.log(nson.get("data").get("time_server").asString());
      lead = App.wcounterlead(nson
          .get("data")
          .get("time_server")
          .asString()); // App.datedif ( nson.get("data").get("time_server").asString(), compare);

      /*compare =  DateTime.now().toString();
    App.log(compare);
    App.log("++++++++");
    int i =  App.datedif ( nson.get("data").get("time_server").asString(), compare);
    App.log(i);
    Duration now = Duration(seconds: i);
    App.log(now.toString());
    //keranjang
    App.log("-------");
    int dif =  App.datedif ( nson.get("data").get("time_server").asString(), nsonAkan.getIn(0).get("start_date").asString());
    App.log(dif);
    now = Duration(seconds: dif);
    App.log(now.toString());
    App.log("==========");
    dif =  App.datedif (compare, nsonAkan.getIn(0).get("start_date").asString());
    App.log(dif);
    now = Duration(seconds: dif);
    App.log(now.toString());
    now = Duration(seconds: dif+i);
    App.log(now.toString());*/

      //setState(() { });

    //} else {
    //  App.showDialogBox(context, mtNson.get("description").asString(), '',
    //      onClick: () async {
    //    Navigator.of(context)
    //        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    //  });
    //}
    /*else {
      App.showDialogBox(context,   mtNson.get("description").asString(),'' ,  onClick: () async{
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      });
    }*/
    return Nson.newObject();
  }

  Nson args = Nson.newObject();

  Future refreshData() async {
    await _reload();

    /* if (args.get("keranjan").asBoolean()){
      _currentIndex = 1;
    }*/
    setState(() {});
  }

  void searchFilter(String text) {
    setState(() {});
  }

  void sort(String text) async {
    App.log("sort");
    var comp;
    if (text == 'NO' || text == 'ON') {
      comp = (a, b) {
        Nson na = Nson(text == 'NO' ? a : b);
        Nson nb = Nson(text == 'NO' ? b : a);
        return na
            .get("vehicle_name")
            .asString()
            .compareTo(nb.get("vehicle_name").asString());
      };
    } else if (text == 'AZ' || text == 'ZA') {
      comp = (a, b) {
        Nson na = Nson(text == 'AZ' ? a : b);
        Nson nb = Nson(text == 'AZ' ? b : a);
        return na
            .get("vehicle_name")
            .asString()
            .compareTo(nb.get("vehicle_name").asString());
      };
    } else if (text == 'HL' || text == 'LH') {
      App.log(text);
      comp = (a, b) {
        Nson na = Nson(text == 'LH' ? a : b);
        Nson nb = Nson(text == 'LH' ? b : a);
        return na
            .get("bottom_price")
            .asDouble()
            .compareTo(nb.get("bottom_price").asDouble());
      };
    } else {
      comp = (a, b) => 0;
    }

    nsonLive.sort(comp);
    nsonAkan.sort(comp);
    setState(() {});
  }

  Widget onFilter(Nson data, int index, Widget view) {
    String text = search.text;
    //App.log(data.getIn(index).get("vehicle_name").asString() + ":" +text);
    if (data
        .getIn(index)
        .get("vehicle_name")
        .asString()
        .toLowerCase()
        .contains(text.toLowerCase())) {
    } else {
      return Container();
    }
    return view;
  }

  Widget _kendaraankosong() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            "Kendaraan belum tersedia",
            style: new TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w700,
                fontSize: 22.0,
                color: Colors.black),
          ),
        ),

        SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.only(left: 50, right: 50),
          child: Image.asset(
            "assets/images/kendaraan_kosong.png",
            fit: BoxFit.fill,
          ),
        ),

        //_galeryCard(context, plan: "Penawaran anda disalip orang lain ",title: "Klik untuk menawar kembali",  color: Colors.white ),
        SizedBox(
          height: 30,
        ),
        // _galeryCard(context, plan: "Penawaran anda disalip orang lain ",title: "Klik untuk menawar kembali",  color: Color.fromARGB(255, 250, 211, 212) ),

        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          alignment: Alignment.center,
          child: Text(
            " Saat ini belum ada kendaraan  yang tersedia, silahkan tunggu informasi berikutnya pada saat LiveGrosir ",
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontFamily: "Nunito",
              color: Color.fromARGB(255, 143, 143, 143),
              height: 1.5,
              fontWeight: FontWeight.w600,
              fontSize: 14.0,
            ),
          ),
        ),

        SizedBox(
          height: 10,
        ),
        //_galeryCard(context, plan: "Penawaran anda disalip orang lain ",title: "Klik untuk menawar kembali",  color: Color.fromARGB(255, 233, 242, 212)   ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _buildWidgetRefresh() {
    return RefreshIndicator(
      onRefresh: refreshData,
      child: SingleChildScrollView(
        //controller: scrollController,
        padding: _currentIndex == 2
            ? EdgeInsets.all(0)
            : EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            (_currentIndex == 0 && _currentGalery <= 1)
                ? Column(
                    children: [
                      /*SizedBox(
                        height: 86,
                      ),*/
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                            obscureText: false,
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                            controller: search,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (search) {
                              App.log("onSubmitted" + search);
                              searchFilter(search);
                            },
                            decoration: InputDecoration(
                              //Add th Hint text here.
                              labelText: "Kendaraan yang sedang anda cari?",

                              hintStyle: CustomTextStyle.formField(context),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor,
                                      width: 1.0)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor,
                                      width: 1.0)),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.black,
                              ),

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: BorderSide(
                                  width: 120,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              filled: true,
                              contentPadding: EdgeInsets.all(5),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      Container(
                        height: 230,
                        child: PageView.builder(
                            onPageChanged: (value) {
                              setState(() {
                                slideIndex = value;
                                _currentPageNotifier.value = value;
                              });
                            },
                            controller: _pageController,
                            itemBuilder: (context, index) => _carouselBuilder(
                                index,
                                _pageController,
                                Stack(
                                  children: [
                                    Align(
                                      child: Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.only(
                                            left: 0.0, right: 0.0),
                                        child: Image.asset(
                                          "assets/images/header.png",
                                          fit: BoxFit.fill,
                                        ),
                                        /*decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: ExactAssetImage("assets/images/header.png"),
                  ),
                ),*/
                                      ),
                                    ),
                                    /*Positioned( left: 0, bottom: 0 , child: _buildCircleIndicator()),*/
                                  ],
                                ))),
                      ),
                      _currentGalery == 0
                          ? _Buton(
                              "Ada ${nsonData.get('total').asInteger()} kendaraan Live! ",
                              Color.fromARGB(255, 230, 36, 44),
                              Colors.white,
                              null)
                          : Container(),
                      _currentGalery == 1
                          ? _Buton(
                              "Ada ${nsonAkan.size()} kendaraan segera tayang! ",
                              Color.fromARGB(255, 255, 222, 89),
                              Colors.black,
                              null)
                          : Container(),
                    ],
                  )
                : Container(),
            _currentIndex == 0 ? _galeryButton(_currentGalery) : Container(),
            _currentIndex == 0
                ? Column(children: [
                    Stack(children: [
                      Text(
                        _currentGalery == 0
                            ? "Baru Masuk"
                            : _currentGalery == 1
                                ? "Segera Tayang"
                                : "Record",
                        style: new TextStyle(
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w500,
                            fontSize: 22.0,
                            color: Colors.black),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _currentGalery == 2
                                    ? Container()
                                    : Container(
                                        margin: EdgeInsets.only(right: 10),
                                        child: InkWell(
                                          child: Image.asset(
                                              'assets/images/filter.png'),
                                          onTap: () {
                                            Navigator.of(context)
                                                .pushNamed('/filter')
                                                .then((value) => refreshData());
                                          },
                                        ),
                                      ),
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: InkWell(
                                    onTap: () {
                                      final action = CupertinoActionSheet(
                                        title: Text(
                                          "Sortir berdasarkan",
                                          style: TextStyle(
                                            fontFamily: "Nunito",
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                        actions: <Widget>[
                                          _ListSpinner(
                                              "Waktu penawaran: Cepat ke Lama",
                                              () {
                                            sort("NO");
                                          }),
                                          _ListSpinner(
                                              "Waktu penawaran: Lama ke Cepat",
                                              () {
                                            sort("ON");
                                          }),
                                          _ListSpinner(
                                              "Abjad lokasi warehouse: A ➜ Z",
                                              () {
                                            sort("AZ");
                                          }),
                                          _ListSpinner(
                                              "Abjad lokasi warehouse: Z ➜ A",
                                              () {
                                            sort("ZA");
                                          }),
                                          _ListSpinner(
                                              "Bottom price: Terendah ke Tertinggi ",
                                              () {
                                            sort("LH");
                                          }),
                                          _ListSpinner(
                                              "Bottom price: Tertinggi ke Terendah ",
                                              () {
                                            sort("HL");
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
                                          context: context,
                                          builder: (context) => action);
                                      //Navigator.of(context).pushNamed('/filter');
                                    },
                                    child:
                                        Image.asset('assets/images/sort.png'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ])
                : Container(),
            _currentIndex == 0
                ? (_currentGalery == 0
                    ? GaleryHome(context)
                    : (_currentGalery == 1
                        ? GaleryAkanTayang(context)
                        : GaleryRecord(context)))
                : _currentIndex == 1
                    ? GaleryKeranjangIsi(context)
                    : _currentIndex == 2
                        ? GaleryInfo(context)
                        : GaleryMenang(context),
          ],
        ),
      ),
    );
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
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    args = Nson(arguments);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      appBar: _currentIndex == 2
          ? null
          : AppBar(
              title: Text(
                _currentIndex == 0 ? "Galeri" : "",
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    fontSize: 28),
              ),
              backgroundColor: Colors.white.withOpacity(0.8),
              elevation: 0.0,
              actions: [
                _currentIndex == 0
                    ? IconButton(
                        icon: CircleAvatar(
                          backgroundImage: NetworkImage(profile
                              .get("user")
                              .get("profile_photo_url")
                              .asString()), // AssetImage("assets/images/profile.jpg"),
                          //profile.get("user").get("profile_photo_url").asString()
                        ),
                        onPressed: () {
                          // do something
                          Navigator.of(context).pushNamed('/profile');
                        },
                      )
                    : Text('')
              ],
            ),
      body: _currentIndex == 1
          ? GaleryKeranjangIsi(context)
          : _homeReload(_buildWidgetRefresh()),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color.fromARGB(255, 148, 193, 44),
        unselectedItemColor: Colors.black45,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon:
                Image.asset(iifAsset(0, "navi_home.png", "navi_home_off.png")),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(iifAsset(1, "keranjang_on.png", "keranjang.png")),
            title: new Text('Keranjang'),
          ),
          BottomNavigationBarItem(
              icon: Image.asset(iifAsset(2, "info_on.png", "info.png")),
              title: Text('Info')),
          BottomNavigationBarItem(
              icon: Image.asset(iifAsset(3, "menang_on.png", "menang.png")),
              title: Text('Menang'))
        ],
      ),
    );

    /*return
      MaterialApp(
          theme: ThemeData(

          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home:
        Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: _currentIndex == 2 ? null:
          AppBar(
            title: Text(  _currentIndex == 0 ?  "Galeri" : "",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  fontSize: 28),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions:  [_currentIndex == 0 ?
              IconButton(
                  icon:  CircleAvatar(
                    backgroundImage:  NetworkImage ("https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),// AssetImage("assets/images/profile.jpg"),
                    //profile.get("user").get("profile_photo_url").asString()
                  ),
                onPressed: () {
                    // do something
                  Navigator.of(context).pushNamed('/profile');
                  },
                ) : Text('')
              ],
          ),
          body:
          _currentIndex == 1 ? GaleryKeranjangIsi(context):  _buildWidgetRefresh(),
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
            selectedItemColor: Color.fromARGB(255,148,193,44 ),
            unselectedItemColor: Colors.black45,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            onTap: onTabTapped,
            currentIndex: _currentIndex, // this will be set when a new tab is tapped
            items: [
              BottomNavigationBarItem(
                icon:  Image.asset( iifAsset(0,"navi_home.png","navi_home_off.png") ),
                title: new Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Image.asset( iifAsset(1,"keranjang_on.png","keranjang.png") ),
                title: new Text('Keranjang'),
              ),
              BottomNavigationBarItem(
                  icon: Image.asset(iifAsset(2, "info_on.png","info.png") ),
                  title: Text('Info')
              ),
              BottomNavigationBarItem(
                  icon: Image.asset( iifAsset(3,"menang_on.png","menang.png") ),
                  title: Text('Menang')
              )
            ],
          ),
        ),
        debugShowCheckedModeBanner: false,
      );
*/
  }

  Widget _galeryListItem(
      {String plan, String title, String desc, Color color, Color color2}) {
    return Card(
        color: Colors.lightBlue,
        margin: EdgeInsets.all(0.0),
        /*shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.lightGreen, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),*/
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 120,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [color, color2])),
          child: ListTile(),
        ));
  }

  Widget _galeryCard(
      {String plan, String title, String desc, Color color, Color color2}) {
    return Card(
        color: Colors.lightBlue,
        margin: EdgeInsets.all(0.0),
        /*shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.lightGreen, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),*/
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 120,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [color, color2])),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.only(left: 10, top: 15),
                  child: Text(
                    plan,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0,
                        color: Colors.white),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0,
                        color: Colors.white),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                  child: Text(
                    "Dengan memilih plan ini berarti anda akan mendapakana segala benefit dari plat berikut",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _ButonLive(String text, Color color, Color bordercolor,
      Color textcolor, VoidCallback callback) {
    return Column(children: <Widget>[
      SizedBox(
        height: 30,
      ),
      Container(
        child: Padding(
          padding: EdgeInsets.only(),
          child: InkWell(
            onTap: callback,
            child: new Container(
              width: MediaQuery.of(context).size.width,
              height: 30.0,
              decoration: new BoxDecoration(
                color: color,
                border: new Border.all(color: bordercolor, width: 1.0),
                borderRadius: new BorderRadius.circular(30.0),
              ),
              child: new Center(
                child: Text(
                  text,
                  style: new TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      color: textcolor),
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
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

  Widget _Buton(
      String text, Color bgcolor, Color color, VoidCallback callback) {
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
              height: 53,
              decoration: new BoxDecoration(
                color: bgcolor,
                border: new Border.all(color: bgcolor, width: 1.0),
                borderRadius: new BorderRadius.circular(10.0),
              ),
              child: new Center(
                child: new Text(
                  text,
                  style: new TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color: color),
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _carouselBuilder(
      int index, PageController controller, Widget customCardWidget) {
    return AnimatedBuilder(
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
            /*  height: Curves.easeOut.transform(value) * 300,
            width: Curves.easeOut.transform(value) * 300,*/
            child: child,
          ),
        );
      },
    );
  }

  _buildCircleIndicator() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CirclePageIndicator(
          itemCount: mySLides.length,
          currentPageNotifier: _currentPageNotifier,
        ),
      ),
    );
  }

  Widget _galeryButton(int flag) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            child: _ButonLive(
                "Live",
                flag == 0 ? Color.fromARGB(255, 230, 36, 44) : Colors.white10,
                flag == 0 ? Color.fromARGB(255, 230, 36, 44) : Colors.black38,
                flag == 0 ? Colors.white : Colors.black, () {
              onTabTappedGelery(0);
            }),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            child: _ButonLive(
                "Akan Tayang",
                flag == 1 ? Color.fromARGB(255, 255, 222, 89) : Colors.white10,
                flag == 1 ? Color.fromARGB(255, 255, 222, 89) : Colors.black38,
                Colors.black, () {
              onTabTappedGelery(1);
            }),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            child: _ButonLive(
                "Riwayat",
                flag == 2 ? Color.fromARGB(255, 148, 193, 44) : Colors.white10,
                flag == 2 ? Color.fromARGB(255, 148, 193, 44) : Colors.black38,
                flag == 2 ? Colors.white : Colors.black, () {
              onTabTappedGelery(2);
            }),
          ),
        ),
      ],
    );
  }

  void nextDetail(Nson args) {
    Navigator.pushNamed(context, "/detail", arguments: args.asMap());
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
      data.set("is_favorite", favNow);
      setState(() {});
    }
    //refreshData();
  }

  String formatDate(String a) {
    DateFormat formatter = DateFormat('dd MMMM yyyy');
    var parsed = DateTime.parse(a);
    String formatted = formatter.format(parsed);
    return formatted;
  }

  ScrollController scrollController;

  Widget _galery(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        nsonLive.size() >= 1 ? Container() : _kendaraankosong(),
        //LIVE*
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return onFilter(
                nsonLive,
                index,
                InkWell(
                    onTap: () {
                      App.log('nextDetail ' + index.toString());
                      /*Navigator.push(
                      context,
                      MaterialPageRoute(phys
                        builder: (context) => Detail(),
                      ),
                    );*/
                      nextDetail(nsonLive.getIn(index));
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              side: BorderSide(width: 1, color: Colors.white)),
                          /*color: Colors.purple,*/
                          margin: EdgeInsets.all(0.0),
                          child: Container(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 200,
                                    /*decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            nsonLive
                                                .getIn(index)
                                                .get("image")
                                                .asString(),
                                          ),
                                          fit: BoxFit.fill),
                                    ),*/
                                    margin: const EdgeInsets.only(
                                        left: 0.0, right: 0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          bottomLeft: Radius.circular(15)),
                                      child: Image.network(
                                        nsonLive
                                            .getIn(index)
                                            .get("image")
                                            .asString(),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          5.0, 0.0, 0.0, 0.0),
                                      child: Stack(
                                        children: [
                                          Container(
                                              alignment: Alignment.centerRight,
                                              padding: EdgeInsets.only(
                                                  top: 0, right: 5),
                                              child: Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      App.log(index);
                                                      setFavUnFav(
                                                          nsonLive.getIn(index),
                                                          nsonLive
                                                              .getIn(index)
                                                              .get(
                                                                  "is_favorite")
                                                              .asInteger());
                                                    },
                                                    child: CircleAvatar(
                                                      child: Icon(nsonLive
                                                                  .getIn(index)
                                                                  .get(
                                                                      "is_favorite")
                                                                  .asInteger() ==
                                                              1
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_border),
                                                      backgroundColor:
                                                          Colors.white,
                                                      foregroundColor: nsonLive
                                                                  .getIn(index)
                                                                  .get(
                                                                      "is_favorite")
                                                                  .asInteger() ==
                                                              1
                                                          ? Colors.red
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                  CircleAvatar(
                                                    child: Text(
                                                      nsonLive
                                                          .getIn(index)
                                                          .get("grade")
                                                          .asString(),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                ],
                                              )),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.all(1),
                                                margin: EdgeInsets.only(
                                                    right: 30, top: 3),
                                                decoration: BoxDecoration(
                                                    color: Color(0xff94c12c),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Text(
                                                  formatDate(nsonLive
                                                      .getIn(index)
                                                      .get("start_date")
                                                      .asString()),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 12.0,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.55,
                                                child: Text(
                                                  nsonLive
                                                      .getIn(index)
                                                      .get("vehicle_name")
                                                      .asString(),
                                                  //overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                                margin:
                                                    EdgeInsets.only(right: 30),
                                              ),
                                              //const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    nsonLive
                                                        .getIn(index)
                                                        .get("agreement_no")
                                                        .asString(),
                                                    style: const TextStyle(
                                                        fontFamily: "Nunito",
                                                        color: Color.fromARGB(
                                                            255, 143, 143, 143),
                                                        fontSize: 12.0),
                                                  ),
                                                  const SizedBox(
                                                    width: 3,
                                                  ),
                                                  Text(
                                                    nsonLive
                                                        .getIn(index)
                                                        .get("warehouse")
                                                        .asString().split(RegExp('\\s+'))[1],
                                                    style: const TextStyle(
                                                        fontFamily: "Nunito",
                                                        color: Color.fromARGB(
                                                            255, 230, 36, 44),
                                                        fontSize: 10.0),
                                                  )
                                                ],
                                              ),

                                              //const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),

                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                'Harga Awal',
                                                style: const TextStyle(
                                                    fontSize: 12.0),
                                              ),
                                              Text(
                                                'Rp.' +
                                                    App.formatCurrency(nsonLive
                                                        .getIn(index)
                                                        .get("bottom_price")
                                                        .asDouble()),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "Nunito",
                                                    fontSize: 18.0),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                'Harga Sekarang',
                                                style: const TextStyle(
                                                    fontSize: 12.0),
                                              ),
                                              Stack(
                                                children: [
                                                  Text(
                                                    'Rp.' +
                                                        App.formatCurrency(
                                                            nsonLive
                                                                .getIn(index)
                                                                .get("PriceNow")
                                                                .asDouble()),
                                                    style: TextStyle(
                                                        color: nsonLive
                                                                    .getIn(
                                                                        index)
                                                                    .get(
                                                                        "UserBid")
                                                                    .asInteger() ==
                                                                0
                                                            ? Colors.black87
                                                            : Colors
                                                                .blue.shade700,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: "Nunito",
                                                        fontSize: 18.0),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                'Admin Fee',
                                                style: const TextStyle(
                                                    fontSize: 12.0),
                                              ),
                                              Text(
                                                'Rp.' +
                                                    App.formatCurrency(nsonLive
                                                        .getIn(index)
                                                        .get("adminfee")
                                                        .asDouble()),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "Nunito",
                                                    fontSize: 18.0),
                                              ),
                                              WCounter(
                                                builds: (value, duration) =>
                                                    Container(
                                                  margin:
                                                      EdgeInsets.only(right: 5),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(),
                                                    child: new Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height: 30.0,
                                                      decoration:
                                                          new BoxDecoration(
                                                        color: Colors.red,
                                                        border: new Border.all(
                                                            color: Colors.red,
                                                            width: 1.0),
                                                        borderRadius:
                                                            new BorderRadius
                                                                .circular(30.0),
                                                      ),
                                                      child: new Center(
                                                        child: Container(
                                                          color: Colors.red,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 10),
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .access_time,
                                                                color: Colors
                                                                    .white,
                                                                size: 14,
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                value,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .white),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                start: nsonLive
                                                    .getIn(index)
                                                    .get("end_date")
                                                    .asString(),
                                                lead: lead,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    )));
          },
          itemCount: nsonLive.size(),
        ),

        SizedBox(
          height: (30),
        ),

        /*Container(
          child: Padding(
              padding: EdgeInsets.only(),
              child: InkWell(
                onTap:  () {
                  print('hello');

                  //Navigator.of(context).pushNamed('/datadiri');
                  AwesomeDialog(
                      context: context,
                      dialogType: DialogType.INFO,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Selamat bergabung ',
                      desc: 'Under Construction',
                      btnOkOnPress: () {
                        Navigator.of(context).pop();
                      },
                      dismissOnTouchOutside: false
                  )..show();
                },
                child: new Container(
                  width: 100.0,
                  height: 50.0,
                  decoration: new BoxDecoration(
                    color: Color.fromARGB( 255,    148,193,44  ),
                    border: new Border.all(color: Color.fromARGB(255,148,193,44), width: 1.0),
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: new Center(child: new Text('Telusuri', style: new TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0, color: Colors.white),),),
                ),
              ),
          ),
        ),*/
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _galeryAkanTayang(context) {
    //final DateTime now = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        nsonAkan.size() >= 1 ? Container() : _kendaraankosong(),
        //Segera*
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return onFilter(
                nsonAkan,
                index,
                InkWell(
                  onTap: () {
                    App.log('nextDetail ' + index.toString());
                    nextDetail(nsonAkan.getIn(index));
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            side: BorderSide(width: 1, color: Colors.white)),

                        /*color: Colors.purple,*/
                        margin: EdgeInsets.all(0.0),
                        child: Container(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                    height: 190,
                                    margin: const EdgeInsets.only(
                                        left: 0.0, right: 0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          bottomLeft: Radius.circular(15)),
                                      child: Image.network(
                                        nsonAkan
                                            .getIn(index)
                                            .get("image")
                                            .asString(),
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        5.0, 0.0, 0.0, 0.0),
                                    child: Stack(
                                      children: [
                                        Container(
                                            alignment: Alignment.centerRight,
                                            padding: EdgeInsets.only(
                                                top: 0, right: 5),
                                            child: Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    App.log(index);
                                                    setFavUnFav(
                                                        nsonAkan.getIn(index),
                                                        nsonAkan
                                                            .getIn(index)
                                                            .get("is_favorite")
                                                            .asInteger());
                                                  },
                                                  child: CircleAvatar(
                                                    child: Icon(nsonAkan
                                                                .getIn(index)
                                                                .get(
                                                                    "is_favorite")
                                                                .asInteger() ==
                                                            1
                                                        ? Icons.favorite
                                                        : Icons
                                                            .favorite_border),
                                                    backgroundColor:
                                                        Colors.white,
                                                    foregroundColor: nsonAkan
                                                                .getIn(index)
                                                                .get(
                                                                    "is_favorite")
                                                                .asInteger() ==
                                                            1
                                                        ? Colors.red
                                                        : Colors.grey,
                                                  ),
                                                ),
                                                CircleAvatar(
                                                  child: Text(
                                                    nsonAkan
                                                        .getIn(index)
                                                        .get("grade")
                                                        .asString(),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 255, 222, 89),
                                                ),
                                              ],
                                            )),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.all(1),
                                              margin: EdgeInsets.only(
                                                  right: 30, top: 3),
                                              decoration: BoxDecoration(
                                                  color: Color(0xff94c12c),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Text(
                                                formatDate(nsonAkan
                                                    .getIn(index)
                                                    .get("start_date")
                                                    .asString()),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12.0,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                nsonAkan
                                                    .getIn(index)
                                                    .get("vehicle_name")
                                                    .asString(),
                                                //overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              margin:
                                                  EdgeInsets.only(right: 30),
                                            ),
                                            //const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  nsonAkan
                                                      .getIn(index)
                                                      .get("agreement_no")
                                                      .asString(),
                                                  style: const TextStyle(
                                                      fontFamily: "Nunito",
                                                      color: Color.fromARGB(
                                                          255, 143, 143, 143),
                                                      fontSize: 12.0),
                                                ),
                                                const SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  nsonAkan
                                                      .getIn(index)
                                                      .get("warehouse")
                                                      .asString().split(RegExp('\\s+'))[1],
                                                  style: const TextStyle(
                                                      fontFamily: "Nunito",
                                                      color: Color.fromARGB(
                                                          255, 230, 36, 44),
                                                      fontSize: 10.0),
                                                )
                                              ],
                                            ),
                                            const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 1.0)),

                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              'Harga Awal',
                                              style: const TextStyle(
                                                  fontSize: 12.0),
                                            ),
                                            Text(
                                              'Rp.' +
                                                  App.formatCurrency(nsonAkan
                                                      .getIn(index)
                                                      .get("bottom_price")
                                                      .asDouble()),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Nunito",
                                                  fontSize: 16.0),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Harga Sekarang',
                                              style: const TextStyle(
                                                  fontSize: 12.0),
                                            ),
                                            Text(
                                              'Rp.' +
                                                  App.formatCurrency(nsonAkan
                                                      .getIn(index)
                                                      .get("PriceNow")
                                                      .asDouble()),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Nunito",
                                                  fontSize: 16.0),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Admin Fee',
                                              style: const TextStyle(
                                                  fontSize: 12.0),
                                            ),
                                            Text(
                                              'Rp.' +
                                                  App.formatCurrency(nsonAkan
                                                      .getIn(index)
                                                      .get("adminfee")
                                                      .asDouble()),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Nunito",
                                                  fontSize: 16.0),
                                            ),
                                            WCounter(
                                              builds: (value, duration) =>
                                                  Container(
                                                margin:
                                                    EdgeInsets.only(right: 5),
                                                child: Padding(
                                                  padding: EdgeInsets.only(),
                                                  child: new Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 25.0,
                                                    decoration:
                                                        new BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 255, 222, 89),
                                                      border: new Border.all(
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              222,
                                                              89),
                                                          width: 1.0),
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(30.0),
                                                    ),
                                                    child: new Center(
                                                      child: Container(
                                                        color: Color.fromARGB(
                                                            255, 255, 222, 89),
                                                        margin: EdgeInsets.only(
                                                            right: 10),
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Icon(
                                                              Icons.access_time,
                                                              color:
                                                                  Colors.black,
                                                              size: 14,
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              value,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              start: nsonAkan
                                                  .getIn(index)
                                                  .get("start_date")
                                                  .asString(),
                                              lead: lead,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ));
          },
          itemCount: nsonAkan.size(),
        ),
        SizedBox(
          height: (30),
        ),

        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget GaleryRecord(BuildContext context) {
    /*return  FutureBuilder<Nson>(
      future: _reload(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return  _galeryAkanTayang(context);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return Center(child: CircularProgressIndicator(),);
      },
    );*/
    return _galeryRecord(context);
  }

  Widget _galeryRecord(context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          /*_galeryButton(2),*/
          /* SizedBox(
            height:10,
          ),
          Stack(children: [
            Text("Records",
              style: new TextStyle(fontWeight: FontWeight.w500,fontSize: 20.0, color: Colors.black),
            ),
            Align(alignment: Alignment.centerRight,
              child:
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.filter_list,
                        color: Colors.black,
                      ),
                      const Icon(
                        Icons.sort,
                        color: Colors.black,
                      ),
                      */ /*FlatButton(onPressed: null, child:    Text("Filter"),),
*/ /*

                    ],
                  ),


                ],
              ),
            ),

          ]
          ),
          SizedBox(
            height:10,
          ),
*/
          //Record*
          ListView.builder(
            shrinkWrap: true,
            /*physics: const AlwaysScrollableScrollPhysics(),*/
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    nextDetail(nsonRiwayat.getIn(index));
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                              child: Stack(
                                children: [
                                  Container(
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.only(top: 15, right: 5),
                                    child: CircleAvatar(
                                      child: Text(
                                        nsonRiwayat
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          nsonRiwayat
                                              .getIn(index)
                                              .get("vehicle_name")
                                              .asString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        margin: EdgeInsets.only(right: 30),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.0)),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            nsonRiwayat
                                                .getIn(index)
                                                .get("kik_number")
                                                .asString(),
                                            style: const TextStyle(
                                                fontFamily: "Nunito",
                                                color: Color.fromARGB(
                                                    255, 143, 143, 143),
                                                fontSize: 12.0),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            nsonRiwayat
                                                .getIn(index)
                                                .get("warehouse")
                                                .asString().split(RegExp('\\s+'))[1],
                                            style: const TextStyle(
                                                fontFamily: "Nunito",
                                                color: Color.fromARGB(
                                                    255, 230, 36, 44),
                                                fontSize: 12.0),
                                          )
                                        ],
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 1.0)),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Harga Awal',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "Nunito",
                                                      fontSize: 12.0),
                                                ),
                                                Text(
                                                  'Rp.' +
                                                      App.formatCurrency(
                                                          nsonRiwayat
                                                              .getIn(index)
                                                              .get(
                                                                  "hargapembukaan")
                                                              .asDouble()),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "Nunito",
                                                      fontSize: 18.0),
                                                ),
                                              ]),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                          ),
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    nsonRiwayat
                                                        .getIn(index)
                                                        .get("status")
                                                        .asString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: "Nunito",
                                                        fontSize: 12.0),
                                                  ),
                                                ),
                                                Container(
                                                  child: Text(
                                                    'Rp.' +
                                                        App.formatCurrency(
                                                            nsonRiwayat
                                                                .getIn(index)
                                                                .get(
                                                                    "sold_price")
                                                                .asDouble()),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: "Nunito",
                                                        fontSize: 18.0),
                                                  ),
                                                )
                                              ]),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          /* const Icon(
              Icons.more_vert,
              size: 16.0,
            ),*/
                          const SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: nsonRiwayat.size(),
          ),

          SizedBox(
            height: (30),
          ),

          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _Keranjang(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: (50),
        ),
      ],
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

Widget getRecord() {}

class CustomRecord extends StatelessWidget {
  const CustomRecord({
    this.thumbnail,
    this.title,
    this.user,
    this.viewCount,
    this.color,
    this.txcolor,
  });

  final Widget thumbnail;
  final String title;
  final String user;
  final int viewCount;
  final Color color;
  final Color txcolor;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Expanded(
              flex: 3,
              child: _RecordDescription(
                color: color,
                txcolor: txcolor,
                title: title,
                user: "NI 12032424124 Jakarta",
                viewCount: viewCount,
              ),
            ),
            /* const Icon(
              Icons.more_vert,
              size: 16.0,
            ),*/
            const SizedBox(
              width: 5,
            ),
          ],
        ),
      ),
    );
  }
}

class _RecordDescription extends StatelessWidget {
  const _RecordDescription({
    Key key,
    this.title,
    this.user,
    this.viewCount,
    this.color,
    this.txcolor,
  }) : super(key: key);

  final String title;
  final String user;
  final int viewCount;
  final Color color;
  final Color txcolor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(top: 15, right: 5),
            child: CircleAvatar(
              child: Text(
                "C",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              backgroundColor: Color.fromARGB(255, 148, 193, 44),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0,
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    user,
                    style: const TextStyle(
                        fontFamily: "Nunito",
                        color: Color.fromARGB(255, 143, 143, 143),
                        fontSize: 12.0),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Jakarta',
                    style: const TextStyle(
                        fontFamily: "Nunito",
                        color: Color.fromARGB(255, 230, 36, 44),
                        fontSize: 12.0),
                  )
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
              const SizedBox(
                height: 15,
              ),
              Stack(
                children: [
                  Text(
                    'Harga Awal',
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: "Nunito",
                        fontSize: 12.0),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      color: color,
                      child: Text(
                        'Terjual',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: "Nunito",
                            fontSize: 12.0),
                      ),
                    ),
                  )
                ],
              ),
              Stack(
                children: [
                  Text(
                    'Rp 120.000.000',
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: "Nunito",
                        fontSize: 18.0),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      color: color,
                      child: Text(
                        'Rp 120.000.000',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: "Nunito",
                            fontSize: 18.0),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    this.thumbnail,
    this.title,
    this.user,
    this.viewCount,
    this.color,
    this.txcolor,
  });

  final Widget thumbnail;
  final String title;
  final String user;
  final int viewCount;
  final Color color;
  final Color txcolor;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: thumbnail,
            ),
            Expanded(
              flex: 5,
              child: _VideoDescription(
                color: color,
                txcolor: txcolor,
                title: title,
                user: "NI 12032424124",
                viewCount: viewCount,
              ),
            ),
            const Icon(
              Icons.more_vert,
              size: 16.0,
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoDescription extends StatelessWidget {
  const _VideoDescription({
    Key key,
    this.title,
    this.user,
    this.viewCount,
    this.color,
    this.txcolor,
  }) : super(key: key);

  final String title;
  final String user;
  final int viewCount;
  final Color color;
  final Color txcolor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Stack(
        children: [
          Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(top: 0, right: 5),
              child: Column(
                children: [
                  CircleAvatar(
                    child: Icon(Icons.favorite_border),
                    backgroundColor: Colors.white,
                  ),
                  CircleAvatar(
                    child: Text(
                      "B",
                      style: TextStyle(
                        color: txcolor,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    backgroundColor: color,
                  ),
                ],
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0,
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    user,
                    style: const TextStyle(
                        fontFamily: "Nunito",
                        color: Color.fromARGB(255, 143, 143, 143),
                        fontSize: 12.0),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Jakarta',
                    style: const TextStyle(
                        fontFamily: "Nunito",
                        color: Color.fromARGB(255, 230, 36, 44),
                        fontSize: 12.0),
                  )
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Harga Awal',
                style: const TextStyle(fontSize: 12.0),
              ),
              Text(
                'Rp 110.000.000',
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: "Nunito",
                    fontSize: 18.0),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Harga Sekarang',
                style: const TextStyle(fontSize: 12.0),
              ),
              Stack(
                children: [
                  Text(
                    'Rp 120.000.000',
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: "Nunito",
                        fontSize: 18.0),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      color: color,
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time,
                            color: txcolor,
                            size: 14,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            ' 04:12:12',
                            style: TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                                color: txcolor),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

// ...

Widget build(BuildContext context) {
  return ListView(
    padding: const EdgeInsets.all(8.0),
    itemExtent: 106.0,
    children: <CustomListItem>[
      CustomListItem(
        user: 'Flutter',
        viewCount: 999000,
        thumbnail: Container(
          decoration: const BoxDecoration(color: Colors.blue),
        ),
        title: 'The Flutter YouTube Channel',
      ),
      CustomListItem(
        user: 'Dash',
        viewCount: 884000,
        thumbnail: Container(
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 255, 222, 89)),
        ),
        title: 'Announcing Flutter 1.0',
      ),
    ],
  );
}
