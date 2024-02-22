import 'package:flutter/material.dart';

class ParkingLotMap extends StatefulWidget {
  final double lat;
  final double lon;

  const ParkingLotMap({super.key, required this.lat, required this.lon});

  @override
  State<ParkingLotMap> createState() => _ParkingLotMapState();
}

class _ParkingLotMapState extends State<ParkingLotMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("${widget.lat}, ${widget.lon}"),
      )
    );
  }
}