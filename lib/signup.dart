import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'constans.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({ Key? key }) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController kotaController = TextEditingController();
  final TextEditingController propinsiController = TextEditingController();
  final TextEditingController kodeposController = TextEditingController();
  final TextEditingController telpController = TextEditingController();

  bool visible = false;
  String token = '';


  @override
  void initState() {
    super.initState();
    _cekToken();
  }

  _cekToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
  }


  Future<dynamic> _postData(BuildContext context, Map data) async {
    if (emailController.text.trim() == "") {
      _showDialog(context, 'Maaf, Email Kosong', 'Err');
    } else if (namaController.text.trim() == "") {
      _showDialog(context, 'Maaf, Nama Kosong', 'Err');
    } else if (alamatController.text.trim() == "") {
      _showDialog(context, 'Maaf, Alamat Kosong', 'Err');
    } else if (kotaController.text.trim() == "") {
      _showDialog(context, 'Maaf, Kota Kosong', 'Err');
    } else if (propinsiController.text.trim() == "") {
      _showDialog(context, 'Maaf, Propinsi Kosong', 'Err');
    } else if (telpController.text.trim() == "") {
      _showDialog(context, 'Maaf, Telp Kosong', 'Err');
    } else {
      var params = "/daftar";
      var sUrl = Uri.parse(Palette.sUrl + params);
      try {
        http.post(sUrl, body: data).then((response) {
          var res = response.body.toString().split("|");
          if (res[0] == "OK") {
            _showDialog(context, res[1], 'Success');
          } else {
            _showDialog(context, res[1], 'Err');
          }
        });
      } catch (e) {return null;}
    }
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
                          child: const CircularProgressIndicator()),
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
            child: const Text(
              'Daftar',
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16.0, 160.0, 0.0, 0.0),
            child: const Text('Silahkan Isi Data Berikut :',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal)),
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
              controller: emailController,
              decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  // hintText: 'EMAIL',
                  // hintStyle: ,
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Palette.menuNiaga))),
            ),
            TextField(
              controller: namaController,
              decoration: InputDecoration(
                  labelText: 'Nama',
                  labelStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Palette.menuNiaga))),
            ),
            TextField(
              controller: alamatController,
              decoration: InputDecoration(
                  labelText: 'Alamat',
                  labelStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Palette.menuNiaga))),
            ),
            TextField(
              controller: kotaController,
              decoration: InputDecoration(
                  labelText: 'Kota',
                  labelStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Palette.menuNiaga))),
            ),
            TextField(
              controller: propinsiController,
              decoration: InputDecoration(
                  labelText: 'Propinsi',
                  labelStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Palette.menuNiaga))),
            ),
            TextField(
              controller: telpController,
              decoration: InputDecoration(
                  labelText: 'Telp',
                  labelStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Palette.menuNiaga))),
            ),
            const SizedBox(height: 20.0),
            InkWell(
              onTap: () => _postData(context, {
                "email": emailController.text.trim(),
                "nama": namaController.text.trim(),
                "alamat": alamatController.text.trim(),
                "kota": kotaController.text.trim(),
                "propinsi": propinsiController.text.trim(),
                "telp": telpController.text.trim(),
                "token": token
              }),
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
                      'DAFTAR',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
          ],
        ));
  }

}
