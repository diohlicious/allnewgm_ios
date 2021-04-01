import 'package:flutter/material.dart';
import 'package:grosir/Nikita/app.dart';
import 'package:grosir/login.dart';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:grosir/Nikita/NsGlobal.dart';
import 'package:shared_preferences/shared_preferences.dart';
SharedPreferences prefs;

void main() async{
  getSettings();

  runApp(MyApp());
}
getSettings() async {
  prefs = await SharedPreferences.getInstance();
  /*setState(() {
    //hasLogin = prefs.getBool('hasLogin');
  });*/
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Welcome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  List<SliderModel> mySLides = new List<SliderModel>();
  int slideIndex = 0;
  PageController controller;


  Widget _buildPageIndicator(bool isCurrentPage){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.grey : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSettings();

    mySLides = getSlides();
    controller = new PageController();
  }
  Widget _Buton(String text, VoidCallback callback){
    return  Column(
        children: <Widget>[
          SizedBox(
            height: 0,
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
                    color: Color.fromARGB( 255,    148,193,44  ),
                    border: new Border.all(color: Color.fromARGB(255,148,193,44), width: 1.0),
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: new Center(child: new Text(text, style: new TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0, color: Colors.white),),),
                ),
              ),
            ),
          ),
        ]) ;
  }

  @override
  Widget build(BuildContext context) {



    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [const Color(0xff3C8CE7), const Color(0xff00EAFF)])),
      child: Scaffold(

        backgroundColor: Colors.white,
        body: Column(
          children: [

            Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
              onPressed: () async {
                controller.animateToPage(2, duration: Duration(milliseconds: 400), curve: Curves.linear);
                NsGlobal.settings.setString("skip", "1");
                App.setSetting("lewati", "true");
              },

               padding: EdgeInsets.only(top: 50),
              splashColor: Colors.blue[50],
              child: Text(
                slideIndex != 2 ? "Lewati >>" :'',
                style: TextStyle(color: Color(0xFF0074E4), fontWeight: FontWeight.w600),
              ),
            ),) ,
            Container(
          height: MediaQuery.of(context).size.height - 100,
          child:
          PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                slideIndex = index;
              });
            },
            children: <Widget>[
              SlideTile(
                imagePath: mySLides[0].getImageAssetPath(),
                title: mySLides[0].getTitle(),
                desc: mySLides[0].getDesc(),
              ),
              SlideTile(
                imagePath: mySLides[1].getImageAssetPath(),
                title: mySLides[1].getTitle(),
                desc: mySLides[1].getDesc(),
              ),
              SlideTile(
                imagePath: mySLides[2].getImageAssetPath(),
                title: mySLides[2].getTitle(),
                desc: mySLides[2].getDesc(),
              )
            ],
          ),
        )],
        ) ,
        bottomSheet: slideIndex != 2 ?
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: () {
                  print("this is slideIndex: $slideIndex");
                  controller.animateToPage(slideIndex + 1, duration: Duration(milliseconds: 500), curve: Curves.linear);

                },
                child: new Container(
                  margin: EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width-10,
                  height: 50.0,
                  decoration: new BoxDecoration(
                    color: Color.fromARGB( 255,  148,193,44  ),
                    border: new Border.all(color: Color.fromARGB(255,148,193,44), width: 1.0),
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: new Center(child: new Text('Selanjutnya', style: new TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0, color: Colors.white),),),
                ),
              ),
            ],
          ),
        ):
        InkWell(
          onTap: () {
            print('Selesai');
            Navigator.of(context).pushNamed('/login');
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
          },
          child: new Container(
            margin: EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width-10,
            height: 50.0,
            decoration: new BoxDecoration(
              color: Color.fromARGB( 255,    148,193,44  ),
              border: new Border.all(color: Color.fromARGB(255,148,193,44), width: 1.0),
              borderRadius: new BorderRadius.circular(10.0),
            ),
            child: new Center(child: new Text('Selesai', style: new TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0, color: Colors.white),),),
          ),
        ),

      ),
    );
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
          Container(
            height: 320,
            child: Image.asset(imagePath),
          ),
          SizedBox(
            height: 20,
          ),
          Text(title, textAlign: TextAlign.center,style: TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: "Nunito",
              fontSize: 24
          ),),
          SizedBox(
            height: 15,
          ),
          Text(desc, textAlign: TextAlign.center,style: TextStyle(
              fontWeight: FontWeight.w500, fontFamily: "Nunito",
              height: 1.5,
              fontSize: 14, color: Color.fromARGB(255, 143, 143, 143)  ))
        ],
      ),
    );
  }
}


Widget roundedButton(String buttonLabel, Color bgColor, Color textColor) {
  var loginBtn = new Container(
    padding: EdgeInsets.all(5.0),
    alignment: FractionalOffset.center,
    decoration: new BoxDecoration(
      color: bgColor,
      borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: const Color(0xFF696969),
          offset: Offset(1.0, 6.0),
          blurRadius: 0.001,
        ),
      ],
    ),
    child: Text(
      buttonLabel,
      style: new TextStyle(
          color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
    ),
  );
  return loginBtn;
}

class SliderModel{

  String imageAssetPath;
  String title;
  String desc;

  SliderModel({this.imageAssetPath,this.title,this.desc});

  void setImageAssetPath(String getImageAssetPath){
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle){
    title = getTitle;
  }

  void setDesc(String getDesc){
    desc = getDesc;
  }

  String getImageAssetPath(){
    return imageAssetPath;
  }

  String getTitle(){
    return title;
  }

  String getDesc(){
    return desc;
  }

}


List<SliderModel> getSlides(){

  List<SliderModel> slides = new List<SliderModel>();
  SliderModel sliderModel = new SliderModel();

  //1
  sliderModel.setDesc("Dengan Grosir Mobile, cai dan pilih unit\r\nyang anda butuhkan kini lebih mudah");
  sliderModel.setTitle("Selamat Datang Sobat GMob!");
  sliderModel.setImageAssetPath("assets/images/onboarding2.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //2
  sliderModel.setDesc("Berikan harga terbaik anda melalui\r\npenawaran atau buy now");
  sliderModel.setTitle("Tawar atau Buy Now");
  sliderModel.setImageAssetPath("assets/images/onboarding1.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //3
  sliderModel.setDesc("Lakukan pembayaran melalu Virtual Account\r\ndan bawa pulang mobil anda!");
  sliderModel.setTitle("Bayar dan Bawa Pulang");
  sliderModel.setImageAssetPath("assets/images/onboarding3.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  return slides;
}

