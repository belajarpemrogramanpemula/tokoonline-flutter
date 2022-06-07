import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../constans.dart';
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
  String total = "";
  String nama = "";
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
    List<Transaksi> usersList=[];
    var params = "/transaksibycabang?userid=" + userid;
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
    List<Transaksidetail> usersList=[];
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

  _updateSt(String nota) async {
    var params = "/updatest?nota=" + nota;
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      http.get(sUrl).then((response) {
        var res = response.body.toString();
        if (res == "OK") {
          if (mounted) {
            setState(() {
              transaksilist = fetchTransaksi();
            });
          }
        }
      });
    // ignore: empty_catches
    } catch (e) {}
  }

  _updateFlag(String nota, String st) async {
    loadingProses(context);
    var params = "/updateflag?nota=" + nota + "&flag=" + st;
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      http.get(sUrl).then((response) {
        var res = response.body.toString();
        Navigator.of(context).pop();
        if (res == "OK") {
          if (mounted) {
            setState(() {
              flag = st;
              transaksilist = fetchTransaksi();
            });
          }
        }
      });
    // ignore: empty_catches
    } catch (e) {}
  }

  loadingProses(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
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
                color: snapshot.data![i].st == "1"
                    ? Colors.white
                    : Colors.yellow[50],
                boxShadow:const  [
                  BoxShadow(color: Colors.white, spreadRadius: 1),
                ],
              ),
              child: ListTile(
                dense: true,
                contentPadding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
                leading: const Icon(Icons.local_mall),
                trailing: const Icon(Icons.keyboard_arrow_right),
                title: Text(snapshot.data![i].nama),
                subtitle: Stack(
                  children: [
                    Text(snapshot.data![i].nota +
                        ', Tanggal : ' +
                        snapshot.data![i].tanggal +
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
                  _updateSt(snapshot.data![i].nota);
                  setState(() {
                    transaksidetaillist =
                        fetchTransaksiDetail(snapshot.data![i].nota);
                    nota = snapshot.data![i].nota;
                    tanggal = snapshot.data![i].tanggal;
                    total = snapshot.data![i].subtotalrp;
                    nama = snapshot.data![i].nama;
                    telp = snapshot.data![i].telp;
                    email = snapshot.data![i].email;
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
          contentPadding:
              const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
          title: Stack(
            children: [
              Text(nama +
                  '\nNota : ' +
                  nota +
                  '\nTanggal : ' +
                  tanggal +
                  ', Total : ' +
                  total),
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
                              'status ' + flag,
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
            contentPadding:
                const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
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
                            '\nSilahkan segera melakukan pembayaran');
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
      Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Palette.menuOther,
              width: 1.0,
            ),
          ),
          color: Colors.white,
          boxShadow:const  [
            BoxShadow(color: Colors.white, spreadRadius: 1),
          ],
        ),
        child: ListTile(
            dense: true,
            contentPadding:
                const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin:const  EdgeInsets.only(right: 10),
                      padding:
                          const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: InkWell(
                        onTap: () {
                          _updateFlag(nota, 'cancel');
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.adjust,
                              size: 15.0,
                              color: Colors.white,
                            ),
                            Text(
                              _width <= 360 ? 'di cancel' :'klik cancel',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding:
                          const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: InkWell(
                        onTap: () {
                          _updateFlag(nota, 'proses');
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.adjust,
                              size: 15.0,
                              color: Colors.white,
                            ),
                            Text(
                              _width <= 360 ? 'proses' :'klik proses',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding:
                          const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: InkWell(
                        onTap: () {
                          _updateFlag(nota, 'di antar');
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.adjust,
                              size: 15.0,
                              color: Colors.white,
                            ),
                            Text(
                              _width <= 360 ? 'di antar' :'klik di antar',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding:const  EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: InkWell(
                        onTap: () {
                          _updateFlag(nota, 'selesai');
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.adjust,
                              size: 15.0,
                              color: Colors.white,
                            ),
                            Text(
                              _width <= 360 ? 'di selesai' :'klik selesai',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
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
                    boxShadow:const  [
                      BoxShadow(color: Colors.white, spreadRadius: 1),
                    ],
                  ),
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
                    leading: AspectRatio(
                      aspectRatio: 1 / 1,
                      child:  Image.network(
                          Palette.sUrl + snapshot.data![i].thumbnail,
                          fit: BoxFit.fill),
                    ),
                    title: SelectableText(snapshot.data![i].judul),
                    subtitle: SelectableText(snapshot.data![i].hargax +
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
    ]);
  }
}
