import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/kategori.dart';
import '../models/produk.dart';

import '../constans.dart';
import '../helper/dbhelper.dart';

import 'formcarousel.dart';
import 'formprodukpage.dart';
import 'produkdetailpage.dart';

// ignore: use_key_in_widget_constructors
class Beranda extends StatefulWidget {
  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  DbHelper dbHelper = DbHelper();
  List<Kategori> kategorilist = [];
  List<Produk> produklist = [];
  String userid = "";
  int jmlnotif = 0;

  @override
  void initState() {
    super.initState();
    cekLogin();
  }

  @override
  void dispose() {
    super.dispose();
    kategorilist = [];
  }

  cekLogin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString('username') ?? "";
    });
    fetchKategori();
    _cekSt();
  }

  _cekSt() async {
    if (userid == "") {
    } else {
      var params = "/cekstbyuseridcabang?userid=" + userid;
      var sUrl = Uri.parse(Palette.sUrl + params);
      try {
        http.get(sUrl).then((response) {
          var res = response.body.toString().split("|");
          if (res[0] == "OK") {
            if (mounted) {
              setState(() {
                jmlnotif = int.parse(res[1]);
              });
            }
          }
        });
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  Future<List<Kategori>> fetchKategori() async {
    List<Kategori> usersList = [];
    var params = "/kategoribyprodukbyuserid?userid=" + userid;
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      var jsonResponse = await http.get(sUrl);
      if (jsonResponse.statusCode == 200) {
        // Database db = await dbHelper.database;
        // var batch = db.batch();
        // batch.delete("kategori");
        //dbHelper.deletekategori();
        final jsonItems =
            json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

        usersList = jsonItems.map<Kategori>((json) {
          //dbHelper.insertkategori(Kategori.fromJson(json));
          // batch.insert("kategori", Kategori.fromMap(json).toMap());
          return Kategori.fromJson(json);
        }).toList();

        // batch.commit();

        setState(() {
          kategorilist = usersList;
        });
      }
    } catch (e) {
      getkategori();
      usersList = kategorilist;
    }
    return usersList;
  }

  void deletekategori() async {
    await dbHelper.deletekategori();
  }

  getkategori() async {
    // final Future<Database> dbFuture = dbHelper.initDb();
    // dbFuture.then((database) {
    //   Future<List<Kategori>> listFuture = dbHelper.getkategori();
    //   listFuture.then((_kategorilist) {
    //     if (mounted) {
    //       setState(() {
    //         kategorilist = _kategorilist;
    //       });
    //     }
    //   });
    // });
  }

  Future _refresh() {
    return fetchKategori().then((_kategori) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk', style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/transaksicabang', (Route<dynamic> route) => false);
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Stack(
                    children: [
                      const Icon(
                        Icons.notifications,
                        size: 28.0,
                      ),
                      Positioned(
                        top: 2,
                        right: 4,
                        child: jmlnotif > 0
                            ? Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  jmlnotif.toString(),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : const Text(''),
                      ),
                    ],
                  ),
                ),
              )),
        ],
        actionsIconTheme:
            const IconThemeData(size: 26.0, color: Colors.white, opacity: 10.0),
        backgroundColor: Palette.bg1,
      ),
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Stack(children: <Widget>[
          SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  produkbyKategori(),
                ]),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return const FormProdukPage();
          }));
        },
        tooltip: 'Tambah',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget produkbyKategori() {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (int i = 0; i < kategorilist.length; i++)
            WidgetbyKategori(
                kategorilist[i].id, kategorilist[i].nama.toString(), userid, i),
        ],
      ),
    );
  }
}

class WidgetbyKategori extends StatefulWidget {
  final Widget? child;
  final int id;
  final String kategori;
  final String userid;
  final int warna;

  const WidgetbyKategori(this.id, this.kategori, this.userid, this.warna,
      {Key? key, this.child})
      : super(key: key);

  @override
  _WidgetbyKategoriState createState() => _WidgetbyKategoriState();
}

class _WidgetbyKategoriState extends State<WidgetbyKategori> {
  DbHelper dbHelper = DbHelper();
  List<Produk> produklist = [];

