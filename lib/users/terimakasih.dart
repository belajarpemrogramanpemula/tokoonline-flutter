import 'package:flutter/material.dart';
import '../constans.dart';

class Terimakasih extends StatefulWidget {
  const Terimakasih({ Key? key }) : super(key: key);

  @override
  _TerimakasihState createState() => _TerimakasihState();
}

class _TerimakasihState extends State<Terimakasih> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Terimakasih', style: TextStyle(color: Colors.white)),
          backgroundColor: Palette.bg1,
        ),
        body: SafeArea(
          child:  Container(
            color: Colors.white,
            child: Row(children: <Widget>[_wpTerimakasih()]),
          ),
        ));
  }

  Widget _wpTerimakasih() {
    return const Expanded(
      child: Center(
        child: Text('Terima Kasih', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
