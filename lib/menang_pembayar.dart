import 'package:clipboard/clipboard.dart';
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
import 'package:intl/intl.dart';

import 'UI/CustomIcons.dart';
import 'UI/SocialIcons.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class MenangPemBayar extends StatefulWidget {
  @override
  _MenangPemBayarState createState() => _MenangPemBayarState();
}

class _MenangPemBayarState extends State<MenangPemBayar> {
  // App.log(App.Arguments.get("args").toJson()); anka
  Nson args = Nson.newObject();
  Nson nPolulate = Nson.newObject();
  List<bool> _isOpen = [false, false, false, false, false];

  refreshData() async {
    _reload();
    setState(() {});
  }

  Future<Nson> _reload() async {
    const int max = 50;

    //live
    Nson arg = Nson.newObject();
    arg.set("ref", args.get("orderno").asString());

    Nson nson = await ApiService.get().invoiceVaApi(arg);
    nPolulate = nson.get("data");
    App.log(nson.toStream());

    return Nson.newObject();
  }

  Widget _buildContent(BuildContext context) {
    return FutureBuilder<Nson>(
      future: _reload(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _content(context);
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
    if (arguments != null) {
      args = Nson(arguments);
    } else {
      args = App.Arguments.get("args");
    }
    App.log(args.toJson());

    return Scaffold(
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
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20, bottom: 30),
              alignment: Alignment.centerLeft,
              child: Text(
                "Pembayaran",
                style: TextStyle(
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 24),
              ),
            ),
            SizedBox(
              height: (10),
            ),
            Container(
                child: Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: _buildContent(context),
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
              App.needBuild = true;
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/home', (Route<dynamic> route) => false);
              /*AwesomeDialog(
                  context: context,
                  dialogType: DialogType.NO_HEADER,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'Syarat dan ketentuan Grosir Mobil',
                  body:
                  Column(children: [
                    Text('Cara Pembayaran'  ,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontFamily: "Nunito",
                            height: 1.2,fontSize: 22
                        )),
                    SizedBox(height :10),
                    Text('''
ATM BCA

* Masukkan Kartu ATM BCA & PIN
* Pilih menu Transaksi Lainnya > Transfer > ke Rekening BCA Virtual Account
* Masukkan 5 angka kode perusahaan untuk Grosir Mobil, dh PT SOLUSI INTEGRASI PRATAMA (11904) dan Nomor HP yang terdaftar di akun Grosir Mobil Anda (Contoh: 1190422004000114)
* Di halaman konfirmasi, pastikan detil pembayaran sudah sesuai seperti No VA, Unit yang dibeli, Tanggal berlaku VA dan Total Tagihan
* Masukkan Jumlah Transfer sesuai dengan Total Tagihan
* Ikuti instruksi untuk menyelesaikan transaksi
* Simpan struk transaksi sebagai bukti pembayaran
M - BCA (BCA Mobile)

* Lakukan log in pada aplikasi BCA Mobile
* Pilih menu m-BCA, kemudian masukkan kode akses m-BCA
* Pilih m-Transfer > BCA Virtual Account
* Pilih dari Daftar Transfer, atau masukkan 5 angka kode perusahaan untuk Grosir Mobil, dh. PT SOLUSI INTEGRASI PRATAMA (11904) dan Nomor HP yang terdaftar di akun Grosir Mobil Anda (Contoh: 1190422004000114)
* Masukkan pin m-BCA
* Pembayaran selesai.
* Simpan notifikasi yang muncul sebagai bukti pembayaran
Internet Banking BCA

* Login pada alamat Internet Banking BCA (klikbca.com)
* Pilih menu Pembayaran Tagihan > Pembayaran > BCA Virtual Account
* Pada kolom kode bayar, masukkan 5 angka kode perusahaan ntuk Grosir Mobil, dh PT SOLUSI INTEGRASI PRATAMA (11904) dan Nomor HP yang terdaftar di akun Grosir Mobil Anda (Contoh: 1190422004000114)
* Di halaman konfirmasi, pastikan detil pembayaran sudah sesuai seperti Nomor BCA Virtual Account, Unit yang dibeli, Tanggal berlaku VA dan Total Tagihan
* Masukkan password dan mToken
* Cetak/simpan struk pembayaran BCA Virtual Account sebagai bukti pembayaran

Kantor Bank BCA
*
Ambil nomor antrian transaksi Teller dan isi slip setoran
* Serahkan slip dan jumlah setoran kepada Teller BCA
* Teller BCA akan melakukan validasi transaksi
* Simpan slip setoran hasil validasi sebagai bukti pembayaran                    '''
                        ,
                        textAlign: TextAlign.justify,
                        style: TextStyle(

                            fontWeight: FontWeight.w500, fontFamily: "Nunito",
                            height: 1.5,
                            fontSize: 14, color: Color.fromARGB(255, 143, 143, 143)
                        )
                    )],

                  ) ,

                  */ /*btnOkOnPress: () {
                      Navigator.of(context).pushNamed('/ganti');
                    },*/ /*
                  dismissOnTouchOutside: true
              ).show();*/
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
                  'Kembali ke menang ',
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

    /*MaterialApp(

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
        Scaffold(

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

          resizeToAvoidBottomPadding: false,
          body: SingleChildScrollView(child:
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20,bottom:30),
                alignment: Alignment.centerLeft,
                child: Text( "Pembayaran",
                  style: TextStyle(
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 24),
                ),),

              SizedBox(
                height: (10),
              ),
              Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child:  _content(context),)
              ),
            ],
          ),
          ) ,

          bottomSheet: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(25) ,
            child: Padding(
              padding: EdgeInsets.only(),
              child: InkWell(
                onTap: () {
                  print('hello');
                  //Navigator.of(context).pop();
                  AwesomeDialog(
                      context: context,
                      dialogType: DialogType.NO_HEADER,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Syarat dan ketentuan Grosir Mobil',
                      body:
                      Column(children: [
                        Text('Cara Pembayaran'  ,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontFamily: "Nunito",
                                height: 1.2,fontSize: 22
                            )),
                        SizedBox(height :10),
                        Text('''
ATM BCA

* Masukkan Kartu ATM BCA & PIN
* Pilih menu Transaksi Lainnya > Transfer > ke Rekening BCA Virtual Account
* Masukkan 5 angka kode perusahaan untuk Grosir Mobil, dh PT SOLUSI INTEGRASI PRATAMA (11904) dan Nomor HP yang terdaftar di akun Grosir Mobil Anda (Contoh: 1190422004000114)
* Di halaman konfirmasi, pastikan detil pembayaran sudah sesuai seperti No VA, Unit yang dibeli, Tanggal berlaku VA dan Total Tagihan
* Masukkan Jumlah Transfer sesuai dengan Total Tagihan
* Ikuti instruksi untuk menyelesaikan transaksi
* Simpan struk transaksi sebagai bukti pembayaran
M - BCA (BCA Mobile)

* Lakukan log in pada aplikasi BCA Mobile
* Pilih menu m-BCA, kemudian masukkan kode akses m-BCA
* Pilih m-Transfer > BCA Virtual Account
* Pilih dari Daftar Transfer, atau masukkan 5 angka kode perusahaan untuk Grosir Mobil, dh. PT SOLUSI INTEGRASI PRATAMA (11904) dan Nomor HP yang terdaftar di akun Grosir Mobil Anda (Contoh: 1190422004000114)
* Masukkan pin m-BCA
* Pembayaran selesai.
* Simpan notifikasi yang muncul sebagai bukti pembayaran
Internet Banking BCA

* Login pada alamat Internet Banking BCA (klikbca.com)
* Pilih menu Pembayaran Tagihan > Pembayaran > BCA Virtual Account
* Pada kolom kode bayar, masukkan 5 angka kode perusahaan ntuk Grosir Mobil, dh PT SOLUSI INTEGRASI PRATAMA (11904) dan Nomor HP yang terdaftar di akun Grosir Mobil Anda (Contoh: 1190422004000114)
* Di halaman konfirmasi, pastikan detil pembayaran sudah sesuai seperti Nomor BCA Virtual Account, Unit yang dibeli, Tanggal berlaku VA dan Total Tagihan
* Masukkan password dan mToken
* Cetak/simpan struk pembayaran BCA Virtual Account sebagai bukti pembayaran

Kantor Bank BCA
*
Ambil nomor antrian transaksi Teller dan isi slip setoran
* Serahkan slip dan jumlah setoran kepada Teller BCA
* Teller BCA akan melakukan validasi transaksi
* Simpan slip setoran hasil validasi sebagai bukti pembayaran                    '''
                            ,
                            textAlign: TextAlign.justify,
                            style: TextStyle(

                                fontWeight: FontWeight.w500, fontFamily: "Nunito",
                                height: 1.5,
                                fontSize: 14, color: Color.fromARGB(255, 143, 143, 143)
                            )
                        )],

                      ) ,

                      */ /*btnOkOnPress: () {
                      Navigator.of(context).pushNamed('/ganti');
                    },*/ /*
                      dismissOnTouchOutside: true
                  ).show();
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
                  Text('Kembali ke menang ',
                    style: new TextStyle(fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                        color: Colors.white),),),
                ),
              ),
            ),
          ),
        ),

        debugShowCheckedModeBanner: true,
      );*/
  }

  Widget textViewPembayaran(context, String text, String val, {bool copy}) {
    copy = (copy == true ? true : false);
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
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
                    fontSize: 14)),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2,
            child: Row(
              children: [
                Text(val,
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                copy
                    ? InkWell(
                        onTap: () {
                          FlutterClipboard.copy(val)
                              .then((value) => print('copied'));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 12,
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            iconSize: 20,
                            //onPressed: () => _controller.clear(),
                            icon: Icon(Icons.content_copy),
                          ),
                        ),
                      )
                    : Text(''),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _content(context) {
    String endate = nPolulate.get("dataVA").get("EndDateVA").asString();
    try {
      //lead

      DateTime exndate = DateTime.parse(endate);
      endate = DateFormat(DateFormat.WEEKDAY +
              ', ' +
              DateFormat.DAY +
              ' ' +
              DateFormat.MONTH +
              ' ' +
              DateFormat.YEAR)
          .format(exndate);
    } on Exception catch (_) {}

    String unit_yng_dibeli = "- " +
        nPolulate.get("detail").getIn(0).get("asset_description").asString();
    for (var i = 1; i < args.get("detail").size(); i++) {
      unit_yng_dibeli = unit_yng_dibeli +
          "\r\n- " +
          nPolulate.get("detail").getIn(i).get("asset_description").asString();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text("Segera lakukan pembayaran dalam waktu",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "Nunito",
                color: Color.fromARGB(255, 143, 143, 143),
                fontWeight: FontWeight.w500,
                fontSize: 14)),
        SizedBox(
          height: 20,
        ),
        WCounter(
          builds: (value, duration) => Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 20,
                ),
                _timeView(duration.get("Days").asString().substring(0, 1)),
                _timeView(duration.get("Days").asString().substring(1, 2)),
                SizedBox(
                  width: 2,
                ),
                _timeView(duration.get("Hours").asString().substring(0, 1)),
                _timeView(duration.get("Hours").asString().substring(1, 2)),
                SizedBox(
                  width: 2, /**/
                ),
                _timeView(duration.get("Minutes").asString().substring(0, 1)),
                _timeView(duration.get("Minutes").asString().substring(1, 2)),
                SizedBox(
                  width: 2,
                ),
                _timeView(duration.get("Seconds").asString().substring(0, 1)),
                _timeView(duration.get("Seconds").asString().substring(1, 2)),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
          start: nPolulate.get("dataVA").get("EndDateVA").asString(),
          lead: 0,
        ),
        SizedBox(
          height: (50),
        ),
        Text("Sebelum " + endate,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "Nunito",
                color: Color.fromARGB(255, 143, 143, 143),
                fontWeight: FontWeight.w500,
                fontSize: 14)),
        SizedBox(
          height: (50),
        ),
        Text("Informasi Pembayaran",
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        SizedBox(
          height: 20,
        ),
        textViewPembayaran(context, "Unit yang dibeli:", unit_yng_dibeli),
        SizedBox(
          height: 10,
        ),
        textViewPembayaran(context, "Pembayaran:",
            nPolulate.get("dataVA").get("VA_number").asString(),
            copy: true),
        SizedBox(
          height: 10,
        ),
        textViewPembayaran(context, "Tipe Pembayaran:", "BCA Virtual Account"),
        SizedBox(
          height: 10,
        ),
        //textViewPembayaran(context, "Promo:", "10%, voucher potongan 10%"),
        SizedBox(
          height: 10,
        ),
        textViewPembayaran(
            context,
            "Total Pembayaran:",
            "Rp " +
                App.formatCurrency(
                    nPolulate.get("dataVA").get("totamount").asDouble())),
        SizedBox(
          height: (50),
        ),
        Text("Cara Pembayaran",
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        SizedBox(
          height: 20,
        ),
        ExpansionPanelList(
          animationDuration: Duration(seconds: 1),
          expansionCallback: (i, _isExpanded) => setState(() {
            _isOpen[i] = !_isExpanded;
            print(_isOpen);
          }),
          children: [
            ExpansionPanel(
              isExpanded: _isOpen[0],
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text('ATM BCA'),
                );
              },
              body: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text('''
* Masukkan Kartu ATM BCA & PIN
* Pilih menu Transaksi Lainnya > Transfer > ke Rekening BCA Virtual Account
* Masukkan 5 angka kode perusahaan untuk Grosir Mobil, dh PT SOLUSI INTEGRASI PRATAMA (11904) dan Nomor HP yang terdaftar di akun Grosir Mobil Anda (Contoh: 1190422004000114)
* Di halaman konfirmasi, pastikan detil pembayaran sudah sesuai seperti No VA, Unit yang dibeli, Tanggal berlaku VA dan Total Tagihan
* Masukkan Jumlah Transfer sesuai dengan Total Tagihan
* Ikuti instruksi untuk menyelesaikan transaksi
* Simpan struk transaksi sebagai bukti pembayaran
    ''',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: "Nunito",
                            height: 1.5,
                            fontSize: 14,
                            color: Color.fromARGB(255, 143, 143, 143))),
                  )
                ],
              ),
            ),
            ExpansionPanel(
              isExpanded: _isOpen[1],
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text('m-BCA (BCA Mobile'),
                );
              },
              body: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text('''

* Lakukan log in pada aplikasi BCA Mobile
* Pilih menu m-BCA, kemudian masukkan kode akses m-BCA
* Pilih m-Transfer > BCA Virtual Account
* Pilih dari Daftar Transfer, atau masukkan 5 angka kode perusahaan untuk Grosir Mobil, dh. PT SOLUSI INTEGRASI PRATAMA (11904) dan Nomor HP yang terdaftar di akun Grosir Mobil Anda (Contoh: 1190422004000114)
* Masukkan pin m-BCA
* Pembayaran selesai.
* Simpan notifikasi yang muncul sebagai bukti pembayaran
    ''',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: "Nunito",
                            height: 1.5,
                            fontSize: 14,
                            color: Color.fromARGB(255, 143, 143, 143))),
                  )
                ],
              ),
            ),
            ExpansionPanel(
              isExpanded: _isOpen[2],
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text('Internet Banking BCA'),
                );
              },
              body: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text('''
* Login pada alamat Internet Banking BCA (klikbca.com)
* Pilih menu Pembayaran Tagihan > Pembayaran > BCA Virtual Account
* Pada kolom kode bayar, masukkan 5 angka kode perusahaan ntuk Grosir Mobil, dh PT SOLUSI INTEGRASI PRATAMA (11904) dan Nomor HP yang terdaftar di akun Grosir Mobil Anda (Contoh: 1190422004000114)
* Di halaman konfirmasi, pastikan detil pembayaran sudah sesuai seperti Nomor BCA Virtual Account, Unit yang dibeli, Tanggal berlaku VA dan Total Tagihan
* Masukkan password dan mToken
* Cetak/simpan struk pembayaran BCA Virtual Account sebagai bukti pembayaran
    ''',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: "Nunito",
                            height: 1.5,
                            fontSize: 14,
                            color: Color.fromARGB(255, 143, 143, 143))),
                  )
                ],
              ),
            ),
          ],
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
          height: (90),
        ),
      ],
    );
  }

  Widget _timeView(dynamic digit) {
    return Container(
      width: 35.0,
      height: 45.0,
      alignment: Alignment.center,
      child: Text(
        digit.toString(),
        style: TextStyle(
          fontSize: 30.0,
          color: Colors.black,
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.white12,
          image: DecorationImage(
            image: AssetImage("assets/images/timebox.png"),
            fit: BoxFit.contain,
          ),
          borderRadius: BorderRadius.all(Radius.circular(7)),
          border: Border.all(
            width: 1.0,
            color: Colors.black12,
          )),
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
