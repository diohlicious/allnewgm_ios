import 'package:flutter/material.dart';
import 'package:grosir/Nikita/app.dart';
import 'package:grosir/UI/CameraApp.dart';
import 'package:grosir/UI/TakePictureScreen.dart';
import 'package:grosir/alamat.dart';
import 'package:grosir/andaberhasil.dart';
import 'package:grosir/checksms.dart';
import 'package:grosir/daftarpertayaan.dart';
import 'package:grosir/datadiri.dart';
import 'package:grosir/detail.dart';
import 'package:grosir/documenktp.dart';
import 'package:grosir/filter.dart';
import 'package:grosir/gantipassword.dart';
import 'package:grosir/home.dart';
import 'package:grosir/imageview.dart';
import 'package:grosir/login.dart';
import 'package:grosir/lokasi_unit.dart';
import 'package:grosir/menang_bayar.dart';
import 'package:grosir/menang_pembayar.dart';
import 'package:grosir/otp.dart';
import 'package:grosir/pilihplan.dart';
import 'package:grosir/profile.dart';
import 'package:grosir/profile_riwayat.dart';
import 'package:grosir/profilusaha.dart';
import 'package:grosir/selamat.dart';
import 'package:grosir/tawar.dart';
import 'package:grosir/ubahpassword.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'welcome.dart';
import 'daftar.dart';
import 'package:grosir/Nikita/NsGlobal.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  NsGlobal.title = "Wakakakak";
  NsGlobal.init();
  runApp( MyApp() );


  App.settingpreff = await SharedPreferences.getInstance();
}

class MyApp extends StatelessWidget {
  Future<String> prepare() async {
    String status = await App.getSetting("sign");
    String lewati = await App.getSetting("lewati");
    if(status == 'true'){
      return 'login';
    } else if(lewati == 'true'){
      return 'lewati';
    }else{
      return '';
    }

  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: 'Flutter Demo',
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
      home:
          FutureBuilder<String>(
          future: prepare(), // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<String> snapshot){
            if (snapshot.hasData||snapshot.hasError) {
              if (snapshot.data == 'login'){
                return Splash();
              }else if (snapshot.data == 'lewati'){
                return Splash();
              }else{
                return Splash();
              }
            }else{
              return Splash();
            }
          }
      ) ,
      debugShowCheckedModeBanner: false,
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        // '/': (context) => Home(),
        '/login': (context) => Login(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/daftar': (context) => Daftar(),
        '/ganti': (context) => Ganti(),
        '/ubah': (context) => UbahPass(),
        '/otp': (context) => OTP(),
        '/checksms': (context) => CheckSMS(),
        '/datadiri': (context) => DataDiri(),
        '/profil': (context) => ProfilUsaha(),
        '/dokumen': (context) => DocumentKTP(),
        '/pilihplan': (context) => PilihPlan(),
        '/andaberhasil': (context) => AndaBerhasil(),
        '/selamat': (context) => Selamat(),
        '/home': (context) => Home(),
        '/menangbayar': (context) => MenangBayar(),
        '/menangpembayar': (context) => MenangPemBayar(),
        '/filter': (context) => Filter(),
        '/detail': (context) => Detail(),
        '/tawar': (context) => Tawar(),
        '/alamat': (context) => Alamat(),
        '/daftarpertanyaan': (context) => DaftarPertanyaan(),
        '/profile': (context) => Profile(),
        '/profileriwayat': (context) => ProfileRiwayat(),
        '/lokasiunit': (context) => LokasiUnit(),
        '/take': (context) => TakePictureScreen( ),
        '/viewer': (context) => ImageViewer( ),
      },
    );
  }
}
//  Navigator.pushNamed(context, MaterialPageRoute(builder: (_) => Screen2()));

class Splash extends StatelessWidget {
  Future<String> _calculation = Future<String>.delayed(
    Duration(seconds: 3),
        () => 'Data Loaded',
  );

  Future<String> prepare() async {
    await Future<String>.delayed(
      Duration(seconds: 1),
          () => 'Data Loaded',
    );

    String status = await App.getSetting("sign");
    String lewati = await App.getSetting("lewati");
    if(status == 'true'){
      return 'login';
    } else if(lewati == 'true'){
      return 'lewati';
    }else{
      return '';
    }

  }
  @override
  Widget build(BuildContext context) {
   /* return Scaffold(
        body: Welcome()

    );*/
    return Scaffold(
      body:
      FutureBuilder<String>(
        future: prepare(), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot){
          if (snapshot.hasData||snapshot.hasError) {
              if (snapshot.data == 'login'){
                return Home();
              }else if (snapshot.data == 'login'){
                return Login();
              }else{
                return Welcome();
              }
          }else{
              return UIsplash();
          }
        }
      )
    );
  }
}

class UIsplash extends StatelessWidget{

  Widget build(BuildContext context) {
    return  Container(
      child: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              // gradient: LinearGradient(colors: [info, primary])
                image: DecorationImage(
                    image: AssetImage("assets/images/bg1.png"),
                    fit: BoxFit.cover)),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Container(
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height / 2,
              child: Material(
                color: Colors.black.withOpacity(0.3),
                type: MaterialType.card,
                // shape: BeveledRectangleBorder(
                //     borderRadius: new BorderRadius.only(
                //         topLeft: Radius.circular(1000))),
              ),
            ),
          ),

          Container(
            child:  SingleChildScrollView(
              child:
              Column(
                children: <Widget>[
                  SizedBox(
                    height: ( MediaQuery.of(context).size.height / 2 - 80).abs(),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 120,
                    margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Image.asset(
                      "assets/images/splash1.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
