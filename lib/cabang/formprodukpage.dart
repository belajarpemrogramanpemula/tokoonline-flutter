import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../constans.dart';
import '../helper/dbhelper.dart';
import '../models/kategori.dart';
import '../models/subkategori.dart';
import '../models/produk.dart';
import 'produkdetailpage.dart';

class FormProdukPage extends StatefulWidget {
  const FormProdukPage({Key? key}) : super(key: key);

  @override
  _FormProdukPageState createState() => _FormProdukPageState();
}

class _FormProdukPageState extends State<FormProdukPage> {
  String? _valsubkategori;
  List<Subkategori> subkategorilist = [];
  DbHelper dbHelper = DbHelper();
  List<Kategori> kategorilist = [];
  List<Produk> produklist = [];
  String userid = "";
  int jmlnotif = 0;

  @override
  void initState() {
    super.initState();
    // fetchSubKategori();
    _valsubkategori = null;
    cekLogin();
  }

  @override
  void dispose() {
    super.dispose();
    kategorilist = [];
  }

  // Future<List<Subkategori>> fetchSubKategori() async {
  //   List<Subkategori> usersList;
  //   var params = "/subkategori";
  //   try {
  //     var jsonResponse = await http.get(Palette.sUrl + params);
  //     if (jsonResponse.statusCode == 200) {
  //       //dbHelper.deletekategori();
  //       final jsonItems =
  //           json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

  //       usersList = jsonItems.map<Subkategori>((json) {
  //         //dbHelper.insertkategori(Kategori.fromJson(json));
  //         return Subkategori.fromJson(json);
  //       }).toList();

  //       setState(() {
  //         subkategorilist = usersList;
  //       });
  //     }
  //   } catch (e) {
  //     usersList = subkategorilist;
  //   }
  //   return usersList;
  // }

  cekLogin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString('username') ?? "";
    });
    fetchKategori();
  }

  Future<List<Kategori>> fetchKategori() async {
    List<Kategori> usersList = [];
    var params = "/kategoribyprodukexceptbyuserid?userid=" + userid;
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      var jsonResponse = await http.get(sUrl);
      if (jsonResponse.statusCode == 200) {
        final jsonItems =
            json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

        usersList = jsonItems.map<Kategori>((json) {
          return Kategori.fromJson(json);
        }).toList();

        setState(() {
          kategorilist = usersList;
        });
      }
    } catch (e) {
      usersList = kategorilist;
    }
    return usersList;
  }

  Future _refresh() {
    return fetchKategori().then((_kategori) {});
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
        title: const Text('Form Produk', style: TextStyle(color: Colors.white)),
        backgroundColor: Palette.bg1,
      ),
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                //mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 10),
                    //margin: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        DropdownButtonFormField(
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
                          hint: const Text("Pilih Kategori"),
                          value: _valsubkategori,
                          items: kategorilist.map((item) {
                            return DropdownMenuItem(
                              child: Text(item.nama.toString()),
                              value: item.id.toString(),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _valsubkategori = value.toString();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  _valsubkategori == null
                      ? produkbyKategori()
                      : produkbyKategoriFilter(
                          int.parse(_valsubkategori.toString()), userid),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget produkbyKategoriFilter(int id, String userid) {
    List<Kategori> kat = [];
    kat = kategorilist.where((i) => i.id == id).toList();
    String nama = kat[0].nama.toString();
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          WidgetbyKategori(id, nama, userid, 0),
        ],
      ),
    );
  }

  Widget produkbyKategori() {
    // ignore: avoid_unnecessary_containers
    return Container(
      //margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (int i = 0; i < kategorilist.length; i++)
            WidgetbyKategori(
                kategorilist[i].id, kategorilist[i].nama.toString(), userid, i),
        ],
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

  // void _saveProduk(BuildContext context) async {
  //   loadingProses(context);
  //   var params = "/postproduk";
  //   try {
  //     var stream =
  //         new http.ByteStream(_image.openRead()).cast();
  //     var length = await _image.length();
  //     var uri = Uri.parse(Palette.sUrl + params);
  //     var request = new http.MultipartRequest("POST", uri);

  //     request.fields["idsubkategori"] = _valsubkategori;
  //     request.fields["judul"] = txtnama.text.trim();
  //     request.fields["deskripsi"] = txtdeskripsi.text.trim();
  //     request.fields["harga"] = txtharga.text.trim();

  //     var multipartFile = new http.MultipartFile('image_file', stream, length,
  //         filename: basename(_image.path));

  //     request.files.add(multipartFile);
  //     final sres = await request.send();
  //     final res = await http.Response.fromStream(sres);
  //     if (res.body == "OK") {
  //       Navigator.of(context).pop();
  //       Navigator.of(context).pop();
  //     }

  //   } catch (e) {}
  // }
}

class WidgetbyKategori extends StatefulWidget {
  final Widget? child;
  final int id;
  final String kategori;
  final String userid;
  final int warna;

  const WidgetbyKategori(this.id, this.kategori, this.userid, this.warna,
      {Key? key, this.child})
      : super(key: key);

  @override
  _WidgetbyKategoriState createState() => _WidgetbyKategoriState();
}

class _WidgetbyKategoriState extends State<WidgetbyKategori> {
  DbHelper dbHelper = DbHelper();
  List<Produk> produklist = [];
  bool selected = false;

  Future<List<Produk>> fetchProduk(String id) async {
    List<Produk> usersList = [];
    var params =
        "/produkbykategoriexceptbyuserid?id=" + id + "&userid=" + widget.userid;
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
      usersList = produklist;
    }
    return usersList;
  }

  _tambahProduk(int id, String idkategori) async {
    var params = "/tambahprodukcabangbyid?idproduk=" +
        id.toString() +
        "&userid=" +
        widget.userid;
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      http.get(sUrl).then((response) {
        var res = response.body.toString();
        if (res == "OK") {
          fetchProduk(idkategori);
        }
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.only(right: 10.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text(
                    widget.kategori,
                    style: const TextStyle(color: Colors.white),
                  ),
                  width: 200.0,
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0)),
                    color: Palette.colors[widget.warna],
                    boxShadow: [
                      BoxShadow(
                          color: Palette.colors[widget.warna], spreadRadius: 1),
                    ],
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder<List<Produk>>(
            future: fetchProduk(widget.id.toString()),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Column(
                    children: const [
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              }
              return GridView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                ),
                children: snapshot.data!.map((e) {
                  return Card(
                    margin: const EdgeInsets.all(10),
                    // ignore: avoid_unnecessary_containers
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (_) {
                                return ProdukDetailPage(e.id, e.judul, e.harga,
                                    e.hargax, e.deskripsi, e.thumbnail);
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
                                      child: Image.network(
                                          Palette.sUrl + e.thumbnail,
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                  // new Image.network(Palette.sUrl + e.thumbnail),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(e.judul),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, bottom: 5.0),
                                    child: Text(e.harga),
                                  ),
                                ],
                              ),
                            ),
                            //Image.network(Palette.sUrl + e.thumbnail),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _tambahProduk(e.id, widget.id.toString());
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 5.0, right: 5.0, bottom: 5.0),
                                height: 40.0,
                                child: const Center(
                                  child: Text('Tambah',
                                      style: TextStyle(color: Colors.white)),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.blue, spreadRadius: 1),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
