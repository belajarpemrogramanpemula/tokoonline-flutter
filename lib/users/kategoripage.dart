import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../constans.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../helper/dbhelper.dart';
import '../models/kategori.dart';
import '../models/subkategori.dart';
import 'produkpage.dart';

class KategoriPage extends StatefulWidget {
  const KategoriPage({Key? key}) : super(key: key);

  @override
  _KategoriPageState createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  DbHelper dbHelper = DbHelper();
  List<Kategori> kategorilist = [];
  List<Subkategori> subkategorilist = [];
  int idkategori = 0;
  int idsubkategori = 0;
  String namakategori = "";
  double ukuranfont = 14.0;
  int li = 1;

  @override
  void initState() {
    super.initState();
    fetchSubKategoriAll();
  }

  Future<List<Subkategori>> fetchSubKategoriAll() async {
    List<Subkategori> usersList = [];
    var params = "/subkategori";
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      var jsonResponse = await http.get(sUrl);
      if (jsonResponse.statusCode == 200) {
        //dbHelper.deletesubkategori();
        final jsonItems =
            json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

        usersList = jsonItems.map<Subkategori>((json) {
          //dbHelper.insertsubkategori(Subkategori.fromJson(json));
          return Subkategori.fromJson(json);
        }).toList();
      }
    } catch (e) {
      usersList = subkategorilist;
    }
    return usersList;
  }

  Future<List<Kategori>> fetchKategori() async {
    List<Kategori> usersList = [];
    var params = "/kategoribyproduk";
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      var jsonResponse = await http.get(sUrl);
      if (jsonResponse.statusCode == 200) {
        //dbHelper.deletekategori();
        final jsonItems =
            json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

        usersList = jsonItems.map<Kategori>((json) {
          //dbHelper.insertkategori(Kategori.fromJson(json));
          return Kategori.fromJson(json);
        }).toList();

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

  Future<List<Subkategori>> fetchSubKategori(String idkategori) async {
    List<Subkategori> usersList = [];
    var params = "/subkategoribyproduk?id=" + idkategori;
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      var jsonResponse = await http.get(sUrl);
      if (jsonResponse.statusCode == 200) {
        final jsonItems =
            json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

        usersList = jsonItems.map<Subkategori>((json) {
          return Subkategori.fromJson(json);
        }).toList();

        setState(() {
          subkategorilist = usersList;
        });
      }
    } catch (e) {
      getsubkategori(int.parse(idkategori));
      usersList = subkategorilist;
    }
    return usersList;
  }

  getsubkategori(int idkategori) async {
    // final Future<Database> dbFuture = dbHelper.initDb();
    // dbFuture.then((database) {
    //   Future<List<Subkategori>> listFuture =
    //       dbHelper.getsubkategori(idkategori);
    //   listFuture.then((_subkategorilist) {
    //     if (mounted) {
    //       setState(() {
    //         subkategorilist = _subkategorilist;
    //       });
    //     }
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(children: <Widget>[
        Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Palette.menuOther,
                width: 1.0,
              ),
            ),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(color: Colors.white, spreadRadius: 1),
            ],
          ),
          child: const Text(
            'KATEGORI PRODUK',
            style: TextStyle(color: Colors.black),
          ),
        ),
        Expanded(
          child: li == 1 ? _widgetKategori() : _widgetSubKategori(),
        )
      ]),
    );
  }

  Widget _widgetKategori() {
    return FutureBuilder<List<Kategori>>(
      future: fetchKategori(),
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
          itemCount: snapshot.data!.length,
          itemBuilder: (context, i) {
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Palette.menuOther,
                    width: 1.0,
                  ),
                ),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(color: Colors.white, spreadRadius: 1),
                ],
              ),
              child: ListTile(
                dense: true,
                contentPadding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
                leading: const Icon(Icons.group_work),
                trailing: const Icon(Icons.keyboard_arrow_right),
                title: Text(snapshot.data![i].nama),
                onTap: () {
                  fetchSubKategori(snapshot.data![i].id.toString());
                  setState(() {
                    subkategorilist = [];
                    idkategori = snapshot.data![i].id;
                    namakategori = snapshot.data![i].nama;
                    li = 2;
                  });
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _widgetSubKategori() {
    return Column(children: <Widget>[
      Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Palette.menuOther,
              width: 1.0,
            ),
          ),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.white, spreadRadius: 1),
          ],
        ),
        child: ListTile(
          dense: true,
          contentPadding: const EdgeInsets.only(
              left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
          leading: const Icon(Icons.keyboard_arrow_left),
          title: Text(namakategori),
          onTap: () {
            setState(() {
              li = 1;
            });
          },
        ),
      ),
      Container(
        color: Colors.white,
        child: ListTile(
          dense: true,
          contentPadding: const EdgeInsets.only(
              left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
          leading: const Text(''),
          title: Text("Lihat semua " + namakategori,
              style: const TextStyle(color: Colors.blue)),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return ProdukPage("kat", idkategori, 0, namakategori);
            }));
          },
        ),
      ),
      Expanded(
          child: ListView.builder(
        itemCount: subkategorilist.length,
        itemBuilder: (context, i) {
          return Container(
              color: Colors.white,
              child: ListTile(
                dense: true,
                contentPadding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
                leading: const Text(''),
                trailing: const Icon(Icons.keyboard_arrow_right),
                title: Text(subkategorilist[i].nama),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return ProdukPage("sub", idkategori, subkategorilist[i].id,
                        subkategorilist[i].nama);
                  }));
                },
              ));
        },
      )),
    ]);
  }
}
