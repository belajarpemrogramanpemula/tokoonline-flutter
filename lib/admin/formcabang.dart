import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../constans.dart';

// ignore: use_key_in_widget_constructors
class FormCabangPage extends StatefulWidget {
  @override
  _FormCabangPageState createState() => _FormCabangPageState();
}

class _FormCabangPageState extends State<FormCabangPage> {
  final TextEditingController txtuseridcabang = TextEditingController();
  final TextEditingController txtpasswordcabang = TextEditingController();
  final TextEditingController txtcabang = TextEditingController();
  final TextEditingController txtalamatcabang = TextEditingController();
  final TextEditingController txtkotacabang = TextEditingController();
  final TextEditingController txtpropinsicabang = TextEditingController();
  final TextEditingController txttelpcabang = TextEditingController();
  final TextEditingController txtemailcabang = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Palette.bg1,
    ));
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text('Form Cabang', style: TextStyle(color: Colors.white)),
        backgroundColor: Palette.bg1,
      ),
      backgroundColor: Colors.grey[100],
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Userid',
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: txtuseridcabang,
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
                          controller: txtpasswordcabang,
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
                          'Nama Cabang',
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: txtcabang,
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
                          'Alamat',
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: txtalamatcabang,
                          keyboardType: TextInputType.multiline,
                          minLines: 3,
                          maxLines: 3,
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
                          'Kota',
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: txtkotacabang,
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
                  // Container(
                  //   margin: EdgeInsets.only(bottom: 10),
                  //   width: MediaQuery.of(context).size.width,
                  //   child: new Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: <Widget>[
                  //       Text(
                  //         'Propinsi',
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.normal, fontSize: 16),
                  //       ),
                  //       SizedBox(
                  //         height: 5,
                  //       ),
                  //       TextField(
                  //         controller: txtpropinsicabang,
                  //         keyboardType: TextInputType.text,
                  //         style: TextStyle(fontSize: 16),
                  //         enabled: true,
                  //         autofocus: true,
                  //         decoration: InputDecoration(
                  //             contentPadding: EdgeInsets.only(
                  //                 top: 10, left: 12.0, bottom: 10),
                  //             border: new OutlineInputBorder(
                  //               borderRadius: const BorderRadius.all(
                  //                 const Radius.circular(5.0),
                  //               ),
                  //               borderSide: new BorderSide(
                  //                 color: Colors.black,
                  //                 width: 1.0,
                  //               ),
                  //             ),
                  //             focusedBorder: OutlineInputBorder(
                  //               borderRadius:
                  //                   BorderRadius.all(Radius.circular(5.0)),
                  //               borderSide:
                  //                   BorderSide(color: Colors.black, width: 1.0),
                  //             ),
                  //             fillColor: Colors.black,
                  //             filled: false),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Telp',
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: txttelpcabang,
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
                  // Container(
                  //   margin: EdgeInsets.only(bottom: 10),
                  //   width: MediaQuery.of(context).size.width,
                  //   child: new Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: <Widget>[
                  //       Text(
                  //         'Email',
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.normal, fontSize: 16),
                  //       ),
                  //       SizedBox(
                  //         height: 5,
                  //       ),
                  //       TextField(
                  //         controller: txtemailcabang,
                  //         keyboardType: TextInputType.text,
                  //         style: TextStyle(fontSize: 16),
                  //         enabled: true,
                  //         autofocus: true,
                  //         decoration: InputDecoration(
                  //             contentPadding: EdgeInsets.only(
                  //                 top: 10, left: 12.0, bottom: 10),
                  //             border: new OutlineInputBorder(
                  //               borderRadius: const BorderRadius.all(
                  //                 const Radius.circular(5.0),
                  //               ),
                  //               borderSide: new BorderSide(
                  //                 color: Colors.black,
                  //                 width: 1.0,
                  //               ),
                  //             ),
                  //             focusedBorder: OutlineInputBorder(
                  //               borderRadius:
                  //                   BorderRadius.all(Radius.circular(5.0)),
                  //               borderSide:
                  //                   BorderSide(color: Colors.black, width: 1.0),
                  //             ),
                  //             fillColor: Colors.black,
                  //             filled: false),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 10.0),
                  InkWell(
                    onTap: () {
                      _saveCabang(context, {
                        "userid": txtuseridcabang.text.trim(),
                        "password": txtpasswordcabang.text.trim(),
                        "nama": txtcabang.text.trim(),
                        "alamat": txtalamatcabang.text.trim(),
                        "kota": txtkotacabang.text.trim(),
                        //"propinsi": txtpropinsicabang.text.trim(),
                        "telp": txttelpcabang.text.trim(),
                        //"email": txtemailcabang.text.trim()
                      });
                    },
                    child:  SizedBox(
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
                ],
              ),
            ),
          ],
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
            ElevatedButton(
              child: const Text("Tutup"),
              onPressed: () {
                if (flag == "Err") {
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(main).pop();
                  Navigator.pop(main);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> _saveCabang(context, Map data) async {
    if (txtuseridcabang.text.trim() == "") {
      _showDialog(context, 'Maaf, Userid Kosong', 'Err');
    } else if (txtpasswordcabang.text.trim() == "") {
      _showDialog(context, 'Maaf, Password Kosong', 'Err');
    } else if (txtcabang.text.trim() == "") {
      _showDialog(context, 'Maaf, Nama Cabang Kosong', 'Err');
    } else {
      loadingProses(context);
      var params = "/postcabang";
      var sUrl = Uri.parse(Palette.sUrl + params);
      try {
        http.post(sUrl, body: data).then((response) {
          var res = response.body.toString();
          if (res == "OK") {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).pop();
            _showDialog(context, res, 'Err');
          }
        });
    // ignore: empty_catches
      } catch (e) {}
    }
  }
}
