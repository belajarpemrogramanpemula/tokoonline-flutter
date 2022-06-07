import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constans.dart';

// ignore: use_key_in_widget_constructors
class AkunPage extends StatefulWidget {
  @override
  _AkunPageState createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  WidgetAktif selectedWidgetMarker = WidgetAktif.profil;
  late bool login;
  String userid = "";
  String nama = "";
  String keterangan = "";
  double jarakatas = 70.0;
  bool visible = false;
  final TextEditingController txtnama = TextEditingController();
  final TextEditingController txtpassword = TextEditingController();
  final TextEditingController txtemail = TextEditingController();
  int jmlnotif = 0;

  @override
  void initState() {
    super.initState();
    _getProfil();
    _cekStAll();
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

  cekLogout() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('login', false);
      prefs.setString('username', '');
      prefs.setString('nama', '');
      prefs.setString('email', '');
      prefs.setString('level', '');
      prefs.setString('foto', '');
      prefs.setString('cabang', '');
    });
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/landingusers', (Route<dynamic> route) => false);
  }

  _getProfil() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString('username') ?? "";
      nama = "Nama : ";
      nama += prefs.getString('nama') ?? "";
      keterangan = "Email : ";
      keterangan += prefs.getString('email') ?? "";
      userid = prefs.getString('username') ?? "";
      txtnama.text = prefs.getString('nama') ?? "";
      txtemail.text = prefs.getString('email') ?? "";
    });
  }

  _setProfil() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('nama', txtnama.text);
    prefs.setString('email', txtemail.text);
    setState(() {
      nama = "Nama : " + txtnama.text;
      keterangan = "Email : " + txtemail.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil', style: TextStyle(color: Colors.white)),
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
        actionsIconTheme:
            const IconThemeData(size: 26.0, color: Colors.white, opacity: 10.0),
        backgroundColor: Palette.bg1,
      ),
      body: SafeArea(
        child: _widgetContainer(context),
      ),
    );
  }

  Widget _widgetContainer(BuildContext context) {
    switch (selectedWidgetMarker) {
      case WidgetAktif.profil:
        return _widgetProfil(context);
      case WidgetAktif.form:
        return _widgetForm(context);
    }
  }

  Widget _widgetProfil(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: jarakatas),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 80,
              backgroundImage: const AssetImage('assets/images/profil.png'),
              backgroundColor: Palette.grey,
            ),
            SelectableText(
              userid,
              style: const TextStyle(
                fontFamily: 'SourceSansPro',
                fontSize: 25,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 5.0, top: 15.0, bottom: 10.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SelectableText(nama,
                                  style: const TextStyle(fontSize: 16)),
                            ])),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 5.0, top: 0.0, bottom: 10.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SelectableText(keterangan,
                                  style: const TextStyle(fontSize: 16)),
                            ])),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedWidgetMarker = WidgetAktif.form;
                        });
                      },
                      // ignore: avoid_unnecessary_containers
                      child: SizedBox(
                        height: 50.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(5.0),
                          shadowColor: Colors.blue[800],
                          color: Palette.menuNiaga,
                          elevation: 7.0,
                          child: const Center(
                            child: Text(
                              'Edit Profil',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                      onTap: () {
                        cekLogout();
                      },
                      child: Container(
                        height: 50.0,
                        margin: const EdgeInsets.only(top: 10),
                        child: Material(
                          borderRadius: BorderRadius.circular(5.0),
                          shadowColor: Colors.blue[800],
                          color: Palette.menuNiaga,
                          elevation: 7.0,
                          child: const Center(
                            child: Text(
                              'Logout',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Expanded(
              flex: 2,
              child: SizedBox(),
            )
          ],
        ),
      ),
    );
  }

  Widget _widgetForm(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(left: 20, right: 20, top: 0.0, bottom: 0.0),
      child: Form(
        // ignore: avoid_unnecessary_containers
        child: Container(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedWidgetMarker = WidgetAktif.profil;
                          });
                        },
                        child: const Icon(Icons.clear, size: 50.0)),
                  ),
                  CircleAvatar(
                    radius: 80,
                    backgroundImage:
                        const AssetImage('assets/images/profil.png'),
                    backgroundColor: Palette.grey,
                  ),
                  SelectableText(
                    nama,
                    style: const TextStyle(
                      fontFamily: 'SourceSansPro',
                      fontSize: 25,
                    ),
                  ),
                  Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: visible,
                    // ignore: avoid_unnecessary_containers
                    child: Container(
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Nama',
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: txtnama,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontSize: 16),
                          enabled: true,
                          autofocus: true,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  top: 10, left: 12.0, bottom: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1.0),
                              ),
                              fillColor: Colors.black,
                              filled: false),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Password',
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: txtpassword,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontSize: 16),
                          enabled: true,
                          autofocus: true,
                          obscureText: true,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  top: 10, left: 12.0, bottom: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1.0),
                              ),
                              fillColor: Colors.black,
                              filled: false),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Email',
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: txtemail,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontSize: 16),
                          enabled: true,
                          autofocus: true,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  top: 10, left: 12.0, bottom: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1.0),
                              ),
                              fillColor: Colors.black,
                              filled: false),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  InkWell(
                    onTap: () {
                      _saveProfil(context, {
                        "userid": userid,
                        "nama": txtnama.text.trim(),
                        "password": txtpassword.text.trim(),
                        "email": txtemail.text.trim()
                      });
                    },
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
                            'SIMPAN',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                ]),
          ),
        ),
      ),
    );
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

  void _showDialog(BuildContext main, String msg, String flag) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: flag == "Err"
              ? const Text("Peringatan")
              : const Text("Informasi"),
          content: SelectableText(msg),
          actions: <Widget>[
            TextButton(
              child: const Text("Tutup"),
              onPressed: () {
                if (flag == "Err") {
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pop();
                  Navigator.pop(main);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> _saveProfil(context, Map data) async {
    if (txtnama.text.trim() == "") {
      _showDialog(context, 'Maaf, Nama Kosong', 'Err');
    } else if (txtemail.text.trim() == "") {
      _showDialog(context, 'Maaf, Email Kosong', 'Err');
    } else {
      loadingProses(context);
      var params = "/postprofiladmin";
      var sUrl = Uri.parse(Palette.sUrl + params);
      try {
        http.post(sUrl, body: data).then((response) {
          var res = response.body.toString();
          if (res == "OK") {
            _setProfil();
            Navigator.of(context).pop();
            setState(() {
              selectedWidgetMarker = WidgetAktif.profil;
            });
          } else {
            _showDialog(context, res, 'Err');
          }
        });
      } catch (e) {
        debugPrint("");
      }
    }
  }
}

enum WidgetAktif { profil, form }
