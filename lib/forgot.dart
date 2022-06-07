import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'constans.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({Key? key}) : super(key: key);

  @override
  _ForgotPageState createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final TextEditingController emailController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> _postData(BuildContext context, Map data) async {
    if (emailController.text.trim() == "") {
      _showDialog(context, 'Maaf, Email Kosong', 'Err');
    } else {
      var params = "/lupapassword";
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
      } catch (e) {
        debugPrint("");
      }
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
            child: const Text('Lupa Password',
                style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16.0, 160.0, 0.0, 0.0),
            child: const Text('Silahkan Masukkan Email Anda :',
                style:
                    TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal)),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return Container(
        padding: const EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: 'EMAIL',
                  labelStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  // hintText: 'EMAIL',
                  // hintStyle: ,
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Palette.menuNiaga))),
            ),
            const SizedBox(height: 50.0),
            InkWell(
              onTap: () => _postData(context, {
                "email": emailController.text.trim(),
              }),
              // ignore: avoid_unnecessary_containers
              child:  SizedBox(
                height: 60.0,
                child: Material(
                  borderRadius: BorderRadius.circular(10.0),
                  shadowColor: Colors.blue[800],
                  color: Palette.menuNiaga,
                  elevation: 7.0,
                  child: const Center(
                    child: Text(
                      'Selanjutnya',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 55.0),
          ],
        ));
  }
}
