import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/keranjang.dart';
import '../constans.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../helper/dbhelper.dart';
import 'package:sqflite/sqflite.dart';
import '../models/cabang.dart';
import '../models/gambar.dart';
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
  final bool valstok;

  const ProdukDetailPage(this.id, this.judul, this.harga, this.hargax,
      this.deskripsi, this.thumbnail, this.valstok,
      {Key? key, this.child})
      : super(key: key);

  @override
  _ProdukDetailPageState createState() => _ProdukDetailPageState();
}

class _ProdukDetailPageState extends State<ProdukDetailPage> {
  DbHelper dbHelper = DbHelper();
  String username = "";
  String? _valcabang;
  List<Cabang> cabanglist = [];
  bool instok = false;
  List<Gambar> gambarlain = [];

  @override
  void initState() {
    super.initState();
    cekLogin();
    fetchCabang();
    fetchGambar();
    _valcabang = null;
    // if (widget.valcab.isNotEmpty) {
    //   _valcabang = widget.valcab;
    // }
    if (widget.valstok == true) {
      instok = widget.valstok;
    }
  }

  Future<List<Cabang>> fetchCabang() async {
    List<Cabang> usersList = [];
    var params = "/cabang";
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      var jsonResponse = await http.get(sUrl);
      if (jsonResponse.statusCode == 200) {
        final jsonItems =
            json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

        usersList = jsonItems.map<Cabang>((json) {
          return Cabang.fromJson(json);
        }).toList();
        setState(() {
          cabanglist = usersList;
        });
      }
      // ignore: empty_catches
    } catch (e) {}
    // _cekCabang();
    return usersList;
  }

  // _cekCabang() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (prefs.getString('cabang') != "") {
  //     setState(() {
  //       _valcabang = prefs.getString('cabang');
  //     });
  //   }
  // }

  Future<List<Gambar>> fetchGambar() async {
    List<Gambar> usersList = [];
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

  cekLogin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? "";
    });
  }

  _cekProdukCabang(String idproduk, String idcabang) async {
    var params =
        "/cekprodukbycabang?idproduk=" + idproduk + "&idcabang=" + idcabang;
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      var res = await http.get(sUrl);
      if (res.statusCode == 200) {
        if (res.body == "OK") {
          setState(() {
            instok = true;
          });
        } else {
          setState(() {
            instok = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        instok = false;
      });
    }
  }

  Future<dynamic> _sendFav(Map data) async {
    var params = "/postfavorite";
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      http.post(sUrl, body: data).then((response) {
        var res = response.body.toString();
        if (res == "OK") {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/favusers', (Route<dynamic> route) => false);
        }
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  saveKeranjang(Keranjang _keranjang) async {
    Database db = await dbHelper.database;
    var batch = db.batch();
    db.execute(
        'insert into keranjang(idproduk,judul,harga,hargax,thumbnail,jumlah,userid,idcabang) values(?,?,?,?,?,?,?,?)',
        [
          _keranjang.idproduk,
          _keranjang.judul,
          _keranjang.harga,
          _keranjang.hargax,
          _keranjang.thumbnail,
          _keranjang.jumlah,
          _keranjang.userid,
          _keranjang.idcabang
        ]);
    await batch.commit();
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/keranjangusers', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Container(
          child: Row(
            children: [
              Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () => _sendFav(
                        {"userid": username, "idproduk": widget.id.toString()}),
                    child: Container(
                      child: const Icon(
                        Icons.favorite_border,
                        size: 40.0,
                      ),
                      decoration: BoxDecoration(
                        color: Palette.menuOther,
                        boxShadow: [
                          BoxShadow(color: Palette.menuOther, spreadRadius: 1),
                        ],
                      ),
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/keranjangusers', (Route<dynamic> route) => false);
                    },
                    child: Container(
                      child: const Icon(
                        Icons.shopping_cart,
                        size: 40.0,
                      ),
                      decoration: BoxDecoration(
                        color: Palette.menuOther,
                        boxShadow: [
                          BoxShadow(color: Palette.menuOther, spreadRadius: 1),
                        ],
                      ),
                    ),
                  )),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (instok == true) {
                      Keranjang _keranjangku = Keranjang(
                          idproduk: widget.id,
                          judul: widget.judul,
                          harga: widget.harga,
                          hargax: widget.hargax,
                          thumbnail: widget.thumbnail,
                          jumlah: 1,
                          userid: username,
                          idcabang: _valcabang.toString());
                      saveKeranjang(_keranjangku);
                    }
                  },
                  child: Container(
                    height: 40.0,
                    child: const Center(
                      child: Text('Beli Sekarang',
                          style: TextStyle(color: Colors.white)),
                    ),
                    decoration: BoxDecoration(
                      color: instok == true ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: instok == true ? Colors.blue : Colors.grey,
                            spreadRadius: 1),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          height: 60.0,
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
          decoration: BoxDecoration(
            color: Palette.menuOther,
            boxShadow: [
              BoxShadow(color: Palette.menuOther, spreadRadius: 1),
            ],
          ),
        ),
        elevation: 0,
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
                ? AspectRatio(
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
                //  CarouselSlider.builder(
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
              children: const <Widget>[
                SelectableText(
                  "Deskripsi :",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: SelectableText(widget.deskripsi),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: DropdownButtonFormField(
              isExpanded: true,
              decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 10, left: 12.0, bottom: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  fillColor: Colors.black,
                  filled: false),
              hint: const Text("Pilih Cabang"),
              value: _valcabang,
              items: cabanglist.map((item) {
                return DropdownMenuItem(
                  child: Text(item.nama.toString()),
                  value: item.id.toString(),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _valcabang = value.toString();
                  _cekProdukCabang(widget.id.toString(), _valcabang.toString());
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
