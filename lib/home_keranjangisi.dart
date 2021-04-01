

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  Future<Nson> _reload() async {
    if(App.needBuild) {
        App.needBuild = false;

        Nson args = Nson.newObject();
        args.set("page", 1);
        args.set("max", 20);

        Nson nson = await ApiService.get().keranjang(args);
        nPolupate = nson.get("data");
        App.log(nson.toStream());
    }

    return Nson.newObject();
  }
  Future refreshData() async {
    await _reload();
    setState(() { });
  }
  @override
  Widget build(BuildContext context) {
    App.log("buildkeranjang");
    return Container(
      /*onRefresh: refreshData,*/
      child:
      SingleChildScrollView(
          padding:  EdgeInsets.only(left: 10,right: 10),
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [Stack(children: [
              Text( "Keranjang",
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
                  child: InkWell(onTap: (){
                    final action = CupertinoActionSheet(
                      title: Text(
                        "Sortir berdasarkan",
                        style:  TextStyle(
                          fontFamily: "Nunito", fontWeight: FontWeight.w700,
                          fontSize: 20, color: Colors.black,
                        ),
                      ),
                      actions: <Widget>[
                        _ListSpinner("Waktu penawaran: Cepat ke Lama", () { sort("NO"); }),
                        _ListSpinner("Waktu penawaran: Lama ke Cepat", () { sort("ON"); }),
                        _ListSpinner("Abjad lokasi warehouse: A ➜ Z", () { sort("AZ"); }),
                        _ListSpinner("Abjad lokasi warehouse: Z ➜ A", () { sort("ZA"); }),
                        _ListSpinner("Bottom price: Terendah ke Tertinggi ", () { sort("LH"); }),
                        _ListSpinner("Bottom price: Tertinggi ke Terendah ", () { sort("HL"); }),

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
                    child:   Image.asset('assets/images/sort.png'),
                  ),), )
            ],),
              SizedBox(
                height: 10,
              ),
              _buildWidgetRefresh(),
            ],),

      ),
    );
  }

  void sort(String text)async {
    App.log("sort");
    var comp ;
    if (text == 'NO'||text == 'ON') {
      comp = (a, b) {
        Nson na = Nson(text == 'NO' ? a : b);
        Nson nb = Nson(text == 'NO' ? b : a);
        return na.get("vehicle_name").asString().compareTo(nb.get("vehicle_name").asString());
      };
    }else if (text == 'AZ'||text == 'ZA'){
      comp = (a, b) {
        Nson na = Nson(text == 'AZ' ? a : b);
        Nson nb = Nson(text == 'AZ' ? b : a);
        return na.get("vehicle_name").asString().compareTo(nb.get("vehicle_name").asString());
      };
    }else if (text == 'HL'||text == 'LH'){
      App.log(text);
      comp = (a, b) {
        Nson na = Nson(text == 'LH' ? a : b);
        Nson nb = Nson(text == 'LH' ? b : a);
        return na.get("bottom_price").asDouble().compareTo(nb.get("bottom_price").asDouble());
      };
    }else{
      comp = (a,b)=>0;
    }

    nPolupate.sort(comp);
    setState(() {

    });
  }

  Widget _ListSpinner(String text, VoidCallback callback){
    return  CupertinoActionSheetAction(
      child: Text(
        text,
        style:  TextStyle(
          fontFamily: "Nunito",
          fontSize: 16, color: Colors.black,
        )
        , ),
      isDefaultAction: true,
      onPressed: () {
        callback();
        Navigator.of(context).pop();
      },
    );
  }
  Widget _buildWidgetRefresh() {
    return  FutureBuilder(
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

    );

  }

  Widget _itemList(int index){
    Widget item  ;
      if (nPolupate.getIn(index).get("is_live").asInteger() == 1 ){
          //sedang berlangsung
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
                _bisatawar(index   ),

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
            _siapbayar( index  ),

          ],);
      }
      return item;
  }
  Widget _listConten() {
    return
      Container(
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

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
            nPolupate.size()>=1?Container() : _keranjangkosong(),
          ],
        ),
    ) ;
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
  void setFavUnFav(Nson data, int fav) async {
    const int max = 50;



    int favNow = (fav==1?0:1);

    Nson args = Nson.newObject();
    args.set("userid", await App.getSetting("userid"));
    args.set("kik", data.get("kik").asString());
    args.set("agreement_no", data.get("agreement_no").asString());
    args.set("gm_openhouse_id", data.get("ohid").asString());
    args.set("isfavorit", favNow);
    App.log(data.toStream());
    App.log(args.toStream());
    Nson nson = await ApiService.get().setAndUnsetFavoriteApi(args) ;
    App.log(nson.toStream());

    //{"message":"success","description":"Sukses menambah favorite"}
    if(nson.get("message").asString()=="success"){
      data.set("IsFavorit", favNow);
      App.needBuild =true;
      setState(() {

      });
    }


    //refreshData();


  }
  double tertinggi(Nson data){
    if (data.get("tertinggi").asDouble()==0){
      return data.get("bottom_price").asDouble();
    }
    return data.get("tertinggi").asDouble();
  }
  Widget _keranjangkosong(){
    return
      Container(
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
            Text("Keranjang Anda kosong", textAlign: TextAlign.center,style: TextStyle(
                fontFamily: "Nunito", fontWeight: FontWeight.w500,
                fontSize: 22
            ),),
            SizedBox(
              height: 20,
            ),
            Image.asset("assets/images/keranjang_kosong.png"),
            SizedBox(
              height: 20,
            ),

            Text("Anda belum melakukan penawaran.  Telusuri semua kendaraan yang kami tawarkan dan lakukan tawar/buy now", textAlign: TextAlign.center,style: TextStyle(
              fontFamily: "Nunito",
              color: Color.fromARGB(255, 143, 143, 143),
              fontWeight: FontWeight.w500,height: 1.5,
              fontSize: 14,   )),
            SizedBox(
              height: 10,
            ),

            _Buton( "Telusuri Kendaraan", () { }),

          ],
        ),
      );
  }
  Widget _bisatawar(   int index ){
    Color color =  Colors.white;
    return
      Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(  Radius.circular(15)),
              side: BorderSide(width: 1, color: color)),

          color: color,
          margin: EdgeInsets.all(0.0),
          child:
          Container(
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
                    padding: EdgeInsets.only(top: 5, right: 5),
                    child:
                    Column(children: [
                      Stack(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.55,
                              child: Text(
                              nPolupate.getIn(index).get("vehicle_name").asString(),
                              //overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16.0,
                              ),
                            ),
                              margin: EdgeInsets.only(right: 30),
                            ),


                            Row(children: [
                              Text(
                                nPolupate.getIn(index).get("agreement_no").asString(),
                                style: const TextStyle(fontSize: 11.0,
                                  fontFamily: "Nunito",
                                  color: Color.fromARGB(255, 143, 143, 143),

                                ),
                              ),
                              SizedBox(width: 10,),
                              Text(
                                "Jakarta",
                                style: const TextStyle(fontSize: 11.0,
                                  fontFamily: "Nunito",
                                  color: Color.fromARGB(255, 230, 36, 44),

                                ),
                              ),
                            ],),
                            SizedBox(height: 5,),
                            Text(
                              'Harga Awal',
                              style: const TextStyle(fontSize: 11.0 ,
                                fontFamily: "Nunito",
                                color: Colors.black,
                              ),
                            ),

                            Text(
                              'Rp.' + App.formatCurrency(nPolupate.getIn(index).get("bottom_price").asDouble()),
                              style: const TextStyle(fontSize: 16.0,
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w500,
                                color: Colors.black,),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              'Harga Sekarang',
                              style: const TextStyle(fontSize: 11.0 ,
                                fontFamily: "Nunito",
                                color: Colors.black,
                              ),
                            ),

                            Text(
                              'Rp.' + App.formatCurrency(nPolupate.getIn(index).get("open_price").asDouble()),
                              style: const TextStyle(fontSize: 16.0,
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w500,
                                color: Colors.black,),
                            ),

                          ],
                        ),
                        Container(
                            alignment:  Alignment.centerRight ,
                            child:
                            Column(children: [
                             /* CircleAvatar(
                                child:  Icon(Icons.favorite_border),
                                backgroundColor: Colors.white,),
*/
                              InkWell(
                                onTap: (){
                                  App.log(index);
                                   setFavUnFav(nPolupate.getIn(index), nPolupate.getIn(index).get("IsFavorit").asInteger());
                                },
                                child: CircleAvatar(
                                  child:  Icon(nPolupate.getIn(index).get("IsFavorit").asInteger() ==1 ? Icons.favorite: Icons.favorite_border),
                                  backgroundColor: Colors.white,
                                  foregroundColor: nPolupate.getIn(index).get("IsFavorit").asInteger() ==1 ? Colors.red : Colors.grey,),
                              ),
                              CircleAvatar(
                                child: Text( nPolupate.getIn(index).get("grade").asString(),
                                  style: TextStyle(
                                    color: Colors.white,  fontWeight: FontWeight.w700, fontSize: 18 , ),
                                ),
                                backgroundColor: Color.fromARGB(255, 230, 36, 44),),
                            ],
                            )
                        ),


                      ],),
                      SizedBox(height: 7,),
                      WCounter(
                        builds: (value, duration) =>
                            Container(
                              margin: EdgeInsets.only(right: 5),
                              child: Padding(
                                padding: EdgeInsets.only(),
                                child:   new Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  decoration: new BoxDecoration(
                                    color: Colors.red,
                                    border: new Border.all(color:  Colors.red, width: 1.0),
                                    borderRadius: new BorderRadius.circular(30.0),
                                  ),
                                  child:

                                  new Center(child:
                                  Container(
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
                                        const SizedBox(width: 5,),
                                        Text(
                                          value,
                                          style:  TextStyle(
                                              fontSize: 12.0,  fontWeight: FontWeight.w500,  color: Colors.white ),
                                        )
                                      ], ),
                                  ),
                                  ),
                                ),
                              ),
                            ),
                        start: nPolupate.getIn(index).get("end_date").asString(),
                        lead: lead,
                      ),
                      SizedBox(height: 7,),
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child:
                            InkWell(
                              onTap: (){
                                double i = tertinggi(nPolupate.getIn(index)) - 500000 ;
                                nPolupate.getIn(index).set("tertinggi", i);
                                setState(() {
                                });
                              },
                              child: Icon(
                                Icons.remove_circle_outline,
                                size: 32,
                                color: Colors.black54,
                              ),)  ,
                          ),
                          Positioned(
                            left: 50,
                            right: 50,
                            child: Container(
                              padding: EdgeInsets.only(bottom: 5),
                            /*  width: MediaQuery.of(context).size.width - 120,*/
                              child:
                              TextField(
                                enabled: false,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    fontSize: 16, color: Theme.of(context).accentColor),
                                controller: TextEditingController(
                                    text: "Rp. "+App.formatCurrency( tertinggi ( nPolupate.getIn(index) )  )),
                                decoration: InputDecoration(

                                  //hintStyle: CustomTextStyle.formField(context),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).accentColor, width: 1.0)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).accentColor, width: 1.0)),
                                ),
                                obscureText: false,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child:
                            InkWell(
                              onTap: (){
                                double i = tertinggi(nPolupate.getIn(index)) + 500000 ;
                                nPolupate.getIn(index).set("tertinggi", i);
                                setState(() {
                                });
                              },
                              child: Icon(
                                Icons.add_circle_outline,
                                size: 32,
                                color: Colors.black54,
                              ),)  ,
                          ),
                        ],
                      ),


                      SizedBox(height: 10,),
                      _butontawar(  "Tawar", () {
                        lanjutTawar(index);
                      })

                    ],),


                  ),
                ),

              ],
            ) ,
          )
      );
  }
  Widget _buttonGreen( String text ){
    return  Column(
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.only(),
              child:  new Container(
                width: MediaQuery.of(context).size.width,
                height: 45.0,
                decoration: new BoxDecoration(
                  color: Color.fromARGB( 255,    148,193,44  ),
                  border: new Border.all(color: Color.fromARGB(255,148,193,44), width: 1.0),
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                child: new Center(child: new Text(text, style: new TextStyle(fontWeight: FontWeight.w500,fontSize: 12.0, color: Colors.white),),),
              ),
            ),
          ),
        ]) ;
  }
  Widget _butontawar( String text, VoidCallback callback){
    return  Column(
        children: <Widget>[

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
                  height: 45.0,
                  decoration: new BoxDecoration(
                    color: Color.fromARGB( 255, 10,132,254 ),
                    border: new Border.all(color: Color.fromARGB( 255, 10,132,254 ), width: 1.0),
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: new Center(child: new Text(text, style: new TextStyle(fontWeight: FontWeight.w500,fontSize: 12.0, color: Colors.white),),),
                ),
              ),
            ),
          ),
        ]) ;
  }
  Widget _siapbayar(int index    ){
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
                    height: 180,
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
                  padding: EdgeInsets.only(top: 10, right: 5),
                  child:
                  Column(children: [
                    Stack( children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.55,
                            child: Text(
                            nPolupate.getIn(index).get("vehicle_name").asString(),
                            //overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16.0,
                            ),
                          ),
                            margin: EdgeInsets.only(right: 30),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child:
                            Row(children: [
                              Text(
                                nPolupate.getIn(index).get("agreement_no").asString(),
                                style: const TextStyle(fontSize: 11.0,
                                  fontFamily: "Nunito",
                                  color: Color.fromARGB(255, 143, 143, 143),

                                ),
                              ),
                              SizedBox(width: 10,),
                              Text(
                                "Jakarta",
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
                            'Rp.' + App.formatCurrency(nPolupate.getIn(index).get("tertinggi").asDouble()),
                            style: const TextStyle(fontSize: 16.0,
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w500,
                              color: Colors.black,),
                          ),

                        ],  ),
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
                      ),),//grade
                  ],),
                    SizedBox(height: 15,),
                    InkWell(
                      onTap: (){lanjutPembayaran(index);},
                      child:_buttonGreen(  "Lanjut Pembayaran") ,),
                   /* _buttonGreen(  "Lanjut Pembayaran", () {
                      App.log(index);
                      lanjutPembayaran(index);
                    }),*/

                  ],),


                ),
              ),

            ],
          ) ,
        )
    );
  }
  void lanjutTawar(int index) async {
    App.Arguments.set("args", nPolupate.getIn(index));
  /*  Navigator.push(context, new MaterialPageRoute(
        builder: (context) =>
        new Tawar()));*/

    Navigator.of(context).pushNamed(  "/tawar", arguments: nPolupate.getIn(index).asMap());
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
    Navigator.of(context).pushNamed(  "/menangbayar", arguments: nPolupate.getIn(index).asMap());
  }

}

