import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class AdsCarousel extends StatefulWidget {

  final List ads;
  const AdsCarousel({Key key, this.ads}) : super(key: key);

  _AdsCarouselState createState() => _AdsCarouselState();
}

class _AdsCarouselState extends State<AdsCarousel> {

  @override
  void initState() {
    this._listAd();
    super.initState();
  }

  int _currentIndex = 0;
  List cardList = [];

  void _listAd() {
    for (var i = 0; i < widget.ads.length; i++) {
      cardList.add(_item(adData: widget.ads[i]));
    }
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
            height: 200.0,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 6),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            pauseAutoPlayOnTouch: true,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: cardList.map((card) {
            return Builder(builder: (BuildContext context) {
              return Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.30,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          stops: [0.5, 0],
                          colors: [Colors.blue[900], Colors.blue[100]]),
                    ),
                    child: card,
                  ),
                ),
              );
            });
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: map<Widget>(cardList, (index, url) {
            return Container(
              width: 10.0,
              height: 10.0,
              margin:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? Colors.blueAccent
                    : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }
}

Widget _item({adData}){
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0, 1],
          colors: [Color(0xFF1e6a35), Colors.blue[100]]),
    ),
    child: Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: Image.asset(
            'assets/images/blue_green_vector.png',
            fit: BoxFit.fill,
            color: Color.fromRGBO(255, 255, 255, 0.34),
            colorBlendMode: BlendMode.modulate,
            //width: MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.height,
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(16, 10, 0, 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              adData['_title'] ?? '',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Text(
                              adData['_desc'] ?? '',
                              textAlign: TextAlign.end,
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(16, 18, 0, 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              adData['_validUntil'] ?? '',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Text(
                              adData['_validUntilDesc'] ?? '',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(adData['_highlight'] ?? '',
                            style: TextStyle(
                                color: Colors.blue[900],
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold)),
                        Text(adData['_highlightDesc'] ?? '',
                            style: TextStyle(
                                color: Colors.blue[900],
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600)),
                      ],
                    )))
          ],
        ),
      ],
    ), //Text(adData.toString()),
  );
}