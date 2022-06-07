import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constans.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/produk.dart';
import '../models/cabang.dart';
import 'produkdetailpage.dart';

class ProdukPage extends StatefulWidget {
  final Widget? child;
  final String flag;
  final int idkategori;
  final int idsubkategori;
  final String namalabel;

  const ProdukPage(
      this.flag, this.idkategori, this.idsubkategori, this.namalabel,
      {Key? key, this.child})
      : super(key: key);

  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  List<Produk> produklist = [];
  String? _valcabang;
  List<Cabang> cabanglist = [];
  bool instok = false;

  @override
  void initState() {
    super.initState();
    fetchProduk(widget.flag, widget.idkategori, widget.idsubkategori);
    fetchCabang();
    //_cekCabang();
  }

  // _cekCabang() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (prefs.getString('cabang') != "") {
  //     setState(() {
  //       _valcabang = prefs.getString('cabang');
  //     });
  //   }
  // }

  _setCabang() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cabang', _valcabang!);
  }

  Future<List<Cabang>> fetchCabang() async {
    List<Cabang> usersList = [];
    var params = "/cabang";
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      var jsonResponse = await http.get(sUrl);
      if (jsonResponse.statusCode == 200) {
        final jsonItems =
            json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

        usersList = jsonItems.map<Cabang>((json) {
          return Cabang.fromJson(json);
        }).toList();
        setState(() {
          cabanglist = usersList;
        });
      }
      // ignore: empty_catches
    } catch (e) {}
    return usersList;
  }

  Future<List<Produk>> fetchProduk(
      String flag, int idkategori, int idsubkategori) async {
    List<Produk> usersList = [];
    var params = "";
    if (flag == "kat") {
      params = "/produkbykategoriall?id=" + idkategori.toString();
    } else {
      params = "/produkbysubkategoriall?id=" +
          idkategori.toString() +
          "&idsub=" +
          idsubkategori.toString();
    }
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      var jsonResponse = await http.get(sUrl);
      if (jsonResponse.statusCode == 200) {
        final jsonItems =
            json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

        usersList = jsonItems.map<Produk>((json) {
          return Produk.fromJson(json);
        }).toList();

        setState(() {
          produklist = usersList;
        });
      }
    } catch (e) {
      setState(() {
        produklist = [];
      });
    }
    return usersList;
  }

  Future<List<Produk>> fetchProdukbyCabang(
      String flag, int idkategori, int idsubkategori, String idcabang) async {
    List<Produk> usersList = [];
    var params = "";
    if (flag == "kat") {
      params = "/produkbykategoriallbycabang?id=" +
          idkategori.toString() +
          "&idcabang=" +
          idcabang;
    } else {
      params = "/produkbysubkategoriallbycabang?id=" +
          idkategori.toString() +
          "&idsub=" +
          idsubkategori.toString() +
          "&idcabang=" +
          idcabang;
    }
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      var jsonResponse = await http.get(sUrl);
      if (jsonResponse.statusCode == 200) {
        final jsonItems =
            json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

        usersList = jsonItems.map<Produk>((json) {
          return Produk.fromJson(json);
        }).toList();

        setState(() {
          produklist = usersList;
          instok = true;
        });
      }
    } catch (e) {
      setState(() {
        produklist = [];
      });
    }
    return usersList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title:
            Text(widget.namalabel, style: const TextStyle(color: Colors.white)),
        backgroundColor: Palette.bg1,
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(10),
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.only(top: 10, left: 12.0, bottom: 10),
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
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                        ),
                        fillColor: Colors.black,
                        filled: false),
                    hint: const Text("Pilih Cabang"),
                    value: _valcabang,
                    items: cabanglist.map((item) {
                      return DropdownMenuItem(
                        child: Text(item.nama.toString()),
                        value: item.id.toString(),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _valcabang = value.toString();
                        fetchProdukbyCabang(widget.flag, widget.idkategori,
                            widget.idsubkategori, value.toString());
                      });
                      _setCabang();
                    },
                  ),
                ),
                _wpProdukPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _wpProdukPage() {
    return GridView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
      ),
      children: produklist.map((e) {
        return Card(
          margin: const EdgeInsets.all(10),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return ProdukDetailPage(e.id, e.judul, e.harga, e.hargax,
                    e.deskripsi, e.thumbnail, instok);
              }));
            },
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // ignore: avoid_unnecessary_containers
                  Container(
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Image.network(Palette.sUrl + e.thumbnail,
                          fit: BoxFit.fill),
                    ),
                  ),
                  // new Image.network(Palette.sUrl + e.thumbnail),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(e.judul),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: Text(e.harga),
                  ),
                ],
              ),
            ),
            //Image.network(Palette.sUrl + e.thumbnail),
          ),
        );
      }).toList(),
    );
  }
}
