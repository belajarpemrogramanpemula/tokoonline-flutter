import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constans.dart';
import '../helper/dbhelper.dart';
import 'package:sqflite/sqflite.dart';
import '../models/keranjang.dart';
import 'depanpage.dart';
import 'kategoripage.dart';
import 'notifikasipage.dart';

// ignore: use_key_in_widget_constructors
class Beranda extends StatefulWidget {
  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> with SingleTickerProviderStateMixin {
  DbHelper dbHelper = DbHelper();
  TabController? _tabController;
  //int _activeTabIndex;
  bool login = false;
  String userid = "";
  List<Keranjang> keranjanglist = [];
  int jmlnotif = 0;

  @override
  void initState() {
    super.initState();
    getkeranjang();
    cekLogin();
    _tabController = TabController(vsync: this, length: 2);
    _tabController!.addListener(_setActiveTabIndex);
  }

  @override
  void dispose() {
    super.dispose();
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
    return keranjanglist;
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

  void _setActiveTabIndex() {
    //_activeTabIndex = _tabController.index;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: TextField(
              onTap: () {
                // Navigator.of(context).push(
                //     MaterialPageRoute<Null>(builder: (BuildContext context) {
                //   return new SearchPage();
                // }));
                Navigator.of(context).pushNamed('/cari');

                // Navigator.of(context).push(
                //     MaterialPageRoute<Null>(builder: (BuildContext context) {
                //   return new SearchPage();
                // }));
              },
              readOnly: true,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search, color: Palette.orange),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  fillColor: const Color(0xfff3f3f4),
                  filled: true),
            ),
            backgroundColor: Palette.bg1,
            actions: <Widget>[
              Row(
                children: [
                  Padding(
                      padding: login == false
                          ? const EdgeInsets.only(right: 15.0)
                          : const EdgeInsets.only(right: 5.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/keranjangusers',
                              (Route<dynamic> route) => false);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Stack(
                            children: [
                              const Icon(
                                Icons.shopping_cart,
                                size: 28.0,
                              ),
                              Positioned(
                                top: 2,
                                right: 4,
                                child: keranjanglist.isNotEmpty
                                    ? Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          keranjanglist.length.toString(),
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
            actionsIconTheme: const IconThemeData(
                size: 26.0, color: Colors.white, opacity: 10.0),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Palette.orange,
              labelColor: Palette.orange,
              unselectedLabelColor: Colors.grey,
              labelPadding: const EdgeInsets.all(0),
              tabs: const [
                Tab(text: 'Beranda'),
                Tab(text: 'Kategori'),
              ],
            )),
        backgroundColor: Palette.bg1,
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: const [
            Depan(),
            KategoriPage(),
          ],
        ),
      ),
    );
  }
}
