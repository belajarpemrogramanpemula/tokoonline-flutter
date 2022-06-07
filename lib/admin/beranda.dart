import 'package:flutter/material.dart';

import '../constans.dart';
import 'cabangpage.dart';
import 'kategoripage.dart';
import 'pelangganpage.dart';
import 'package:http/http.dart' as http;

// ignore: use_key_in_widget_constructors
class Beranda extends StatefulWidget {
  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int jmlnotif = 0;

  @override
  void initState() {
    super.initState();
    _cekStAll();
    _tabController = TabController(vsync: this, length: 3);
    _tabController!.addListener(_setActiveTabIndex);
  }

  _cekStAll() async {
    var params = "/cekst";
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
    } catch (e) {return null;}
  }

  void _setActiveTabIndex() {
    //_activeTabIndex = _tabController.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Beranda', style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/transaksiadmin', (Route<dynamic> route) => false);
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
          actionsIconTheme: const IconThemeData(
              size: 26.0, color: Colors.white, opacity: 10.0),
          backgroundColor: Palette.bg1,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Palette.orange,
            labelColor: Palette.orange,
            unselectedLabelColor: Colors.grey,
            labelPadding: const EdgeInsets.all(0),
            tabs: const [
              Tab(text: 'Kategori'),
              Tab(text: 'Cabang'),
              Tab(text: 'Pelanggan'),
            ],
          )),
      body: TabBarView(
        //physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: const [
          KategoriPage(),
          CabangPage(),
          PelangganPage(),
        ],
      ),
    );
  }
}
