import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constans.dart';
import 'helper/dbhelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatefulWidget {
  final Widget? child;
  final String nav;
  const Login(this.nav, {Key? key, this.child}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  DbHelper dbHelper = DbHelper();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool visible = false;
  String token = '';

  @override
  void initState() {
    super.initState();
  }

  _updateKeranjang(String userid) async {
    Database? db = await dbHelper.database;
    var batch = db.batch();
    db.execute('update keranjang set userid=?', [userid]);
    batch.commit();
  }

  _cekLogin() async {
    setState(() {
      visible = true;
    });
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";

    var params = "/login?username=" +
        userNameController.text +
        "&password=" +
        passwordController.text +
        "&token=" +
        token;

    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      var res = await http.get(sUrl);
      if (res.statusCode == 200) {
        var response = json.decode(res.body);
        
        if (response['response_status'] == "OK") {
          prefs.setBool('login', true);
          prefs.setString('username', response['data'][0]['username']);
          prefs.setString('nama', response['data'][0]['nama']);
          prefs.setString('email', response['data'][0]['email']);
          prefs.setString('level', response['data'][0]['level']);
          prefs.setString('foto', response['data'][0]['foto']);
          setState(() {
            visible = false;
          });
          if (response['data'][0]['level'] == "1") {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/landingadmin', (Route<dynamic> route) => false);
          } else if (response['data'][0]['level'] == "2") {
            prefs.setString('alamat', response['data'][0]['alamat']);
            prefs.setString('kota', response['data'][0]['kota']);
            prefs.setString('telp', response['data'][0]['telp']);
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/landingcabang', (Route<dynamic> route) => false);
          } else {
            prefs.setString('alamat', response['data'][0]['alamat']);
            prefs.setString('kota', response['data'][0]['kota']);
            prefs.setString('telp', response['data'][0]['telp']);
            
            if (widget.nav == "") {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/landingusers', (Route<dynamic> route) => false);
            } else {
              _updateKeranjang(response['data'][0]['username']);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/keranjangusers', (Route<dynamic> route) => false);
            }
          }
        } else {
          setState(() {
            visible = false;
          });
          _showAlertDialog(context, response['response_message']);
        }
      }
    } catch (e) {
      setState(() {
        visible = false;
      });
    }
  }

  _showAlertDialog(BuildContext context, String err) {
    Widget okButton = ElevatedButton(
      child: const Text("OK"),
      //onPressed: () {},
      onPressed: () => Navigator.pop(context),
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Error"),
      content: Text(err),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _header(),
                // ignore: avoid_unnecessary_containers
                Container(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                      Visibility(
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: visible,
                          // ignore: avoid_unnecessary_containers
                          child: Container(
                              child: const CircularProgressIndicator())),
                    ])),
                _body(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.fromLTRB(0.0, 20.0, 10.0, 0.0),
            child: InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.clear, size: 50.0)),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
            child: const Text('Login Sekarang',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16.0, 145.0, 0.0, 0.0),
            child: const Text(
                'Cari Produk Kamu. Buat Pesanan. Kami Antar Barangmu Sekarang Juga',
                style:
                    TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal)),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return Container(
        padding: const EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: userNameController,
              keyboardType: TextInputType.text,
              autocorrect: false,
              decoration: InputDecoration(
                  labelText: 'USERNAME',
                  labelStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Palette.menuNiaga))),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: passwordController,
              keyboardType: TextInputType.text,
              autocorrect: false,
              decoration: InputDecoration(
                  labelText: 'PASSWORD',
                  labelStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Palette.menuNiaga))),
              obscureText: true,
            ),
            const SizedBox(height: 5.0),
            Container(
              alignment: const Alignment(1.0, 0.0),
              padding: const EdgeInsets.only(top: 15.0, left: 20.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/forgot');
                },
                child: Text(
                  'Lupa Password',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Palette.menuNiaga,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      decoration: TextDecoration.underline),
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            InkWell(
              onTap: _cekLogin,
              // onTap: () {
              //   Navigator.of(context).pushNamedAndRemoveUntil(
              //       '/dashboard', (Route<dynamic> route) => false);
              // },
              // ignore: avoid_unnecessary_containers
              child: SizedBox(
                height: 60.0,
                child: Material(
                  borderRadius: BorderRadius.circular(10.0),
                  shadowColor: Colors.blue[800],
                  color: Palette.menuNiaga,
                  elevation: 7.0,
                  child: const Center(
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Belum punya akun?',
                  style: TextStyle(fontSize: 16.0, fontFamily: 'Montserrat'),
                ),
                const SizedBox(width: 5.0),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/signup');
                  },
                  child: Text(
                    'Daftar Sekarang',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Palette.menuNiaga,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
            const SizedBox(height: 55.0),
          ],
        ));
  }
}
