import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constans.dart';
import '../login.dart';
import 'akunpage.dart';
import 'beranda.dart';
import 'favoritepage.dart';
import 'keranjangpage.dart';
import 'transaksipage.dart';

class LandingPage extends StatefulWidget {
  final Widget? child;
  final String nav;
  const LandingPage(this.nav, {Key? key, this.child}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool login = false;
  String userid = "";
  int jmlnotif = 0;
  int _bottomNavCurrentIndex = 0;
  final List<Widget> _container = <Widget>[
    Beranda(),
    Favorite(),
    KeranjangPage(),
    TransaksiPage(),
    Akun()
  ];

  @override
  void initState() {
    super.initState();
    cekLogin();
    if (widget.nav == "1") {
      _bottomNavCurrentIndex = 1;
    } else if (widget.nav == "2") {
      _bottomNavCurrentIndex = 2;
    } else if (widget.nav == "3") {
      _bottomNavCurrentIndex = 3;
    }
  }

  @override
  void dispose() {
    _bottomNavCurrentIndex = 0;
    super.dispose();
  }

  cekLogin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      login = prefs.getBool('login') ?? false;
      userid = prefs.getString('username') ?? "";
      jmlnotif = prefs.getInt('jmlnotif') ?? 0;
    });
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
            if (index < 3) {
              setState(() {
                _bottomNavCurrentIndex = index;
              });
            } else {
              if (login) {
                setState(() {
                  _bottomNavCurrentIndex = index;
                });
              } else {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return const Login('');
                }));

                // Navigator.of(context).pushNamedAndRemoveUntil(
                //     '/login', (Route<dynamic> route) => false);
              }
            }
          },
          currentIndex: _bottomNavCurrentIndex,
          items: [
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.home,
                color: Palette.bg1,
              ),
              icon: Icon(
                Icons.home,
                color: Palette.menuOther,
              ),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.favorite,
                color: Palette.bg1,
              ),
              icon: Icon(
                Icons.favorite_border,
                color: Palette.menuOther,
              ),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.shopping_cart,
                color: Palette.bg1,
              ),
              icon: Icon(
                Icons.shopping_cart,
                color: Palette.menuOther,
              ),
              label: 'Keranjang',
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
