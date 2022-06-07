import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constans.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/produk.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchQuery = TextEditingController();
  late bool _iscari;
  String _searchText = "";
  List<Produk> produklist = [];

  @override
  void initState() {
    super.initState();
    _iscari = false;
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _iscari = false;
          _searchText = "";
          produklist = [];
        });
      } else {
        setState(() {
          _iscari = true;
          _searchText = _searchQuery.text;
          fetchProduk(_searchText);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _iscari = false;
    produklist = [];
  }

  Future<List<Produk>> fetchProduk(String txt) async {
    List<Produk> usersList = [];
    var params = "/produkbysearch?txt=" + txt;
    // var params = "/produkbysearch?txt=home";
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        // title: Text('SearchPage', style: TextStyle(color: Colors.white)),
        title: TextField(
          // onTap: () {
          //   Navigator.of(context).push(
          //       MaterialPageRoute<Null>(builder: (BuildContext context) {
          //     return new SearchPage();
          //   }));
          //   // Navigator.of(context).pushNamed('/cari');

          //   // Navigator.of(context).push(
          //   //     MaterialPageRoute<Null>(builder: (BuildContext context) {
          //   //   return new SearchPage();
          //   // }));
          // },
          // readOnly: true,
          controller: _searchQuery,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search, color: Palette.orange),
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white),
              ),
              fillColor: const Color(0xfff3f3f4),
              filled: true),
        ),
        backgroundColor: Palette.bg1,
        // actions: <Widget>[
        //   Padding(
        //     padding: EdgeInsets.only(right: 15.0),
        //     child: GestureDetector(
        //       onTap: () {
        //         Navigator.pop(context);
        //       },
        //       child: Container(
        //         margin: EdgeInsets.only(top: 5),
        //         child: Icon(
        //           Icons.clear,
        //           size: 36.0,
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _iscari
                    ? _wpSearchPage()
                    : const Center(
                        child: Text('\nSilahkan masukan kata pencarian',
                            style: TextStyle(fontSize: 18)),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _wpSearchPage() {
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
              // Navigator.of(context).push(
              //     MaterialPageRoute<Null>(builder: (BuildContext context) {
              //   return new ProdukDetailPage(
              //       e.id, e.judul, e.harga, e.hargax, e.thumbnail, instok);
              // }));
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
