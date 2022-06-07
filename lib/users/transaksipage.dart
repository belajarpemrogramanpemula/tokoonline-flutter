import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constans.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../helper/dbhelper.dart';
import '../models/transaksi.dart';
import '../models/transaksidetail.dart';

// ignore: use_key_in_widget_constructors
class TransaksiPage extends StatefulWidget {
  @override
  _TransaksiPageState createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  DbHelper dbHelper = DbHelper();
  bool login = false;
  String userid = "";
  Future<List<Transaksi>>? transaksilist;
  Future<List<Transaksidetail>>? transaksidetaillist;

  String nota = "";
  String tanggal = "";
  String nama = "";
  String total = "";
  String cabang = "";
  String telp = "";
  String email = "";
  String flag = "";
  double fontnormal = 12.0;
  double fontkecil = 10.0;
  int li = 1;

  @override
  void initState() {
    super.initState();
    cekLogin();
  }

  cekLogin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      login = prefs.getBool('login') ?? false;
      userid = prefs.getString('username') ?? "";
      transaksilist = fetchTransaksi();
    });
  }

  Future<List<Transaksi>> fetchTransaksi() async {
    List<Transaksi> usersList = [];
    var params = "/transaksibyuserid?userid=" + userid;
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      var jsonResponse = await http.get(sUrl);
      if (jsonResponse.statusCode == 200) {
        final jsonItems =
            json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

        usersList = jsonItems.map<Transaksi>((json) {
          return Transaksi.fromJson(json);
        }).toList();
      }
    // ignore: empty_catches
    } catch (e) {}
    return usersList;
  }

  Future<List<Transaksidetail>> fetchTransaksiDetail(String nota) async {
    List<Transaksidetail> usersList = [];
    var params = "/transaksibynota?nota=" + nota;
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      var jsonResponse = await http.get(sUrl);
      if (jsonResponse.statusCode == 200) {
        final jsonItems =
            json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

        usersList = jsonItems.map<Transaksidetail>((json) {
          return Transaksidetail.fromJson(json);
        }).toList();
      }
    // ignore: empty_catches
    } catch (e) {}
    return usersList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi', style: TextStyle(color: Colors.white)),
        backgroundColor: Palette.bg1,
      ),
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
          child: InkWell(
            onTap: () {
              setState(() {
                li = 1;
              });
            },
            child: const Text(
              'Semua Transaksi',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        Expanded(
          child: li == 1 ? _widgetTransaksi() : _widgetDetail(),
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

  Widget _widgetTransaksi() {
    return FutureBuilder<List<Transaksi>>(
      future: transaksilist,
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
                leading: const Icon(Icons.local_mall),
                trailing: const Icon(Icons.keyboard_arrow_right),
                title: Text(snapshot.data![i].nota),
                subtitle: Stack(
                  children: [
                    Text(snapshot.data![i].tanggal +
                        '\n' +
                        snapshot.data![i].keterangan +
                        ' (' +
                        snapshot.data![i].subtotalrp +
                        ')'),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: snapshot.data![i].flag == ""
                          ? const Text('')
                          : Container(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 5, top: 2, bottom: 2),
                              decoration: BoxDecoration(
                                color: snapshot.data![i].flag == "proses"
                                    ? Colors.blue
                                    : snapshot.data![i].flag == "di antar"
                                        ? Colors.teal
                                        : snapshot.data![i].flag == "selesai"
                                            ? Colors.green
                                            : snapshot.data![i].flag == "cancel"
                                                ? Colors.red
                                                : Colors.blue,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Row(
                                children: [
                                  // Icon(
                                  //   Icons.notifications,
                                  //   size: 15.0,
                                  //   color: Colors.white,
                                  // ),
                                  Text(
                                    snapshot.data![i].flag,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    transaksidetaillist =
                        fetchTransaksiDetail(snapshot.data![i].nota);
                    nota = snapshot.data![i].nota;
                    nama = snapshot.data![i].nama;
                    tanggal = snapshot.data![i].tanggal;
                    total = snapshot.data![i].subtotalrp;
                    cabang = snapshot.data![i].cabang;
                    telp = snapshot.data![i].telpcabang;
                    email = snapshot.data![i].emailcabang;
                    flag = snapshot.data![i].flag;
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
    double _width = MediaQuery.of(context).size.width;
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
          title: Stack(
            children: [
              Text('Nota : ' +
                  nota +
                  ' \nTanggal : ' +
                  tanggal +
                  ', Total : ' +
                  total +
                  ' \n' +
                  cabang),
              Positioned(
                top: 0,
                right: 0,
                child: flag == ""
                    ? const Text('')
                    : Container(
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 2, bottom: 2),
                        decoration: BoxDecoration(
                          color: flag == "proses"
                              ? Colors.blue
                              : flag == "di antar"
                                  ? Colors.teal
                                  : flag == "selesai"
                                      ? Colors.green
                                      : flag == "cancel"
                                          ? Colors.red
                                          : Colors.blue,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Row(
                          children: [
                            // Icon(
                            //   Icons.notifications,
                            //   size: 15.0,
                            //   color: Colors.white,
                            // ),
                            Text(
                              flag,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
          onTap: () {
            setState(() {
              li = 1;
            });
          },
        ),
      ),
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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        launch('tel://' + telp);
                      },
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.phone),
                          Text(
                            ' ' + telp,
                            style: _width <= 360
                                ? TextStyle(fontSize: fontkecil)
                                : TextStyle(fontSize: fontnormal),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        launch('mailto:' +
                            email +
                            '?subject=Transaksi No.' +
                            nota +
                            '&body=Atas Nama : ' +
                            nama +
                            '\nTotal : ' +
                            total +
                            '\nTelah melakukan pembayaran');
                      },
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.email),
                          Text(
                            ' ' + email,
                            style: _width <= 360
                                ? TextStyle(fontSize: fontkecil)
                                : TextStyle(fontSize: fontnormal),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
      Expanded(
        child: FutureBuilder<List<Transaksidetail>>(
          future: transaksidetaillist,
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
                    leading: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Image.network(
                          Palette.sUrl + snapshot.data![i].thumbnail,
                          fit: BoxFit.fill),
                    ),
                    title: Text(snapshot.data![i].judul),
                    subtitle: Text(snapshot.data![i].hargax +
                        ' x ' +
                        snapshot.data![i].jumlah +
                        ' = ' +
                        snapshot.data![i].subtotalrp),
                    onTap: () {
                      setState(() {
                        nota = snapshot.data![i].nota;
                        li = 2;
                      });
                    },
                  ),
                );
              },
            );
          },
        ),
      ),

      // Container(
      //   decoration: BoxDecoration(
      //     border: Border(
      //       bottom: BorderSide(
      //         color: Palette.menuOther,
      //         width: 1.0,
      //       ),
      //     ),
      //     color: Colors.white,
      //     boxShadow: [
      //       BoxShadow(color: Colors.white, spreadRadius: 1),
      //     ],
      //   ),
      //   child: ListTile(
      //     dense: true,
      //     contentPadding:
      //         EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
      //     leading: Icon(Icons.keyboard_arrow_left),
      //     title: Text('Nota : '+nota+' \nTanggal : '+tanggal+' | '+total),
      //     onTap: () {
      //       setState(() {
      //         li = 1;
      //       });
      //     },
      //   ),
      // ),
    ]);
  }
}
