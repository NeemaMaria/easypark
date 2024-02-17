import 'package:easypark/Presentation/home.dart';
import 'package:easypark/Presentation/slotMap.dart';
import 'package:flutter/material.dart';
import './variables.dart';

void main() async {
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
    return MaterialApp(
      title: "Easy Park",
      debugShowCheckedModeBanner: false,
      home: SlotMap(uuid: slot_id)
    );
  }
}