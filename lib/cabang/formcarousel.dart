import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';

import 'package:flutter/services.dart';
import '../constans.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';


class FormCarousel extends StatefulWidget {
  final Widget? child;
  final int id;
  final String namaproduk;

  const FormCarousel(this.id, this.namaproduk,{Key? key, this.child}) : super(key: key);

  @override
  _FormCarouselState createState() => _FormCarouselState();
}

class _FormCarouselState extends State<FormCarousel> {
  TextEditingController txtjudul = TextEditingController();
  File? _image;
  ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  Future _imgFromCamera() async {    
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  Future _imgFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        debugPrint('No image selected.');
      }
    });
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

  void _saveCarousel(BuildContext context) async {
    loadingProses(context);
    var params = "/tambahcarouselbyid";
    try {
      var stream =
           http.ByteStream(DelegatingStream.typed(_image!.openRead()));
      //var stream = new http.ByteStream(_image.openRead()).cast();
      var length = await _image!.length();
      var uri = Uri.parse(Palette.sUrl + params);
      var request = new http.MultipartRequest("POST", uri);

      request.fields["idproduk"] = widget.id.toString();
      request.fields["judul"] = txtjudul.text.trim();

      var multipartFile =  http.MultipartFile('image_file', stream, length,
          filename: basename(_image!.path));

      request.files.add(multipartFile);
      final sres = await request.send();
      final res = await http.Response.fromStream(sres);
      if (res.body == "OK") {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    // ignore: empty_catches
    } catch (e) {}
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
        title: const Text('Form Promo', style: TextStyle(color: Colors.white)),
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
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                         Text(
                          widget.namaproduk,
                          style: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10, right: 10),
                    width: MediaQuery.of(context).size.width,
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Keterangan',
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: txtjudul,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontSize: 16),
                          enabled: true,
                          autofocus: true,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  top: 10, left: 12.0, bottom: 10),
                              border:  OutlineInputBorder(
                                borderRadius:  BorderRadius.all(
                                   Radius.circular(5.0),
                                ),
                                borderSide:  BorderSide(
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
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Gambar',
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
    // ignore: avoid_unnecessary_containers
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin:
                                    const EdgeInsets.only(bottom: 10, right: 10.0),
                                height: 140.0,
                                width: MediaQuery.of(context).size.width,
                                child: _image == null
                                    ? const Text('No image selected.')
                                    : Image.file(_image!),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: _imgFromCamera,
                                    child: Container(
                                      width: 60.0,
                                      height: 40.0,
                                      margin: const EdgeInsets.only(right: 10.0),
                                      child: const Icon(Icons.add_a_photo,
                                          color: Colors.blue),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.blue),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5.0) //
                                            ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: _imgFromGallery,
                                    child: Container(
                                      width: 60.0,
                                      height: 40.0,
                                      margin: const EdgeInsets.only(right: 10.0),
                                      child:
                                          const Icon(Icons.image, color: Colors.blue),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.blue),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5.0) //
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  InkWell(
                    onTap: () => _saveCarousel(context),
                    child: Container(
                      height: 60.0,
                      margin: const EdgeInsets.only(left: 5, right: 10),
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
                  const SizedBox(height: 30.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
