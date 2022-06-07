import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constans.dart';
import '../helper/dbhelper.dart';
import '../models/carouselx.dart';

// ignore: use_key_in_widget_constructors
class CarouselPage extends StatefulWidget {

  @override
  _CarouselPageState createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  DbHelper dbHelper = DbHelper();
  Future<List<Carouselx>>? carousellist;

  @override
  void initState() {
    super.initState();
    carousellist = fetchCarousel();
  }

  Future<List<Carouselx>> fetchCarousel() async {
    List<Carouselx> usersList=[];
    var params = "/carousel";
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      var jsonResponse = await http.get(sUrl );
      if (jsonResponse.statusCode == 200) {
        final jsonItems =
            json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

        usersList = jsonItems.map<Carouselx>((json) {
          return Carouselx.fromJson(json);
        }).toList();
      }
    // ignore: empty_catches
    } catch (e) {}
    return usersList;
  }

  _hapusCarousel(int id) async {
    
    var params = "/hapuscarouselbyid?id=" + id.toString();
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      http.get(sUrl ).then((response) {
        var res = response.body.toString();
        
        if (res == "OK") {
          setState(() {
            carousellist = fetchCarousel();
          });
        }
      });
    } catch (e) {return null;}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promo', style: TextStyle(color: Colors.white)),
        backgroundColor: Palette.bg1,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _widgetList(context),
          )
        ],
      ),
    );
  }

  Widget _widgetList(BuildContext context) {
    return FutureBuilder<List<Carouselx>>(
      future: carousellist,
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
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, i) {
            return Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.white, spreadRadius: 1),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 140.0,
                    child: AspectRatio(
                      aspectRatio: MediaQuery.of(context).size.width,
                      child:  Image.network(
                          Palette.sUrl + snapshot.data![i].thumbnail,
                          fit: BoxFit.fill),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 5.0),
                    child: SelectableText(snapshot.data![i].judul),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 5.0),
                    child: SelectableText(snapshot.data![i].judul2),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 5.0, bottom: 5.0),
                    child: SelectableText(snapshot.data![i].harga2),
                  ),
                  GestureDetector(
                    onTap: () {
                      _hapusCarousel(snapshot.data![i].id);
                    },
                    child: Container(
                      margin:
                          const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 50.0),
                      height: 40.0,
                      child: const Center(
                        child: Text('Hapus',
                            style: TextStyle(color: Colors.white)),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const [
                          BoxShadow(color: Colors.red, spreadRadius: 1),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
