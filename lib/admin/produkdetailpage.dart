import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/gambar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constans.dart';
// import 'package:carousel_pro/carousel_pro.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';


class ProdukDetailPage extends StatefulWidget {
  final Widget? child;
  final int id;
  final String judul;
  final String harga;
  final String hargax;
  final String deskripsi;
  final String thumbnail;

  const ProdukDetailPage(this.id, this.judul, this.harga, this.hargax, this.deskripsi, this.thumbnail,
      {Key? key, this.child})
      : super(key: key);

  @override
  _ProdukDetailPageState createState() => _ProdukDetailPageState();
}

class _ProdukDetailPageState extends State<ProdukDetailPage> {
  List<Gambar> gambarlain = [];

  @override
  void initState() {
    super.initState();
    fetchGambar();
  }

  Future<List<Gambar>> fetchGambar() async {
    List<Gambar> usersList=[];
    var params = "/gambarlainbyid?id=" + widget.id.toString();
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      var jsonResponse = await http.get(sUrl);
      if (jsonResponse.statusCode == 200) {
        final jsonItems =
            json.decode(jsonResponse.body).cast<Map<String, dynamic>>();
        usersList = jsonItems.map<Gambar>((json) {
          return Gambar.fromJson(json);
        }).toList();
        setState(() {
          gambarlain = usersList;
        });
      }
    // ignore: empty_catches
    } catch (e) {}
    return usersList;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Palette.bg1,
    ));
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(widget.judul, style: const TextStyle(color: Colors.white)),
        backgroundColor: Palette.bg1,
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _body(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    List<NetworkImage> _listOfImages = <NetworkImage>[];
    _listOfImages = [];
    for (int i = 0; i < gambarlain.length; i++) {
      _listOfImages
          .add(NetworkImage(Palette.sUrl + gambarlain[i].images.toString()));
    }
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: gambarlain.isNotEmpty
                ? 
                AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Carousel(
                      boxFit: BoxFit.cover,
                      autoplay: true,
                      animationCurve: Curves.fastOutSlowIn,
                      animationDuration: const Duration(milliseconds: 1000),
                      dotSize: 6.0,
                      dotIncreasedColor: Colors.white,
                      dotBgColor: Colors.transparent,
                      dotPosition: DotPosition.bottomCenter,
                      dotVerticalPadding: 10.0,
                      showIndicator: true,
                      indicatorBgPadding: 7.0,
                      images: _listOfImages,
                    ),
                  )
                
                // CarouselSlider.builder(
                //     itemCount: gambarlain.length,
                //     options: CarouselOptions(
                //       aspectRatio: 1 / 1,
                //       viewportFraction: 1.0,
                //       enlargeCenterPage: true,
                //       enableInfiniteScroll: false,
                //     ),
                //     itemBuilder: (context, x) {
                //       return Container(
                //         child: Image.network(
                //             Palette.sUrl + gambarlain[x].images,
                //             fit: BoxFit.fitWidth),
                //       );
                //     },
                //   )
                : Image.network(Palette.sUrl + widget.thumbnail,
                    fit: BoxFit.fitWidth),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: SelectableText(widget.judul),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: SelectableText(widget.harga),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:const  <Widget>[
                SelectableText("Deskripsi :",style: TextStyle(decoration: TextDecoration.underline),),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: SelectableText(widget.deskripsi),
          ),
        ],
      ),
    );
  }
}
