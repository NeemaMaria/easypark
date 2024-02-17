import 'package:flutter/material.dart';

class SlotGuidelines extends StatefulWidget {
  const SlotGuidelines({super.key});

  @override
  State<SlotGuidelines> createState() => SlotGuidelinesState();
}

class SlotGuidelinesState extends State<SlotGuidelines> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Slot Guidelines"),
      ),
    );
  }
}