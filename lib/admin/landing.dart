import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constans.dart';
import 'akunpage.dart';
import 'beranda.dart';
import 'produkpage.dart';
import 'transaksipage.dart';

class LandingPage extends StatefulWidget {
  final Widget? child;
  final String nav;
  const LandingPage(this.nav, {Key? key, this.child}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late bool login;
  int _bottomNavCurrentIndex = 0;
  final List<Widget> _container = <Widget>[
    Beranda(),
    ProdukPage(),
    TransaksiPage(),
    AkunPage()
  ];

  @override
  void initState() {
    super.initState();
    if (widget.nav == "1") {
      _bottomNavCurrentIndex = 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Palette.bg1,
    ));
    return Scaffold(
        body: _container[_bottomNavCurrentIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Palette.bg1,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _bottomNavCurrentIndex = index;
            });
          },
          currentIndex: _bottomNavCurrentIndex,
          items: [
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.dashboard,
                color: Palette.bg1,
              ),
              icon: Icon(
                Icons.dashboard,
                color: Palette.menuOther,
              ),
              label: 'Master',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.style,
                color: Palette.bg1,
              ),
              icon: Icon(
                Icons.style,
                color: Palette.menuOther,
              ),
              label: 'Produk',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.swap_horiz_sharp,
                color: Palette.bg1,
              ),
              icon: Icon(
                Icons.swap_horiz_sharp,
                color: Palette.menuOther,
              ),
              label: 'Transaksi',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.person,
                color: Palette.bg1,
              ),
              icon: Icon(
                Icons.person_outline,
                color: Palette.menuOther,
              ),
              label: 'Profil',
            ),
          ],
        ));
  }
}