  Future<List<Produk>> fetchProduk(String id) async {
    List<Produk> usersList = [];
    var params =
        "/produkbykategoriallbyuserid?id=" + id + "&userid=" + widget.userid;
    var sUrl = Uri.parse(Palette.sUrl + params);

    try {
      var jsonResponse = await http.get(sUrl);
      if (jsonResponse.statusCode == 200) {
        // Database db = await dbHelper.database;
        // var batch = db.batch();
        // batch.delete('produk', where: 'idkategori=?', whereArgs: [id]);
        //dbHelper.deleteproduk(int.parse(id));
        final jsonItems =
            json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

        usersList = jsonItems.map<Produk>((json) {
          //dbHelper.insertproduk(Produk.fromJson(json));
          // batch.insert("produk", Produk.fromMap(json).toMap());
          return Produk.fromJson(json);
        }).toList();

        // batch.commit();
        //await db.close();

        setState(() {
          produklist = usersList;
        });
      }
    } catch (e) {
      getproduk(int.parse(id));
      usersList = produklist;
    }
    return usersList;
  }

  void deleteproduk(int id) async {
    await dbHelper.deleteproduk(id);
  }

  getproduk(int id) async {
    // final Future<Database> dbFuture = dbHelper.initDb();
    // dbFuture.then((database) {
    //   Future<List<Produk>> listFuture = dbHelper.getproduk(id);
    //   listFuture.then((_produklist) {
    //     if (mounted) {
    //       setState(() {
    //         produklist = _produklist;
    //       });
    //     }
    //   });
    // });
  }

  _hapusProduk(int id, String idkategori) async {
    var params = "/hapusprodukcabangbyid?idproduk=" +
        id.toString() +
        "&userid=" +
        widget.userid;
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      http.get(sUrl).then((response) {
        var res = response.body.toString();
        if (res == "OK") {
          fetchProduk(idkategori);
        }
      });
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.only(right: 10.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text(
                    widget.kategori,
                    style: const TextStyle(color: Colors.white),
                  ),
                  width: 200.0,
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0)),
                    color: Palette.colors[widget.warna],
                    boxShadow: [
                      BoxShadow(
                          color: Palette.colors[widget.warna], spreadRadius: 1),
                    ],
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder<List<Produk>>(
            future: fetchProduk(widget.id.toString()),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Column(
                    children: const [
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              }
              return GridView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                ),
                children: snapshot.data!.map((e) {
                  return Card(
                    margin: const EdgeInsets.all(10),
                    // ignore: avoid_unnecessary_containers
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (_) {
                                return ProdukDetailPage(e.id, e.judul, e.harga,
                                    e.hargax, e.deskripsi, e.thumbnail);
                              }));
                            },
                            // ignore: avoid_unnecessary_containers
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  // ignore: avoid_unnecessary_containers
                                  Container(
                                    child: AspectRatio(
                                      aspectRatio: 1 / 1,
                                      child: Image.network(
                                          Palette.sUrl + e.thumbnail,
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                  // new Image.network(Palette.sUrl + e.thumbnail),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(e.judul),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, bottom: 5.0),
                                    child: Text(e.harga),
                                  ),
                                ],
                              ),
                            ),
                            //Image.network(Palette.sUrl + e.thumbnail),
                          ),
                          Expanded(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (_) {
                                    return FormCarousel(e.id, e.judul);
                                  }));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 5.0, right: 5.0),
                                  margin: const EdgeInsets.only(
                                      right: 5.0, bottom: 5.0),
                                  height: 40.0,
                                  child: Center(
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.verified_rounded,
                                          color: Colors.white,
                                          size:11.0
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(
                                          'Promo',
                                          style: TextStyle(color: Colors.white,fontSize:11.0 ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.green, spreadRadius: 1),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _hapusProduk(e.id, widget.id.toString());
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 5.0, right: 5.0),
                                  margin: const EdgeInsets.only(
                                      right: 5.0, bottom: 5.0),
                                  height: 40.0,
                                  child: Center(
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.clear,
                                          color: Colors.white,
                                          size:11.0
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(
                                          'Hapus',
                                          style: TextStyle(color: Colors.white,fontSize:11.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.red, spreadRadius: 1),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
