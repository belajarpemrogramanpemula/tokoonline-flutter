import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constans.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../helper/dbhelper.dart';
import 'package:sqflite/sqflite.dart';
import '../login.dart';
import '../models/keranjang.dart';
import 'notifikasipage.dart';

// ignore: use_key_in_widget_constructors
class KeranjangPage extends StatefulWidget {
  @override
  _KeranjangPageState createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  DbHelper dbHelper = DbHelper();
  List<Keranjang> keranjanglist = [];
  int _subTotal = 0;
  bool login = false;
  String userid = "";
  int jmlnotif = 0;

  @override
  void initState() {
    super.initState();
    getkeranjang();
    cekLogin();
  }

  cekLogin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      login = prefs.getBool('login') ?? false;
      userid = prefs.getString('username') ?? "";
    });
    _cekSt();
  }

  _cekSt() async {
    if (userid == "") {
    } else {
      var params = "/cekstbyuserid?userid=" + userid;
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

  Future<List<Keranjang>> getkeranjang() async {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<Keranjang>> listFuture = dbHelper.getkeranjang();
      listFuture.then((_keranjanglist) {
        if (mounted) {
          setState(() {
            keranjanglist = _keranjanglist;
          });
        }
      });
    });
    int subtotal = 0;
    for (int i = 0; i < keranjanglist.length; i++) {
      if (keranjanglist[i].hargax.trim() != "0") {
        subtotal +=
            keranjanglist[i].jumlah * int.parse(keranjanglist[i].hargax.trim());
      }
      // if (keranjanglist[i].harga.trim() != "Rp.") {
      //   subtotal += keranjanglist[i].jumlah *
      //       int.parse(keranjanglist[i]
      //           .harga
      //           .replaceAll('Rp.', '')
      //           .replaceAll('.', '')
      //           .trim());
      // }
    }
    setState(() {
      _subTotal = subtotal;
    });
    return keranjanglist;
  }

  _tambahJmlKeranjang(int id) async {
    Database db = await dbHelper.database;
    var batch = db.batch();
    db.execute('update keranjang set jumlah=jumlah+1 where id=?', [id]);
    await batch.commit();
  }

  _kurangJmlKeranjang(int id) async {
    Database db = await dbHelper.database;
    var batch = db.batch();
    db.execute('update keranjang set jumlah=jumlah-1 where id=?', [id]);
    await batch.commit();
  }

  _deleteKeranjang(int id) async {
    Database db = await dbHelper.database;
    var batch = db.batch();
    db.execute('delete from keranjang where id=?', [id]);
    await batch.commit();
  }

  _kosongkanKeranjang() async {
    Database db = await dbHelper.database;
    var batch = db.batch();
    db.execute('delete from keranjang');
    await batch.commit();
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

  _klikCekout(List<Keranjang> _keranjang) async {
    loadingProses(context);
    var params = "/klikbayar";
    var sUrl = Uri.parse(Palette.sUrl + params);
    var body = {"listkeranjang": json.encode(_keranjang)};
    try {
      http.post(sUrl, body: body).then((response) {
        var res = response.body.toString();
        debugPrint(res);
        
        if (res == "OK") {
          Navigator.of(context).pop();
          _kosongkanKeranjang();
          // Navigator.of(context).pushNamedAndRemoveUntil(
          //     '/terimakasih', (Route<dynamic> route) => false);
        }
      });
      // ignore: empty_catches
    } catch (e) {}
    return params;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text('Keranjang', style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          Row(
            children: [
              login == false
                  ? const Text('')
                  : Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) {
                            return const NotifikasiPage();
                          }));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 5),
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
          ),
        ],
        actionsIconTheme:
            const IconThemeData(size: 26.0, color: Colors.white, opacity: 10.0),
        backgroundColor: Palette.bg1,
      ),
      body: keranjanglist.isEmpty ? _keranjangKosong() : _widgetKeranjang(),
      bottomNavigationBar: Visibility(
        visible: keranjanglist.isEmpty ? false : true,
        child: BottomAppBar(
          color: Colors.transparent,
          child: Container(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total', style: TextStyle(fontSize: 14.0)),
                        Text(
                            'Rp. ' +
                                NumberFormat.currency(
                                        locale: 'ID',
                                        symbol: "",
                                        decimalDigits: 0)
                                    .format(_subTotal)
                                    .toString(),
                            style: const TextStyle(
                                color: Colors.red, fontSize: 18.0)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      login
                          ? _klikCekout(keranjanglist)
                          : Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) {
                              return const Login('');
                            }));
                    },
                    child: Container(
                      height: 40.0,
                      child: const Center(
                        child: Text('Cek Out',
                            style: TextStyle(color: Colors.white)),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const [
                          BoxShadow(color: Colors.blue, spreadRadius: 1),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            height: 70.0,
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
      ),
    );
  }

  Widget _keranjangKosong() {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 1)),
      builder: (c, s) => s.connectionState == ConnectionState.done
          ? keranjanglist.isEmpty
              ? SafeArea(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Center(
                            child: Container(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'Keranjang Kosong',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );

    // SafeArea(
    //   child: new Container(
    //     color: Colors.white,
    //     child: Column(
    //       children: <Widget>[
    //         Expanded(
    //           child: Center(
    //             child: Container(
    //                 padding: EdgeInsets.only(left: 25.0, right: 25.0),
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   children: [
    //                     Text(
    //                       'Keranjang Kosong',
    //                       style: TextStyle(fontSize: 18),
    //                     ),
    //                   ],
    //                 )),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget _widgetKeranjang() {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<Keranjang>>(
                future: getkeranjang(),
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

                  // if (snapshot.hasData) {
                  //   snapshot.data!.forEach((element) {
                  //     setState(() {
                  //       _subTotal = _subTotal + element.jumlah;
                  //     });
                  //   });
                  // }
                  // total() {
                  //   num subTotal = 0;

                  //   for (int i = 0; i < snapshot.data!.length; i++) {
                  //     subTotal += snapshot.data![i].jumlah;
                  //   }
                  //   setState(() {
                  //     _subTotal = subTotal;
                  //   });
                  // }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, i) {
                      // num subTotal = 0;

                      // for (int i = 0; i < snapshot.data!.length; i++) {
                      //   subTotal += snapshot.data![i].jumlah;
                      // }
                      // setState(() {
                      //   _subTotal=subTotal;
                      // });
                      return Container(
                        height: 110.0,
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
                              left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                          // ignore: avoid_unnecessary_containers
                          title: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Image.network(
                                  Palette.sUrl + snapshot.data![i].thumbnail,
                                  height: 110.0,
                                  width: 110.0,
                                ),
                                Expanded(
                                  // ignore: avoid_unnecessary_containers
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(snapshot.data![i].judul,
                                            style: const TextStyle(
                                                fontSize: 16.0)),
                                        Text(snapshot.data![i].harga,
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 14.0)),
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              height: 30,
                                              width: 100,
                                              margin: const EdgeInsets.only(
                                                  top: 10.0),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  border: Border.all(
                                                      color: Colors.grey)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      if (snapshot
                                                              .data![i].jumlah >
                                                          1) {
                                                        _kurangJmlKeranjang(
                                                            snapshot
                                                                .data![i].id!);
                                                      }
                                                    },
                                                    child: const Icon(
                                                      Icons.remove,
                                                      color: Colors.green,
                                                      size: 22,
                                                    ),
                                                  ),
                                                  Text(
                                                    snapshot.data![i].jumlah
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.0),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      _tambahJmlKeranjang(
                                                          snapshot
                                                              .data![i].id!);
                                                    },
                                                    child: const Icon(
                                                      Icons.add,
                                                      color: Colors.green,
                                                      size: 22,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    top: 10.0),
                                                padding: const EdgeInsets.only(
                                                    right: 10.0,
                                                    top: 7.0,
                                                    bottom: 5.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: InkWell(
                                                    onTap: () {
                                                      _deleteKeranjang(snapshot
                                                          .data![i].id!);
                                                    },
                                                    child: Container(
                                                      height: 25,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2),
                                                        border: Border.all(
                                                            color: Colors.red),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                              color: Colors.red,
                                                              spreadRadius: 1),
                                                        ],
                                                      ),
                                                      child: const Icon(
                                                        Icons.delete,
                                                        color: Colors.white,
                                                        size: 22,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {},
                        ),
                      );
                    },
                  );
                  // return ListView.builder(
                  //   scrollDirection: Axis.vertical,
                  //   itemCount: snapshot.data!.length,
                  //   itemBuilder: (BuildContext context, int i) => Card(
                  //     child: InkWell(
                  //       // onTap: () {
                  //       //   Navigator.of(context).push(
                  //       //       MaterialPageRoute<Null>(builder: (BuildContext context) {
                  //       //     return new ProdukDetailPage(
                  //       //         snapshot.data![i].id,
                  //       //         snapshot.data![i].judul,
                  //       //         snapshot.data![i].harga,
                  //       //         snapshot.data![i].thumbnail);
                  //       //   }));
                  //       // },
                  //       child: Container(
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           children: <Widget>[
                  //             new Image.network(
                  //               Palette.sUrl + snapshot.data![i].thumbnail,
                  //               height: 110.0,
                  //               width: 110.0,
                  //             ),
                  //             Column(
                  //               mainAxisAlignment: MainAxisAlignment.start,
                  //               children: <Widget>[
                  //                 Padding(
                  //                   padding: EdgeInsets.only(left: 5.0),
                  //                   child: Text(snapshot.data![i].judul),
                  //                 ),
                  //                 Padding(
                  //                   padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  //                   child: Text(snapshot.data![i].harga),
                  //                 ),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
