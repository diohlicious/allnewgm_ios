
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grosir/Api/apiservice.dart';
import 'dart:io';
import 'package:grosir/Nikita/NsGlobal.dart';
import 'package:grosir/Nikita/Nson.dart';
import 'package:grosir/Nikita/app.dart';



import 'UI/CustomIcons.dart';
import 'UI/SocialIcons.dart';

class ProfileRiwayat extends StatefulWidget {
  @override
  _ProfileRiwayatState createState() => _ProfileRiwayatState();
}



class _ProfileRiwayatState extends State<ProfileRiwayat> {
  String _valGender;String title;


  Future refreshData() async {
    Nson args = Nson.newObject();
    args.set("page", 1);
    args.set("max", 20);
    args.set("category", 'A');
    args.set("lokasi", '');
    args.set("tahunstart", 2000);
    args.set("tahunend", 3000);
    args.set("merek", '');
    args.set("hargastart", 0);
    args.set("hargaend", 1000000000);

    Nson nson = await ApiService.get().homeLiveApi(args) ;
    App.log(nson.toStream());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      title = arguments['riwayat'];
    }else {
      title ="";

    }

    return
      MaterialApp(

        title: '',
        theme: ThemeData(

          primarySwatch: Colors.green,

          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home:

        Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(

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
            ),),
          body :
          RefreshIndicator(
              onRefresh: refreshData,
              child:  SingleChildScrollView(child: Column(
                children: <Widget>[

                  Container(
                    child: Padding(
                        padding: EdgeInsets.only(top: 5.0,left: 20),
                        child:  Text("Penawaran "+title,
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w500,
                                fontSize: 24.0,
                                color: Colors.black))
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                  ),

                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                    child: Stack(
                      children: [
                        Text(
                          '23 Oktober 2020',
                          style: const TextStyle(fontWeight: FontWeight.w400,fontFamily: "Nunito", fontSize: 16.0),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(

                            child: Text(
                              '2 unit',
                              style: const TextStyle(fontWeight: FontWeight.w400,fontFamily: "Nunito", fontSize: 16.0),
                            ),
                          ),
                        )   ],
                    ),),


                  _itemView(),
                  _itemView(),
                  _itemView(),
                  _itemView(),
                  _itemView(),
                ],
              ),) ,

          ),



        ),
        debugShowCheckedModeBanner: false,
      );

  }
  Widget _viewProfile(String label, String text){
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        alignment: Alignment.centerLeft,
        child:
        Row(children: [
          Expanded(
            flex: 3,
            child: Container(
                margin: EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child:
                Text(label,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color:   Color.fromARGB(255, 143, 143, 143),
                    ))
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
                margin: EdgeInsets.only(  right: 10),
                alignment: Alignment.centerRight,
                child:
                Text(text,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color: Colors.black,
                    ))
            ),
          ),

        ],)
    );
  }
  Widget _Buton(String text, VoidCallback callback){
    return  Column(
        children: <Widget>[
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
  Widget _Combo(IconData icon, String label){

    List _listGender = [label, "Female"];
    return  Column(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child:
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                  SizedBox(width: 12,),
                  Icon(
                    icon,
                    color: Colors.black,
                  ),
                  SizedBox(width: 12,),


                  Column(
                      mainAxisSize: MainAxisSize.max,
                  children:[  DropdownButton(
                        hint: Container (
                          width: 260,
                          child: Text(label),),
                        value: _valGender,
                        items: _listGender.map((value) {
                          return DropdownMenuItem(
                            child: Text(value),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _valGender = value;
                          });
                        },
                      ),]
                  ),],
                ),


          )
        ]) ;
  }
  Widget _Textbox(IconData icon, String label){
    return  Column(
        children: <Widget>[
        SizedBox(
        height: 15,
        ),
      Container(
        child: Padding(
          padding: EdgeInsets.only(),
          child:
          TextField(
            style: TextStyle(color: Theme .of(context)  .accentColor),
            controller: null,
            decoration: InputDecoration(
              labelText: label,
              hintStyle: CustomTextStyle.formField(context),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(  color: Theme .of(context) .accentColor, width: 1.0)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide( color: Theme .of(context)  .accentColor, width: 1.0)),
              prefixIcon:  Icon(
                icon,
                color: Colors.black,
              ),
            ),
            obscureText: false,
          ),
        ),
        )
       ]) ;
  }



  Widget _itemView(){
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5, bottom: 3),
      child:
      Card(child:
        Container(
          padding: EdgeInsets.all(15),
          child: Stack(children: [
          Container(
            alignment:  Alignment.centerRight ,
            padding: EdgeInsets.only(top: 0, right: 5),
            child:
            CircleAvatar(
              child: Text("C",
                style: TextStyle(
                  color: Colors.white,  fontWeight: FontWeight.w700, fontSize: 18 , ),
              ),
              backgroundColor:  Color.fromARGB(255, 148, 193, 44) ,
            ),
          ),


          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Masserati DSE AT 2015",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0,
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),

              const SizedBox(height: 5,),
              Row(children: [ Text(
                "NI121232 - Jakarta ",
                style: const TextStyle(
                    fontFamily: "Nunito",
                    color: Color.fromARGB(255, 143, 143, 143),
                    fontSize: 12.0),
              ),
                const SizedBox(width: 5,),
                Text(
                  'Jakarta',
                  style: const TextStyle(
                      fontFamily: "Nunito",
                      color: Color.fromARGB(255, 148, 193, 44),
                      fontSize: 12.0),
                )

              ],
              )  ,
              const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
              const SizedBox(height: 15,),

              Stack(
                children: [
                  Text(
                    'Harga Awal',
                    style: const TextStyle(fontWeight: FontWeight.w500,fontFamily: "Nunito", fontSize: 12.0),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(

                      child: Text(
                        'Terjual',
                        style: const TextStyle(fontWeight: FontWeight.w500,fontFamily: "Nunito", fontSize: 12.0),
                      ),
                    ),
                  )   ],
              ),

              Stack(
                children: [
                  Text(
                    'Rp 120.000.000',
                    style: const TextStyle(fontWeight: FontWeight.w500,fontFamily: "Nunito", fontSize: 18.0),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(

                      child: Text(
                        'Rp 120.000.000',
                        style: const TextStyle(fontWeight: FontWeight.w500,fontFamily: "Nunito", fontSize: 18.0),
                      ),
                    ),
                  )   ],
              )


            ],
          ),],),)
      ),
    );
  }

  Widget emailErrorText() => Text("Controller.displayErrorEmailLogIn");
}

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
    return
      Card(child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child:
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10,),
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
            const SizedBox(width: 5,),
          ],
        ),
      ),)
    ;
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
    return
      Padding(
        padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
        child:
        Stack(children: [


          Container(
            alignment:  Alignment.centerRight ,
            padding: EdgeInsets.only(top: 15, right: 5),
            child:

            CircleAvatar(
              child: Text("C",
                style: TextStyle(
                  color: Colors.white,  fontWeight: FontWeight.w700, fontSize: 18 , ),
              ),
              backgroundColor:  Color.fromARGB(255, 148, 193, 44) ,
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

              const SizedBox(height: 5,),
              Row(children: [ Text(
                user,
                style: const TextStyle(
                    fontFamily: "Nunito",
                    color: Color.fromARGB(255, 143, 143, 143),
                    fontSize: 12.0),
              ),
                const SizedBox(width: 5,),
                Text(
                  'Jakarta',
                  style: const TextStyle(
                      fontFamily: "Nunito",
                      color: Color.fromARGB(255, 230, 36, 44),
                      fontSize: 12.0),
                )

              ],)
              ,


              const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
              const SizedBox(height: 15,),

              Stack(
                children: [
                  Text(
                    'Harga Awal',
                    style: const TextStyle(fontWeight: FontWeight.w500,fontFamily: "Nunito", fontSize: 12.0),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      color: color,
                      child: Text(
                        'Terjual',
                        style: const TextStyle(fontWeight: FontWeight.w500,fontFamily: "Nunito", fontSize: 12.0),
                      ),
                    ),
                  )   ],
              ),

              Stack(
                children: [
                  Text(
                    'Rp 120.000.000',
                    style: const TextStyle(fontWeight: FontWeight.w500,fontFamily: "Nunito", fontSize: 18.0),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      color: color,
                      child: Text(
                        'Rp 120.000.000',
                        style: const TextStyle(fontWeight: FontWeight.w500,fontFamily: "Nunito", fontSize: 18.0),
                      ),
                    ),
                  )   ],
              )


            ],
          ),],),

      );

  }
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