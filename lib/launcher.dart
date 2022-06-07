import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constans.dart';

class LauncherPage extends StatefulWidget {
  const LauncherPage({Key? key}) : super(key: key);

  @override
  _LauncherPageState createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  // final _firebaseMessaging = FirebaseMessaging();
  String token = '';

  @override
  void initState() {
    // fcmConfigure();
    super.initState();
    startLaunching();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void fcmConfigure(){
  //   _firebaseMessaging.getToken().then((token) => setState(() {
  //     this.token = token;
  //   }));
  // }

  startLaunching() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);

    bool login;
    String level = "3";
    login = prefs.getBool('login') ?? false;
    level = prefs.getString('level') ?? '';
    var duration = const Duration(seconds: 3);
    return Timer(duration, () {
      if (login) {
        if (level == "1") {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/landingadmin', (Route<dynamic> route) => false);
        } else if (level == "2") {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/landingcabang', (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/landingusers', (Route<dynamic> route) => false);
        }
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/landingusers', (Route<dynamic> route) => false);
      }
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: const Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Palette.bg1, Palette.bg2])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Image.asset(
                "assets/logo.png",
                height: 100.0,
                width: 280.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
