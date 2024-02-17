import 'package:easypark/Presentation/home.dart';
import 'package:easypark/Presentation/userSessions.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const EasyPark());
}

class EasyPark extends StatefulWidget {
  const EasyPark({super.key});

  @override
  State<EasyPark> createState() => _EasyParkState();
}

class _EasyParkState extends State<EasyPark> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Easy Park",
      debugShowCheckedModeBanner: false,
      home: home()
    );
  }
}