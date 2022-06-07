import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import '../constans.dart';
import '../models/pelanggan.dart';

class PelangganPage extends StatefulWidget {
  final Widget? child;
  const PelangganPage({Key? key, this.child}) : super(key: key);

  @override
  _PelangganPageState createState() => _PelangganPageState();
}

class _PelangganPageState extends State<PelangganPage> {
  Future<List<Pelanggan>>? pelangganlist;
  int idpelanggan = 0;
  String namaPelanggan = "";
  String alamatPelanggan = "";
  String kotaPelanggan = "";
  String propinsiPelanggan = "";
  String kodeposPelanggan = "";
  String telpPelanggan = "";
  String emailPelanggan = "";
  double ukuranfont = 14.0;
  int li = 1;

  @override
  void initState() {
    super.initState();
    pelangganlist = fetchPelanggan();
  }

  Future<List<Pelanggan>> fetchPelanggan() async {
    List<Pelanggan> usersList = [];
    var params = "/pelanggan";
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      var jsonResponse = await http.get(sUrl);
      if (jsonResponse.statusCode == 200) {
        final jsonItems =
            json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

        usersList = jsonItems.map<Pelanggan>((json) {
          return Pelanggan.fromJson(json);
        }).toList();
      }
    // ignore: empty_catches
    } catch (e) {}
    return usersList;
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
            'Pelanggan / Customer',
            style: TextStyle(color: Colors.black),
          ),
        ),
        Expanded(
          child: li == 1 ? _widgetPelanggan() : _widgetDetail(),
        )
      ]),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //   },
      //   tooltip: 'Tambah',
      //   child: Icon(Icons.add),
      // ),
    );
  }

  _hapusPelanggan(int id) async {
    var params = "/hapuspelanggan?id=" + id.toString();
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      http.get(sUrl).then((response) {
        var res = response.body.toString();
        if (res == "OK") {
          setState(() {
            li = 1;
            pelangganlist = fetchPelanggan();
          });
        }
      });
    } catch (e) {return null;}
  }

  Widget _widgetPelanggan() {
    return FutureBuilder<List<Pelanggan>>(
      future: pelangganlist,
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
                leading: const Icon(Icons.account_box),
                trailing: const Icon(Icons.keyboard_arrow_right),
                title: Text(snapshot.data![i].nama),
                subtitle: Text(snapshot.data![i].alamat +
                    '\n' +
                    snapshot.data![i].telp +
                    '\n' +
                    snapshot.data![i].email),
                onTap: () {
                  setState(() {
                    idpelanggan = snapshot.data![i].id;
                    namaPelanggan = snapshot.data![i].nama;
                    alamatPelanggan = snapshot.data![i].alamat;
                    kotaPelanggan = snapshot.data![i].kota;
                    propinsiPelanggan = snapshot.data![i].propinsi;
                    kodeposPelanggan = snapshot.data![i].kodepos;
                    telpPelanggan = snapshot.data![i].telp;
                    emailPelanggan = snapshot.data![i].email;
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

  Widget _widgetDetail() {
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
              _hapusPelanggan(idpelanggan);
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
            child: Text(namaPelanggan),
          ),
          // leading: Icon(Icons.keyboard_arrow_left),
          // title: Text(namaPelanggan),
          // onTap: () {
          //   setState(() {
          //     li = 1;
          //   });
          // },
        ),
      ),
      Expanded(
        child: Column(children: <Widget>[
          Container(
            color: Colors.white,
            child: ListTile(
              dense: true,
              contentPadding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
              leading: const Text(''),
              // ignore: avoid_unnecessary_containers
              title: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ignore: avoid_unnecessary_containers
                    const SizedBox(
                      width: 100.0,
                      child:  Text('Nama'),
                    ),
                    Expanded(
                      child: Text(': ' + namaPelanggan),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              dense: true,
              contentPadding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
              leading: const Text(''),
              // ignore: avoid_unnecessary_containers
              title: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ignore: avoid_unnecessary_containers
                    const SizedBox(
                      width: 100.0,
                      child:  Text('Alamat'),
                    ),
                    Expanded(
                      child: Text(': ' + alamatPelanggan),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              dense: true,
              contentPadding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
              leading: const Text(''),
              // ignore: avoid_unnecessary_containers
              title: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ignore: avoid_unnecessary_containers
                    const SizedBox(
                      width: 100.0,
                      child:  Text('Kota'),
                    ),
                    Expanded(
                      child: Text(': ' + kotaPelanggan),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              dense: true,
              contentPadding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
              leading: const Text(''),
              // ignore: avoid_unnecessary_containers
              title: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ignore: avoid_unnecessary_containers
                    const SizedBox(
                      width: 100.0,
                      child:  Text('Propinsi'),
                    ),
                    Expanded(
                      child: Text(': ' + propinsiPelanggan),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              dense: true,
              contentPadding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
              leading: const Text(''),
              // ignore: avoid_unnecessary_containers
              title: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ignore: avoid_unnecessary_containers
                    const SizedBox(
                      width: 100.0,
                      child:  Text('Telp'),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SelectableText(': ' + telpPelanggan + ' '),
                          InkWell(
                            onTap: () {
                              launch('tel://' + telpPelanggan);
                            },
                            child: const Icon(Icons.phone),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              dense: true,
              contentPadding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
              leading: const Text(''),
              // ignore: avoid_unnecessary_containers
              title: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ignore: avoid_unnecessary_containers
                    const SizedBox(
                      width: 100.0,
                      child:  Text('Email'),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SelectableText(': ' + emailPelanggan + ' '),
                          InkWell(
                            onTap: () {
                              launch('mailto:' + emailPelanggan);
                            },
                            child: const Icon(Icons.email),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Container(
          //   color: Colors.white,
          //   child: ListTile(
          //     dense: true,
          //     contentPadding: EdgeInsets.only(
          //         left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
          //     leading: Text(''),
          //     title: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         InkWell(
          //           onTap: () {
          //             // _hapusPelanggan(idpelanggan);
          //           },
          //           child: Text("Edit ", style: TextStyle(color: Colors.blue)),
          //         ),
          //         InkWell(
          //           onTap: () {
          //             _hapusPelanggan(idpelanggan);
          //           },
          //           child: Text("Hapus ", style: TextStyle(color: Colors.red)),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ]),
      ),
    ]);
  }
}
