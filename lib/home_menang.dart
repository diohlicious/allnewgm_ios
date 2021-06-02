

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grosir/Api/apiservice.dart';
import 'dart:io';
import 'package:grosir/Nikita/NsGlobal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grosir/Nikita/Nson.dart';
import 'package:grosir/Nikita/app.dart';
import 'package:intl/intl.dart';

class Menang extends StatefulWidget {
  Menang(){
    App.log('Menang.con');
    App.Arguments.set("invalidate", true);
  }
  bool initBusy = false;
  @override
  _MenangState createState() {
       App.log('Menang.createState');
      return _MenangState();
  }
}
class _MenangState extends State<Menang> {
  Nson nPolupate = Nson.newObject();
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  String formatted='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.formatted = formatter.format(now);
    App.log('init');

    initonCreate();
  }
  Widget _menangkosong(){
    return
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text("", textAlign: TextAlign.center,style: TextStyle(
                  fontFamily: "Nunito", fontWeight: FontWeight.w700,
                  fontSize: 28
              ),),),
            SizedBox(
              height: 40,
            ),
            Text("Anda belum menang", textAlign: TextAlign.center,style: TextStyle(
                fontFamily: "Nunito", fontWeight: FontWeight.w500,
                fontSize: 22
            ),),
            SizedBox(
              height: 20,
            ),
            Image.asset("assets/images/belum_menang.png"),
            SizedBox(
              height: 20,
            ),

            Text("Anda belum memenangkan penawaran apapun. Telusuri semua kendaraan yang kami tawarkan dan lakukan tawar/buy now", textAlign: TextAlign.center,style: TextStyle(
              fontFamily: "Nunito",
              color: Color.fromARGB(255, 143, 143, 143),
              fontWeight: FontWeight.w500,height: 1.5,
              fontSize: 14,   )),
            SizedBox(
              height: 10,
            ),

            _Buton( "Telusuri Kendaraan", () {
              //Navigator.of(context).pushNamed('/menang');
            }),

          ],
        ),
      );
  }
  @override
  Widget build(BuildContext context) {
    App.log('build1');
    App.log('w'+widget.initBusy.toString());
    if ( App.Arguments.get("invalidate").asBoolean()){
      App.Arguments.set("invalidate", false);
      initonCreate();
    }

    return Container(
      /*onRefresh: refreshData,*/
      child:
      SingleChildScrollView(
        padding:  EdgeInsets.only(left: 10,right: 10),
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [Stack(children: [
            Text( "Menang",
              style: TextStyle(
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 24),
            ),

          ],),
            SizedBox(
              height: 10,
            ),
            _buildWidgetRefresh(),
          ],),

      ),
    );
   /* return
      Container(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            Text( "Menang",
              style: TextStyle(
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 24),
            ),
            SizedBox(
              height: 10,
            ),
            _galeryCard( plan: "Penawaran anda disalip orang lain ",title: "Klik untuk menawar kembali",  selected :true ),
            SizedBox(
              height: 10,
            ),
            _galeryCard( plan: "Penawaran anda disalip orang lain ",title: "Klik untuk menawar kembali",  selected :false ),
            SizedBox(
              height: 10,
            ),
            Container(child: Text("Menunggu Pembayaran" ,
              style: const TextStyle(fontSize: 11.0 ,
                fontFamily: "Nunito",
                color: Colors.black,
              ),
            ),
            ),
            SizedBox(
              height: 10,
            ),
            _galeryCardMenunggu(plan: "Penawaran anda disalip orang lain ",title: "Klik untuk menawar kembali",  selected :false ),
            SizedBox(
              height: 10,
            ),
            Container(child: Text("Kendaraan Siap Diambil" ,
              style: const TextStyle(fontSize: 11.0 ,
                fontFamily: "Nunito",
                color: Colors.black,
              ),
            ),
            ),
            SizedBox(
              height: 10,
            ),
            _galeryCardSiapDiambil(plan: "Penawaran anda disalip orang lain ",title: "Klik untuk menawar kembali",  selected :false ),



            SizedBox(
              height: 10,
            ),

            _Buton("Bayar", () {
              print('hello');
              // Navigator.of(context).pushNamed('/menangbayar');
              // Navigator.of(context) .pushReplacementNamed('/menangbayar');
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => new MenangBayar())
              );
            }),
            SizedBox(height: 15,),
          ],
        ), ) ;*/
  }
  bool initBusy = false;
  void initonCreate() async{
    initBusy = true;
    widget.initBusy = true;
    await _reload();

    setState(() {
      initBusy = false;
    });
  }
  Widget _listConten() {
    return
      Container(
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //LIVE*
            Container(
              child:  ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: _itemList(index) ,);
                },
                itemCount: nPolupate.size(),
              ),),
            SizedBox(height: 5,),


            nPolupate.size()>=1?_Buton("Bayar", (){ bayar(); }) : _menangkosong(),
            SizedBox(height: 20,),
          ],
        ),
      ) ;
  }
  void bayar(){
    int count = 0;
    Nson nson = Nson.newArray();
    for (var i = 0; i < nPolupate.size(); i++) {
      count = count + (nPolupate.getIn(i).get("check").asBoolean()?1:0 );
      if (nPolupate.getIn(i).get("check").asBoolean()){
        nson.add(nPolupate.getIn(i));
      }

    }
    if (count ==0 ){
        App.showError("Mohon pilih yang mau dibayar");
    }else  if (count >3 ){
        App.showError("Pilihan maximal 3");
    }else{


      Navigator.of(context).pushNamed(  "/menangbayar", arguments:  Nson.newObject().set("array", nson).asMap());
    }
  }
  Future<Nson> _reload() async {
    App.log('_reload');
    Nson args = Nson.newObject();
    args.set("page", 1);
    args.set("max", 20);


    Nson nson = await ApiService.get().keranjang(args) ;
    nPolupate = nson.get("data");
    Nson _listNson = Nson.newArray();

    /*nPolupate.asList().forEach((val) {
      if (string == 'live' && val["is_live"] == 1) {
        _listNson.add(val);
        print("$string Live");
      } else if (val["category_name"].toString() == string &&
          val["is_live"] == 0 &&  val["end_date"].toString().split(RegExp('\\s+'))[0] == formatted) {
        _listNson.add(val);
        print("$string");
      } else if (string == 'Semua' && val["end_date"].toString().split(RegExp('\\s+'))[0] == formatted) {
        _listNson.add(val);
        print("$string Semua");
      }
    });*/
    nPolupate.asList().forEach((val){
      if (val["end_date"].toString().split(RegExp('\\s+'))[0] == formatted) {
        _listNson.add(val);
      }
    });

    nPolupate = _listNson;



    App.log(nson.toStream());

    return Nson.newObject();
  }

  Future refreshData() async {
    App.log('refreshData');
    await _reload();
    setState(() { });
  }
  Widget _buildWidgetRefresh() {
    App.log('_buildWidgetRefresh');
    /*return  FutureBuilder(
      future: _reload() ,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return  _listConten();
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return Center(child: CircularProgressIndicator(),);
      },
    );*/
    return !initBusy?_listConten():Center(child: CircularProgressIndicator());
  }
  Widget _itemList(int index){
    Widget item  ;
    App.log(nPolupate.getIn(index).toJson());

    if (nPolupate.getIn(index).get("is_winner").asInteger() == 1){
      //sedang berlangsung
      item = Column( crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(child: Text(nPolupate.getIn(index).get("category_name").asString() ,
            style: const TextStyle(fontSize: 11.0 ,
              fontFamily: "Nunito",
              color: Colors.black,
            ),
          ),
          ),
          SizedBox(
            height: 10,
          ),
          //_bisatawar(index   ),
          _galeryCard( index  ),
          //_galeryCardSiapDiambil(index,plan: "Penawaran anda disalip orang lain ",title: "Klik untuk menawar kembali",  selected :false ),
         // _galeryCardMenunggu(index,plan: "Penawaran anda disalip orang lain ",title: "Klik untuk menawar kembali",  selected :false ),

        ],);
    }else{
      item = Column( crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(child: Text(nPolupate.getIn(index).get("category_name").asString(),
            style: const TextStyle(fontSize: 11.0 ,
              fontFamily: "Nunito",
              color: Colors.black,
            ),
          ),
          ),
          SizedBox(
            height: 10,
          ),
          //_siapbayar( index  ),
          //_galeryCard(  index ),
          //_galeryCardSiapDiambil(index,plan: "Penawaran anda disalip orang lain ",title: "Klik untuk menawar kembali",  selected :false ),
          _galeryCardMenunggu(index, plan: "Penawaran anda disalip orang lain ",title: "Klik untuk menawar kembali",  selected :false ),

        ],);
    }
    return item;
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
  Widget _ButonLokasi(String text, VoidCallback callback){
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
                  child: new Center(child: new Text(text, style: new TextStyle(fontWeight: FontWeight.w500,fontSize: 12.0, color: Colors.white),),),
                ),
              ),
            ),
          ),
        ]) ;
  }
  Widget _galeryCard( int index ){
    Color color =   Colors.white;
    return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(  Radius.circular(15)),
            side: BorderSide(width: 1, color: color)),

        color: color,
        margin: EdgeInsets.all(0.0),
        child: Container(

          child:  Row(
            children: [
              Expanded(
                flex: 2,
                child:
                Container(
                    height: 120,
                    margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                    child:
                    ClipRRect(
                      borderRadius: BorderRadius.only( topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                      child:  Image.network( nPolupate.getIn(index).get("foto").asString(),  fit: BoxFit.cover, ) ,
                    )
                ),
              ),
              Expanded(
                flex: 5,
                child:
                Container(
                  margin: EdgeInsets.only(left: 20),
                  padding: EdgeInsets.only(top: 15, right: 5),
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        nPolupate.getIn(index).get("vehicle_name").asString(),
                        style: const TextStyle(
                          fontFamily: "Nunito",
                          color: Color.fromARGB(255, 148, 193, 44),

                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),




                      Stack(children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child:
                          Row(children: [
                            Text(
                              nPolupate.getIn(index).get("kik").asString(),
                              style: const TextStyle(fontSize: 11.0,
                                fontFamily: "Nunito",
                                color: Color.fromARGB(255, 143, 143, 143),

                              ),
                            ),
                            SizedBox(width: 10,),
                            Text(
                              nPolupate.getIn(index).get("Oto_json").get("Lokasi").asString().split(RegExp('\\s+'))[1],
                              style: const TextStyle(fontSize: 11.0,
                                fontFamily: "Nunito",
                                color: Color.fromARGB(255, 148, 193, 44),

                              ),
                            ),
                          ],),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Checkbox(
                                //checkColor:  Color.fromARGB(255, 148, 193, 44),
                                value: nPolupate.getIn(index).get("check").asBoolean(),
                                onChanged:(bool newValue){
                                    bool b = nPolupate.getIn(index).get("check").asBoolean();

                                    setState(() {
                                      nPolupate.getIn(index).set("check", !b);
                                    });
                                    App.log('onChanged');
                                    App.log(index);
                                    App.log(nPolupate.getIn(index).get("check").asString());
                                    App.log(nPolupate.getIn(index).get("check").asBoolean());
                                }
                              ),
                            ],
                          ),
                        ),
                      ],),


                      Text(
                        'Dimenanangkan seharga',
                        style: const TextStyle(fontSize: 11.0 ,
                          fontFamily: "Nunito",
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        'Rp.' + App.formatCurrency(nPolupate.getIn(index).get("open_price").asDouble()),
                        style: const TextStyle(fontSize: 16.0,
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w500,
                          color: Colors.black,),
                      ),
                      SizedBox(height: 10,),

                    ],
                  ),
                ),
              ),

            ],
          ) ,
        )
    );
  }
  Widget _galeryCardMenunggu(int index, {String plan, String title,  bool selected } ){
    Color color = selected?  Color(0xffE4F1BF):  Colors.white;
    return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(  Radius.circular(15)),
            side: BorderSide(width: 1, color: color)),

        color: color,
        margin: EdgeInsets.all(0.0),
        child: Container(

          child:  Row(
            children: [
              Expanded(
                flex: 2,
                child:
                Container(
                  height: 160,
                    margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                    child:
                    ClipRRect(
                      borderRadius: BorderRadius.only( topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                      child:  Image.network( nPolupate.getIn(index).get("foto").asString(),  fit: BoxFit.cover, ) ,
                    )
                ),
              ),
              Expanded(
                flex: 5,
                child:
                Container(
                  margin: EdgeInsets.only(left: 20),
                  padding: EdgeInsets.only(top: 15, right: 5),
                  child:
                  Stack( children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          nPolupate.getIn(index).get("vehicle_name").asString(),
                          style: const TextStyle(
                            fontFamily: "Nunito",
                            color: Color.fromARGB(255, 148, 193, 44),

                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),



                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child:
                          Row(children: [
                            Text(
                              nPolupate.getIn(index).get("kik").asString(),
                              style: const TextStyle(fontSize: 11.0,
                                fontFamily: "Nunito",
                                color: Color.fromARGB(255, 143, 143, 143),

                              ),
                            ),
                            SizedBox(width: 10,),
                            Text(
                              nPolupate.getIn(index).get("Oto_json").get("Lokasi").asString().split(RegExp('\\s+'))[1],
                              style: const TextStyle(fontSize: 11.0,
                                fontFamily: "Nunito",
                                color: Color.fromARGB(255, 148, 193, 44),

                              ),
                            ),
                          ],),
                        ),

                        SizedBox(height: 10,),
                        Text(
                          'Penawaran terakhir',
                          style: const TextStyle(fontSize: 11.0 ,
                            fontFamily: "Nunito",
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          'Rp.' + App.formatCurrency(nPolupate.getIn(index).get("bottom_price").asDouble()),
                          style: const TextStyle(fontSize: 16.0,
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w500,
                            color: Colors.black,),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          'Terjual',
                          style: const TextStyle(fontSize: 11.0 ,
                            fontFamily: "Nunito",
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          'Rp.' + App.formatCurrency(nPolupate.getIn(index).get("open_price").asDouble()),
                          style: const TextStyle(fontSize: 16.0,
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w500,
                            color: Colors.black,),
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: CircleAvatar(
                          child: Text("B",
                            style: TextStyle(
                              color: Colors.white,  fontWeight: FontWeight.w700, fontSize: 18 , ),
                          ),
                          backgroundColor:  Color.fromARGB(255, 148, 193, 44) ,
                        ),
                      ),),

                  ],),

                ),
              ),

            ],
          ) ,
        )
    );
  }
  Widget _galeryCardSiapDiambil(int index, {String plan, String title,  bool selected } ){
    Color color = selected?  Color(0xffE4F1BF):  Colors.white;
    return
      Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(  Radius.circular(15)),
              side: BorderSide(width: 1, color: color)),

          color: color,
          margin: EdgeInsets.all(0.0),
          child: Container(
            /*
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.red[700],
            ),

            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
      */
            child:  Row(
              children: [
                Expanded(
                  flex: 2,
                  child:
                  Container(
                    height: 200,
                      margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                      child:
                      ClipRRect(
                        borderRadius: BorderRadius.only( topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                        child:  Image.network( nPolupate.getIn(index).get("foto").asString(),  fit: BoxFit.cover, ) ,
                      )
                  ),
                ),
                Expanded(
                  flex: 5,
                  child:
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    padding: EdgeInsets.only(top: 15, right: 5),
                    child:
                    Column(children: [ Stack( children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            nPolupate.getIn(index).get("vehicle_name").asString(),
                            style: const TextStyle(
                              fontFamily: "Nunito",
                              color: Color.fromARGB(255, 148, 193, 44),

                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                            ),
                          ),
                          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),



                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child:
                            Row(children: [
                              Text(
                                nPolupate.getIn(index).get("kik").asString(),
                                style: const TextStyle(fontSize: 11.0,
                                  fontFamily: "Nunito",
                                  color: Color.fromARGB(255, 143, 143, 143),

                                ),
                              ),
                              SizedBox(width: 10,),
                              Text(
                                nPolupate.getIn(index).get("Oto_json").get("Lokasi").asString().split(RegExp('\\s+'))[1],
                                style: const TextStyle(fontSize: 11.0,
                                  fontFamily: "Nunito",
                                  color: Color.fromARGB(255, 148, 193, 44),

                                ),
                              ),
                            ],),
                          ),

                          SizedBox(height: 10,),
                          Text(
                            'Dimenangkan seharga',
                            style: const TextStyle(fontSize: 11.0 ,
                              fontFamily: "Nunito",
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5,),
                          Text(
                            'Rp.' + App.formatCurrency(nPolupate.getIn(index).get("user_tertinggi").asDouble()),
                            style: const TextStyle(fontSize: 16.0,
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w500,
                              color: Colors.black,),
                          ),

                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: CircleAvatar(
                            child: Text(nPolupate.getIn(index).get("grade").asString(),
                              style: TextStyle(
                                color: Colors.white,  fontWeight: FontWeight.w700, fontSize: 18 , ),
                            ),
                            backgroundColor:  Color.fromARGB(255, 148, 193, 44) ,
                          ),
                        ),),

                    ],),
                      _ButonLokasi( "Lokasi pengambilan unit", () { }),

                    ],),


                  ),
                ),

              ],
            ) ,
          )
      );
  }


}

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
    App.log('build');
    return InkWell(
      onTap: () {
        //onChanged(!value);
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