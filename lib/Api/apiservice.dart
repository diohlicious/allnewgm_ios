//import 'package:http/http.dart' show Client;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grosir/Nikita/Nson.dart';
import 'package:grosir/Nikita/app.dart';
import 'package:grosir/welcome.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ApiService {
  final String asalKendaraanPath = "/api/registrasi/AsalKendaraanMobile";
  final String changePasswordPath = "/api/auth/changePasswordForgot";
  final String checkActiveTokenPath = "/api/cekaktiftokenMobile";
  final String generateVaPath = "/api/Pembayaran/GenerateVA";
  final String historyTransactionPath = "/api/Live/RiwayatMobile";
  final String homeComingSoonPath = "/api/comingsoon/listeventMobile";
  final String homeHistoryPath = "/api/Live/Riwayat";
  final String homeLivePath = "/api/Live/HomeMobile";
  final String invoiceVaPath = "/api/Pembayaran/InvoiceVA";
  final String kabupatenPath = "/api/registrasi/Kabupaten";
  final String kecamatanPath = "/api/registrasi/Kecamatan";
  final String kelurahanPath = "/api/registrasi/Kelurahan";
  final String listCartPath = "/api/Live/datakeranjang";
  final String liveBuyNowPath = "/api/Live/LiveBuyNow";
  final String liveNegoPath = "/api/Live/LiveNego";
  final String liveVehicleDetailPath = "/api/Live/detailMobile";
  final String loginPath = "/api/auth/loginMobile";
  final String logoutPath = "/api/auth/logout";
  final String provincePath = "/api/registrasi/Propinsi";
  final String questionFivePath = "/api/registrasi/SumberInfoMobile";
  final String questionFourPath = "/api/registrasi/JenisMobilMobile";
  final String questionOnePath =
      "/api/registrasi/KebutuhanKendaraanBulanMobile";
  final String questionThreePath = "/api/registrasi/KebutuhanPembelianMobile";
  final String questionTwoPath = "/api/registrasi/Rata2PenjualanMobile";
  final String resendOtpPath = "/api/registrasi/resendOtp";
  final String saveDataRegisterPath = "/api/registrasi/SimpanMobile";
  final String setAndUnsetFavoritePath = "/api/favorite/setAndUnsetFavorite";
  final String tahunKendaraanPath = "/api/registrasi/TahunKendaraanMobile";
  final String timeServerPath = "/api/jamserverMobile";
  final String tipeUsahaPath = "/api/registrasi/tipeusahamobile";

  /* renamed from: v1 */
  final String versi = "v1";

  /* renamed from: v2 */
  final String versi2 = "v2";
  final String validationOtpPath = "/api/registrasi/validasiOtpMobile";
  final String wareHousePath = "/api/lokasi/warehouseMobile";

  static const String host = "grosirmobil.id";

  //192.168.1.147:8181
  //dev.grosirmobil.id

  //final String baseUrl = "https://dev.grosirmobil.id/api/";
  final String baseUrl = "https://$host";

  Future<Nson> asalKendaraanApi() async {
    var response = await getRaw("/api/registrasi/AsalKendaraanMobile");
    return getNson(response);
  }

  Future<Nson> changePasswordApi(Nson ChangePasswordRequest) async {
    var response = await postRaw("/api/auth/changePasswordForgot",
        body: ChangePasswordRequest.asMap());
    return getNson(response);
  }

  Future<Nson> checkActiveTokenApi(String sAuthorization) async {
    var response = await postRaw("/api/auth/cekaktiftokenMobile",
        header: {'Authorization': sAuthorization});
    return getNson(response);
  }

  Future<Nson> generateVaApi(Nson nGenerateVaRequest) async {
    var response = await postRaw("/api/Pembayaran/GenerateVA",
        body: nGenerateVaRequest.asMap());
    return getNson(response);
  }

  Future<Nson> historyTransactionApi(Nson nArgs) async {
    var response =
        await postRaw("/api/Live/RiwayatMobile", body: nArgs.asMap());
    return getNson(response);
  }

  Future<Nson> homeComingSoonApi(Nson nArgs) async {
    var response =
        await postRaw("/api/comingsoon/listeventMobile", body: nArgs.asMap());
    return getNson(response);
  }

  Future<Nson> homeHistoryApi(Nson nArgs) async {
    var response =
        await postRaw("/api/Live/RiwayatMobile", body: nArgs.asMap());
    return getNson(response);
  }

  Future<http.Response> homeLiveApiRaw(Nson nArgs) async {
    var response = await postRaw("/api/Live/HomeMobile", body: nArgs.asMap());
    return response;
  }

  Future<Nson> homeLiveApi(Nson nArgs) async {
    var response = await postRaw("/api/Live/HomeMobile", body: nArgs.asMap());
    return getNson(response);
  }

  Future<Nson> invoiceVaApi(Nson nArgs) async {
    var response =
        await postRaw("/api/Pembayaran/InvoiceVA", body: nArgs.asMap());
    return getNson(response);
  }

  Future<Nson> kabupatenApi(Nson nArgs) async {
    var response =
        await postRaw("/api/registrasi/Kabupaten", body: nArgs.asMap());
    return getNson(response);
  }

  Future<Nson> kecamatanApi(Nson nArgs) async {
    var response =
        await postRaw("/api/registrasi/Kecamatan", body: nArgs.asMap());
    return getNson(response);
  }

  Future<Nson> kelurahanApi(Nson nArgs) async {
    var response =
        await postRaw("/api/registrasi/Kelurahan", body: nArgs.asMap());
    return getNson(response);
  }

  Future<Nson> keranjang(Nson nArgs) async {
    var response =
        await postRaw("/api/Live/datakeranjang", body: nArgs.asMap());
    return getNson(response);
  }

  Future<Nson> liveBuyNowApi(Nson nArgs) async {
    var response =
        await postRaw("/api/Live/LiveBuyNowMobile", body: nArgs.asMap());
    return getNson(response);
  }

  Future<Nson> liveNegoApi(Nson nArgs) async {
    var response =
        await postRaw("/api/Live/LiveNegoMobile", body: nArgs.asMap());
    return getNson(response);
  }

  Future<Nson> liveVehicleDetailApi(Nson nArgs) async {
    var response = await postRaw("/api/Live/detailMobile", body: nArgs.asMap());
    return getNson(response);
  }

  Future<Nson> loginApiMobile(Nson nArgs) async {
    var response = await postRaw("/api/auth/loginMobile", body: nArgs.asMap());
    return getNson(response);
  }

  Future<Nson> logoutApiMobile(Nson nArgs) async {
    var response = await getRaw("/api/auth/logout", header: nArgs.asMap());
    return getNson(response);
  }

  Future<Nson> provinceApi() async {
    var response = await getRaw("/api/registrasi/Propinsi");
    return getNson(response);
  }

  Future<Nson> questionOneApi() async {
    var response =
        await getRaw("/api/registrasi/KebutuhanKendaraanBulanMobile");
    return getNson(response);
  }

  Future<Nson> questionTwoApi() async {
    var response = await getRaw("/api/registrasi/KebutuhanPembelianMobile");
    return getNson(response);
  }

  Future<Nson> questionThreeApi() async {
    var response = await getRaw("/api/registrasi/JenisMobilMobile");
    return getNson(response);
  }

  Future<Nson> questionFourApi() async {
    var response = await getRaw("/api/registrasi/Rata2PenjualanMobile");
    return getNson(response);
  }

  Future<Nson> questionFiveApi() async {
    var response = await getRaw("/api/registrasi/SumberInfoMobile");
    return getNson(response);
  }

  Future<Nson> resendOtpApi(Nson nArgs) async {
    var response =
        await postRaw("/api/registrasi/resendOtp", body: nArgs.asMap());
    return getNson(response);
  }

  Future<Nson> saveDataRegisterApi(Nson nArgs) async {
    var response =
        await postRaw("/api/registrasi/SimpanMobile", body: nArgs.asMap());
    return getNson(response);
  }

  Future<http.Response> saveDataRegisterRes(Nson nArgs) async {
    var response =
        await postRaw("/api/registrasi/SimpanMobile", body: nArgs.asMap());
    return response;
  }

  Future<Nson> setAndUnsetFavoriteApi(Nson nArgs) async {
    var response =
        await postRaw("/api/favorite/setAndUnsetFavorite", body: nArgs.asMap());
    return getNson(response);
  }

  Future<Nson> tahunKendaraanApi(Nson nArgs) async {
    var response = await getRaw("/api/registrasi/TahunKendaraanMobile");
    return getNson(response);
  }

  Future<Nson> timeServerApi(Nson nArgs) async {
    var response = await postRaw("/api/jamserverMobile", body: nArgs.asMap());
    return getNson(response);
  }

  Future<Nson> checkMaintenanceApi() async {
    var response = await postRaw("/api/auth/checkMaintenance");
    return getNson(response);
  }

  Future<Nson> tipeUsahaApi(Nson nArgs) async {
    var response = await getRaw("/api/registrasi/tipeusahamobile");
    return getNson(response);
  }

  Future<Nson> validationOtpApi(Nson nArgs) async {
    var response =
        await postRaw("/registrasi/validasiOtpMobile", body: nArgs.asMap());
    return getNson(response);
  }

  Future<Nson> wareHouseApi() async {
    var response = await getRaw("/lokasi/registrasi/warehouseMobile");
    return getNson(response);
  }

  Future<http.Response> filterWarehouse() async {
    var response = await getRes("/api/lokasi/warehouseMobile");
    return response;
  }

  static ApiService apiService;

  static ApiService get() {
    if (apiService == null) {
      apiService = ApiService();
    }
    return apiService;
  }

  var client = http.Client();

  Future<String> getProfiles() async {
    final response = await client.get(Uri.parse("$baseUrl/api/profile"));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  /* Future<http.Response> postRequest () async {
    var url ='https://pae.ipportalegre.pt/testes2/wsjson/api/app/ws-authenticate';

    Map data = {
      'apikey': '12345678901234567890'
    };
    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post("$baseUrl/api/profile",
        headers: {"Content-Type": "application/json",
                 "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzIiwianRpIjoiNjU2MjBhOGE1OGJlOGM4ZDJiMWE1OGQ3ZmIyYWUzN2Y0YmNmMzljNjg2MWM3YmQyYTY3YjNjMjU3ZDI0MDg5ODMwMTQzMzcyY2E3M2MxNWYiLCJpYXQiOjE2MDgyNDUzMjksIm5iZiI6MTYwODI0NTMyOSwiZXhwIjoxNjM5NzgxMzI5LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.fnzw4nuI6fYvmFxR7yRv5c-2ZSF2XtkEjRxN8zUYxLFDBC2dKDeaDq1xUjuuFwtiyEX3M-w7B6X81fXy85NDmc1qdAiTnvYsLbTMgaeXj1ajAbLl8ZsASYrNFplMDIkhatyu1nafnJ6LPXQDYyU03Cj9OcoNBzZ6YmmqOp8LzPY-y2mFVJ3UhVvc_bqaHkEEwInYQ_yR5WHij6oGZ8CFE9oI3y10FeFtywYqbD_weVsUb7V3haL4nbI1r31mpPth-6nIjPgi0tsXnEBWRBAFi3CEIwsMD_ke0luNQlgyyum11QDaAys28EXj6DIpru00rhrUOa44lNl1JZXLJjMxY_HLFLC67yh7G_mEYlCOPwozepI8oR2zLwkxcCw5e1f7whrv8WnFjIiI9GdV1pkVQHT1SRskmfuCPd4TDLLokSuNHD8BaLMAqmU19lsntJ3dK-dvxe8E4rbc9S2VvztyEr_lbwz6iBDO7KXlqoZPAQbm6jiRWfdOsEsJs_CMQerbKxcS_KB1_Av3nh9ZCIbCcVJlKAjpNEzbjcufPKMRBeKSfF8yMGbTHqZk3h0Jbxctma6vy1U9wM-W0Hgih-lLBNNc-6_Hv3Uz4rAWwFTWpNZpVvG5ZK9-zlKOWacOBrVYzWEG5bpzs7Si1Z-EtRMic7IY8mG7qzm5NY8fG4Uqcvk"
                 },
        body: body
    );

    return response;
  }*/

  Future<Nson> getNson(http.Response response) async {
    try {
      var jbody = json.decode(response.body);
      if (jbody is Map) {
        return Nson(Map.from(jbody) ?? Map())
            .setMessage(response.statusCode, "");
      }
    } on Exception catch (_) {
      return Nson(Map()).setMessage(response.statusCode, response.body);
    }
    return Nson(Map()).setMessage(-1, 'null');
  }

  Future<http.Response> postRaw(String api, {Map header, Map body}) async {
    var url = '$baseUrl$api';
    App.log(url);
    //encode Map to JSON
    var jbody = json.encode(body);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Host": host,
      "Accept": "application/json",
      "Content-Length": jbody.length.toString(),
      "Authorization": "Bearer  " + await App.getSetting("auth")
    };
    var response =
        await http.post(Uri.parse(url), headers: headers, body: jbody);

    //App.log (json.encode(headers));
    //App.log (jbody);
    return response;
  }

  Future<http.Response> getRes(String url) =>
      //Uri uri = Uri.parse('$baseUrl$url');
      //Uri newUri = uri.replace(queryParameters: nson.asMap());
      http
          .get(
        Uri.parse('$baseUrl$url'),
        //headers: ,
      ) // Make HTTP-GET request
          .then((http.Response response) {
        // Convert response body to JSON object
        return response;
        //}
      });

  /*Future<http.Response> postRaw2 (String api, {Map body}) async {
    HttpClient client = new HttpClient();

    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);

    String url = 'https://dev.jobma.com:8090/v4/jobseeker/login';
    Map map = {
      "email": "hope@yopmail.com",
      "password": "123456"
    };
    print(map);

    // Creating body here
    List<int> body = utf8.encode(json.encode(map));
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    // Setting the content-length header here
    request.headers.set('Content-Length', body.length.toString());

   // Adding the body to the request
    request.add(body);

    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print(reply);

    return null;
  }
*/
  Future<http.Response> getRaw(String api, {Map header, Map body}) async {
    var url = '$baseUrl$api';
    App.log(url);

    String jbody = Uri(queryParameters: body).query;
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer  " + await App.getSetting("auth")
    };

    var response =
        await http.get(Uri.parse(url + '?' + jbody), headers: headers);
    App.log(jbody);

    return response;
  }

  Future<String> login() async {
    //final response = await client.get("$baseUrl/api/profile");
    var response = await http.post(Uri.parse("$baseUrl/api/profile"),
        body: {'name': 'doodle', 'color': 'blue'});
    String email = await App.getSetting("email");
    print("wwemail");
    print(email);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<http.Response> changePasswordForgot(
      String email, String newpassword) async {
    String email = await App.getSetting("email");
    var response = await postRaw("/auth/changePasswordForgot",
        body: {'email': email, 'newpassword': newpassword});
    return response;
  }

  Future<http.Response> changePassword(String oldpassword, newpassword) async {
    String email = await App.getSetting("email");
    var response = await postRaw("/api/profile/changePassword",
        body: {'email': email, 'old_password': oldpassword, 'new_password': newpassword, 'confirm_password': newpassword});
    return response;
  }

  Future<http.Response> loginMobile(
      String email, String password, token) async {
    var response = await postRaw("/api/auth/loginMobile", body: {
      'email': email,
      'password': password,
      "remember_me": false,
      "refreshedToken": token
    });
    return response;
  }

  Future<http.Response> validasiOtpMobile(String kodeOtp, userId) async {
    var response = await postRaw("/api/registrasi/validasiOtpMobile",
        body: {'email': userId, 'kodeOtp': kodeOtp});
    return response;
  }

  Future<http.Response> ResendOtp(String _name, _phone, _userId, _email) async {
    //String userId =  '1557';//await App.getSetting("email");
    //String email =   await App.getSetting("email");
    var response = await postRaw("/api/registrasi/resendOtp", body: {
      'tokenType': "Register",
      'phone': _phone,
      'namalengkap': _name,
      'userId': _userId,
      'email': _email
    });
    return response;
  }

  Future<http.Response> tipeusaha() async {
    String userId = '1608'; //await App.getSetting("email");
    var response = await getRes("/api/registrasi/tipeusahamobile");
    print(response.body);
    return response;
  }

  Future<http.Response> Propinsi() async {
    String userId = '1608'; //await App.getSetting("email");
    var response = await getRes("/api/registrasi/Propinsi");
    return response;
  }

  Future<http.Response> Kabupaten({int province_code}) async {
    var response = await postRaw("/api/registrasi/Kabupaten",
        body: {'province_code': province_code});
    return response;
  }

  Future<http.Response> Kecamatan({String city}) async {
    var response =
        await postRaw("/api/registrasi/Kecamatan", body: {'city': city});
    return response;
  }

  Future<http.Response> Kelurahan({String city, String sub_district}) async {
    var response = await postRaw("/api/registrasi/Kelurahan",
        body: {'city': city, 'sub_district': sub_district});
    return response;
  }

  // /api/filter/merek
  Future<http.Response> filterMerk() async {
    var response = await postRaw("/api/filter/merek");
    return response;
  }

  Future<http.Response> filterGrade() async {
    var response = await postRaw("/api/filter/grade");
    return response;
  }

  String getString(http.Response response) {
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "";
    }
  }

  Future<http.Response> sendimage(String email, String imageFilePath) async {
    String email = await App.getSetting("email");
    var response = await postRaw("auth/changePasswordForgot",
        body: {'email': email, 'newpassword': imageFilePath});

    String url = 'api' + '/api/account';
    http.Response za = await http.post(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Cookie":
          "MYCOOKIE=" + 'sessionCookie2' + "; MYTOKENS=" + 'sessionCookie3',
      "Content-type": "multipart/form-data",
    }, body: {
      "image": "",
    });
    Map content = json.decode(response.body);

    File imageFile = new File(imageFilePath);
    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = Base64Codec().encode(imageBytes);
    return response;
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    print("Handling a background message: ${message.toString()}");
  }

  Future<void> firebaseMessagingForegroundHandler() async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    //FirebaseMessaging messaging
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
          alert: true, badge: true, sound: true);
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
}
