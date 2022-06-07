import 'package:flutter/material.dart';

import 'constans.dart';
import 'forgot.dart';
import 'launcher.dart';
import 'login.dart';
import 'signup.dart';
import 'users/landing.dart' as users;
import 'admin/landing.dart' as admin;
import 'cabang/landing.dart' as cabang;
import 'users/searchpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TOKO ONLINE',
      theme: ThemeData(
        fontFamily: 'NeoSans',
        primaryColor: Palette.grey,
      ),
      home: const LauncherPage(),
      routes: <String, WidgetBuilder>{
        '/cari': (BuildContext context) => const SearchPage(),
        '/login': (BuildContext context) => const Login(''),
        '/signup': (BuildContext context) => const SignupPage(),
        '/forgot': (BuildContext context) => const ForgotPage(),
        '/landingadmin': (BuildContext context) => const admin.LandingPage(''),
        '/landingcabang': (BuildContext context) => const cabang.LandingPage(''),
        '/landingusers': (BuildContext context) => const users.LandingPage(''),
        '/favusers': (BuildContext context) => const users.LandingPage('1'),
        '/keranjangusers': (BuildContext context) => const users.LandingPage('2'),
        '/transaksi': (BuildContext context) => const users.LandingPage('3'),
        '/promocabang': (BuildContext context) => const cabang.LandingPage('1'),
        '/transaksicabang': (BuildContext context) => const cabang.LandingPage('2'),
        '/transaksiadmin': (BuildContext context) => const admin.LandingPage('1'),
        //'/terimaksih': (BuildContext context) => const Terimakasih(),
      },
    );
  }
}
