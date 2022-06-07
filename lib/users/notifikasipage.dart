import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constans.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../helper/dbhelper.dart';
import '../models/notifikasi.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({ Key? key }) : super(key: key);

  @override
  _NotifikasiPageState createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  DbHelper dbHelper = DbHelper();
  bool login = false;
  String username = "";
  Future<List<Notifikasi>>? notifikasilist;

  String nota = "";
  String tanggal = "";
  String nama = "";
  String total = "";
  String cabang = "";
  String telp = "";
  String email = "";
  String flag = "";
  String st = "";
  double ukuranfont = 14.0;
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
      username = prefs.getString('username') ?? "";
      notifikasilist = fetchNotifikasi();
    });
  }

  Future<List<Notifikasi>> fetchNotifikasi() async {
    List<Notifikasi> usersList=[];
    var params = "/notifikasibyuserid?userid=" + username;
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      var jsonResponse = await http.get(sUrl);
      if (jsonResponse.statusCode == 200) {
        final jsonItems =
            json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

        usersList = jsonItems.map<Notifikasi>((json) {
          return Notifikasi.fromJson(json);
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
        iconTheme:const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title:const Text('Notifikasi', style: TextStyle(color: Colors.white)),
        backgroundColor: Palette.bg1,
      ),
      backgroundColor: Colors.grey[100],
      body: Column(children: <Widget>[
        const SizedBox(height: 10.0),
        Expanded(
          child: li == 1 ? _widgetNotifikasi() : _widgetDetail(),
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

  Widget _widgetNotifikasi() {
    return FutureBuilder<List<Notifikasi>>(
      future: notifikasilist,
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
                boxShadow:const [
                  BoxShadow(color: Colors.white, spreadRadius: 1),
                ],
              ),
              child: ListTile(
                dense: true,
                contentPadding:const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
                trailing: const Icon(Icons.keyboard_arrow_right),
                title: Text(snapshot.data![i].tanggal),
                subtitle: Text(snapshot.data![i].judul +
                    '\n' +
                    snapshot.data![i].keterangan +
                    '\nstatus ' +
                    snapshot.data![i].flag),
                onTap: () {
                  // setState(() {
                  //   notifikasidetaillist =
                  //       fetchNotifikasiDetail(snapshot.data![i].nota);
                  //   nota = snapshot.data![i].nota;
                  //   nama = snapshot.data![i].nama;
                  //   tanggal = snapshot.data![i].tanggal;
                  //   total = snapshot.data![i].subtotalrp;
                  //   cabang = snapshot.data![i].cabang;
                  //   telp = snapshot.data![i].telpcabang;
                  //   email = snapshot.data![i].emailcabang;
                  //   flag = snapshot.data![i].flag;
                  //   li = 2;
                  // });
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
          boxShadow:const [
            BoxShadow(color: Colors.white, spreadRadius: 1),
          ],
        ),
        child: ListTile(
          dense: true,
          contentPadding:
              const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
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
          boxShadow: const[
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
                          Text(' ' + telp),
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
                            '?subject=notifikasi No.' +
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
                          Text(' ' + email),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
      // Expanded(
      //   child: FutureBuilder<List<notifikasidetail>>(
      //     future: notifikasidetaillist,
      //     builder: (context, snapshot) {
      //       if (!snapshot.hasData)
      //         return Center(child: CircularProgressIndicator());
      //       return ListView.builder(
      //         itemCount: snapshot.data!.length,
      //         itemBuilder: (context, i) {
      //           return Container(
      //             decoration: BoxDecoration(
      //               border: Border(
      //                 bottom: BorderSide(
      //                   color: Palette.menuOther,
      //                   width: 1.0,
      //                 ),
      //               ),
      //               color: Colors.white,
      //               boxShadow: [
      //                 BoxShadow(color: Colors.white, spreadRadius: 1),
      //               ],
      //             ),
      //             child: ListTile(
      //               dense: true,
      //               contentPadding: EdgeInsets.only(
      //                   left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
      //               leading: AspectRatio(
      //                 aspectRatio: 1 / 1,
      //                 child: new Image.network(
      //                     Palette.sUrl + snapshot.data![i].thumbnail,
      //                     fit: BoxFit.fill),
      //               ),
      //               title: Text(snapshot.data![i].judul),
      //               subtitle: Text(snapshot.data![i].hargax +
      //                   ' x ' +
      //                   snapshot.data![i].jumlah +
      //                   ' = ' +
      //                   snapshot.data![i].subtotalrp),
      //               onTap: () {
      //                 setState(() {
      //                   nota = snapshot.data![i].nota;
      //                   li = 2;
      //                 });
      //               },
      //             ),
      //           );
      //         },
      //       );
      //     },
      //   ),
      // ),
    ]);
  }
}
