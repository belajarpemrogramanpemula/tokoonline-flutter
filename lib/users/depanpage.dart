import 'package:flutter/material.dart';
import '../constans.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../helper/dbhelper.dart';
import 'package:sqflite/sqflite.dart';
import '../models/kategori.dart';
import '../models/carouselx.dart';
import '../models/produk.dart';
import 'produkdetailpage.dart';
import 'produkpage.dart';
// import 'package:carousel_pro/carousel_pro.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';

class Depan extends StatefulWidget {
  const Depan({Key? key}) : super(key: key);

  @override
  _DepanState createState() => _DepanState();
}

class _DepanState extends State<Depan> {
  DbHelper dbHelper = DbHelper();
  List<Kategori> kategorilist = [];
  List<Carouselx> carousellist = [];

  @override
  void initState() {
    super.initState();
    fetchCarousel();
    fetchKategori();
  }

  @override
  void dispose() {
    super.dispose();
    kategorilist = [];
    carousellist = [];
  }

  Future<List<Carouselx>> fetchCarousel() async {
    List<Carouselx> usersList = [];
    var params = "/carousel";
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      var jsonResponse = await http.get(sUrl);
      if (jsonResponse.statusCode == 200) {
        // Database db = await dbHelper.database;
        // var batch = db.batch();
        // batch.delete("carousel");
        //dbHelper.deletecarousel();
        final jsonItems =
            json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

        usersList = jsonItems.map<Carouselx>((json) {
          //dbHelper.insertcarousel(Carousel.fromJson(json));
          // batch.insert("carousel", Carouselx.fromMap(json).toMap());
          return Carouselx.fromJson(json);
        }).toList();

        // batch.commit();

        setState(() {
          carousellist = usersList;
        });
      }
    } catch (e) {
      getcarousel();
      usersList = carousellist;
    }
    return usersList;
  }

  void deletecarousel() async {
    await dbHelper.deletecarousel();
  }

  getcarousel() async {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<Carouselx>> listFuture = dbHelper.getcarousel();
      listFuture.then((_carousellist) {
        if (mounted) {
          setState(() {
            carousellist = _carousellist;
          });
        }
      });
    });
  }

  Future<List<Kategori>> fetchKategori() async {
    List<Kategori> usersList = [];
    var params = "/kategoribyproduk";
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      var jsonResponse = await http.get(sUrl);
      if (jsonResponse.statusCode == 200) {
        Database db = await dbHelper.database;
        var batch = db.batch();
        batch.delete("kategori");
        //dbHelper.deletekategori();
        final jsonItems =
            json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

        usersList = jsonItems.map<Kategori>((json) {
          //dbHelper.insertkategori(Kategori.fromJson(json));
          batch.insert("kategori", Kategori.fromMap(json).toMap());
          return Kategori.fromJson(json);
        }).toList();

        // await batch.commit();

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
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<Kategori>> listFuture = dbHelper.getkategori();
      listFuture.then((_kategorilist) {
        if (mounted) {
          setState(() {
            kategorilist = _kategorilist;
          });
        }
      });
    });
  }

  Future _refresh() {
    fetchCarousel().then((_carousel) {});
    return fetchKategori().then((_kategori) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Stack(children: <Widget>[
          SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  produkCarousel(),
                  produkbyKategori(),
                ]),
          ),
        ]),
      ),
    );
  }

  _listImages() {
    var listImages = [];
    for (int i = 0; i < carousellist.length; i++) {
      listImages.add(GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return ProdukDetailPage(
                carousellist[i].idproduk,
                carousellist[i].judul2,
                carousellist[i].harga2,
                carousellist[i].harga2x,
                carousellist[i].deskripsi,
                carousellist[i].thumbnail2,
                false);
          }));
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        Palette.sUrl + carousellist[i].thumbnail.toString()),
                    fit: BoxFit.cover),
              ),
              height: 140.0,
              width: MediaQuery.of(context).size.width,
            ),
            Positioned(
              bottom: 30,
              left: 20,
              child: Text(carousellist[i].judul,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w300)),
            ),
          ],
        ),
      ));
    }
    return listImages;
  }

  Widget produkCarousel() {
    // List<NetworkImage> _listOfImages = <NetworkImage>[];
    // _listOfImages = [];
    // for (int i = 0; i < carousellist.length; i++) {
    //   _listOfImages.add(NetworkImage(Palette.sUrl + carousellist[i].thumbnail.toString()));

    // }

    if (carousellist.isEmpty) return const Text('');
    return SizedBox(
      height: 140.0,
      child: AspectRatio(
        aspectRatio: MediaQuery.of(context).size.aspectRatio,
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
          images: _listImages(),
        ),
      ),
    );
  }

  Widget produkbyKategori() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (int i = 0; i < kategorilist.length; i++)
          WidgetbyKategori(
              kategorilist[i].id, kategorilist[i].nama.toString(), i),
      ],
    );
  }
}

class WidgetbyKategori extends StatefulWidget {
  final Widget? child;
  final int id;
  final String kategori;
  final int warna;

  const WidgetbyKategori(this.id, this.kategori, this.warna,
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
    var params = "/produkbykategori?id=" + id;
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
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<Produk>> listFuture = dbHelper.getproduk(id);
      listFuture.then((_produklist) {
        if (mounted) {
          setState(() {
            produklist = _produklist;
          });
        }
      });
    });
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
                            color: Palette.colors[widget.warna],
                            spreadRadius: 1),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return ProdukPage("kat", widget.id, 0, widget.kategori);
                      }));
                    },
                    child: const Text('Selengkapnya',
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              )),
          Container(
            height: 200.0,
            margin: const EdgeInsets.only(bottom: 7.0),
            child: FutureBuilder<List<Produk>>(
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
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int i) => Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) {
                          return ProdukDetailPage(
                              snapshot.data![i].id,
                              snapshot.data![i].judul,
                              snapshot.data![i].harga,
                              snapshot.data![i].hargax,
                              snapshot.data![i].deskripsi,
                              snapshot.data![i].thumbnail,
                              false);
                        }));
                      },
                      child: SizedBox(
                        width: 135.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                             Image.network(
                              Palette.sUrl + snapshot.data![i].thumbnail,
                              height: 110.0,
                              width: 110.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(snapshot.data![i].judul),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: Text(snapshot.data![i].harga),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
