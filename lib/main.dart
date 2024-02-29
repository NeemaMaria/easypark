import 'package:easypark/Presentation/home.dart';
import 'package:flutter/material.dart';
import 'package:easypark/Presentation/lot.dart';


void main() {
  runApp(EasyPark());
}

class EasyPark extends StatefulWidget {
  const EasyPark({super.key});

  @override
  State<EasyPark> createState() => _EasyParkState();
}

class _EasyParkState extends State<EasyPark> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Easy Park",
      home: home(),
    );
  }
}

