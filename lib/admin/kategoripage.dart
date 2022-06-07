import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import '../constans.dart';
import '../helper/dbhelper.dart';

import '../models/kategori.dart';
import '../models/subkategori.dart';

class KategoriPage extends StatefulWidget {
  final Widget? child;
  const KategoriPage({Key? key, this.child}) : super(key: key);

  @override
  _KategoriPageState createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  DbHelper dbHelper = DbHelper();
  Future<List<Kategori>>? listkategori;
  List<Kategori> kategorilist = [];
  List<Subkategori> subkategorilist = [];
  int idkategori = 0;
  int idsubkategori = 0;
  String namakategori = "";
  double ukuranfont = 14.0;
  int li = 1;
  final TextEditingController txtkategori = TextEditingController();

  @override
  void initState() {
    super.initState();
    listkategori = fetchKategori();
  }

  Future<List<Kategori>> fetchKategori() async {
    List<Kategori> usersList=[];
    var params = "/kategori";
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      var jsonResponse = await http.get(sUrl );
      if (jsonResponse.statusCode == 200) {
        // dbHelper.deletekategori();
        final jsonItems =
            json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

        usersList = jsonItems.map<Kategori>((json) {
          // dbHelper.insertkategori(Kategori.fromJson(json));
          return Kategori.fromJson(json);
        }).toList();

        setState(() {
          kategorilist = usersList;
        });
      }
    } catch (e) {
      // getkategori();
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
    List<Subkategori> usersList=[];
    var params = "/subkategoribykategori?idkategori=" + idkategori;
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      var jsonResponse = await http.get(sUrl );
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
      // getsubkategori(int.parse(idkategori));
      // usersList = subkategorilist;
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            txtkategori.text = "";
          });
          if (li == 1) {
            _frmKategori(context);
          } else {
            _frmSubKategori(context);
          }
        },
        tooltip: 'Tambah',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _frmKategori(BuildContext main) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  const Text("Tambah Kategori"),
          content: TextField(
            controller: txtkategori,
            keyboardType: TextInputType.text,
            style: const TextStyle(fontSize: 16),
            enabled: true,
            decoration: InputDecoration(
                hintText: 'Nama Kategori',
                contentPadding:
                    const EdgeInsets.only(top: 10, left: 12.0, bottom: 10),
                border:  const OutlineInputBorder(
                  borderRadius:   BorderRadius.all(
                     Radius.circular(5.0),
                  ),
                  borderSide:   BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                fillColor: Colors.grey[200],
                filled: false),
          ),
          actions: <Widget>[
             ElevatedButton(
              child: const  Text("Simpan"),
              onPressed: () {
                _saveKategori(context, {"nama": txtkategori.text.trim()});
              },
            ),
          ],
        );
      },
    );
  }

  void _frmSubKategori(BuildContext main) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:   Text("Tambah Sub Kategori " + namakategori),
          content: TextField(
            controller: txtkategori,
            keyboardType: TextInputType.text,
            style: const TextStyle(fontSize: 16),
            enabled: true,
            decoration: InputDecoration(
                hintText: 'Nama Sub Kategori',
                contentPadding:
                    const EdgeInsets.only(top: 10, left: 12.0, bottom: 10),
                border:  const OutlineInputBorder(
                  borderRadius:  BorderRadius.all(
                     Radius.circular(5.0),
                  ),
                  borderSide:  BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                fillColor: Colors.grey[200],
                filled: false),
          ),
          actions: <Widget>[
             ElevatedButton(
              child:  const Text("Simpan"),
              onPressed: () {
                _saveSubKategori(context, {
                  "nama": txtkategori.text.trim(),
                  "idkategori": idkategori.toString()
                });
              },
            ),
          ],
        );
      },
    );
  }

  loadingProses(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child:  CircularProgressIndicator(),
          );
        });
  }

  Future<dynamic> _saveKategori(context, Map data) async {
    loadingProses(context);
    var params = "/postkategori";
      var sUrl = Uri.parse(Palette.sUrl + params);
      try {
        http.post(sUrl, body: data).then((response) {
        var res = response.body.toString();
        if (res == "OK") {
          setState(() {
            listkategori = fetchKategori();
          });
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
      });
    } catch (e) {return null;}
  }

  Future<dynamic> _saveSubKategori(context, Map data) async {
    loadingProses(context);
    var params = "/postsubkategori";
      var sUrl = Uri.parse(Palette.sUrl + params);
      try {
        http.post(sUrl, body: data).then((response) {
        var res = response.body.toString();
        if (res == "OK") {
          fetchSubKategori(idkategori.toString());
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
      });
    } catch (e) {return null;}
  }

  Widget _widgetKategori() {
    return FutureBuilder<List<Kategori>>(
      future: listkategori,
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
                leading: const Icon(Icons.menu),
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

  _hapusKategori(int id) async {
    var params = "/hapuskategori?id=" + id.toString();
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      http.get(sUrl ).then((response) {
        var res = response.body.toString();
        if (res == "OK") {
          setState(() {
            li = 1;
            listkategori = fetchKategori();
          });
        }
      });
    } catch (e) {return null;}
  }

  _hapusSubKategori(int idkategori, int id) async {
    var params = "/hapussubkategori?id=" + id.toString();
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      http.get(sUrl ).then((response) {
        var res = response.body.toString();
        if (res == "OK") {
          fetchSubKategori(idkategori.toString());
        }
      });
    } catch (e) {debugPrint("");}
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
          contentPadding:
              const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
          leading: InkWell(
            onTap: () {
              setState(() {
                li = 1;
              });
            },
            child: const Icon(Icons.keyboard_arrow_left),
          ),
          trailing: InkWell(
            onTap: () {
              _hapusKategori(idkategori);
            },
            child: const Icon(
              Icons.clear,
              color: Colors.red,
            ),
          ),
          title: InkWell(
            onTap: () {
              // edit(idkategori);
            },
            child: Text(namakategori),
          ),

          // onTap: () {
          //   setState(() {
          //     li = 1;
          //   });
          // },
        ),
      ),
      // Container(
      //   color: Colors.white,
      //   child: ListTile(
      //     dense: true,
      //     contentPadding:
      //         EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
      //     leading: Text(''),
      //     title: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         InkWell(
      //           onTap: () {
      //             // _hapusKategori(idkategori);
      //           },
      //           child: Text("Edit ", style: TextStyle(color: Colors.blue)),
      //         ),
      //         InkWell(
      //           onTap: () {
      //             _hapusKategori(idkategori);
      //           },
      //           child: Text("Hapus ", style: TextStyle(color: Colors.red)),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      // Container(
      //   color: Colors.white,
      //   child: ListTile(
      //     dense: true,
      //     contentPadding:
      //         EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
      //     leading: Text(''),
      //     title: Text("Hapus " + namakategori,
      //         style: TextStyle(color: Colors.red)),
      //     onTap: () {
      //       _hapusKategori(idkategori);
      //     },
      //   ),
      // ),
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
                trailing: InkWell(
                  onTap: () {
                    _hapusSubKategori(idkategori, subkategorilist[i].id);
                  },
                  child: const Icon(
                    Icons.clear,
                    color: Colors.red,
                  ),
                ),
                title: InkWell(
                  onTap: () {
                    // edit(idkategori);
                  },
                  child: Text(subkategorilist[i].nama),
                ),
              ));
        },
      )),
    ]);
  }
}
