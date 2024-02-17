import 'package:flutter/material.dart';

class SlotMap extends StatefulWidget {
  const SlotMap({super.key});

  @override
  State<SlotMap> createState() => _SlotMapState();
}

class _SlotMapState extends State<SlotMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Slot Map"),
      ),
    );
  }
}