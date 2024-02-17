import 'dart:convert';
import 'package:easypark/models/ParkingDetails.dart';
import 'package:easypark/models/Slot.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:mapbox_gl/mapbox_gl.dart';
import "../variables.dart";

class SlotMap extends StatefulWidget {
  final String uuid;
  const SlotMap({super.key, required this.uuid});

  @override
  State<SlotMap> createState() => _SlotMapState();
}

class _SlotMapState extends State<SlotMap> {
  Slot slot = Slot();
  ParkingDetails parking_lot = ParkingDetails();

  bool loading = true;

  late CameraPosition _initialCameraPosition;
  late MapboxMapController controller;

  LatLng currentLatLng = LatLng(lat, lon);

  Future<Slot> slotDetails() async {
    var response = await http
        .get(Uri.parse("http://$server:8000/slot_details/${widget.uuid}/"));
    var json = jsonDecode(response.body);
    return Slot.fromJson(json);
  }

  Future<ParkingDetails> parkingDetails(uuid) async {
    var response = await http
        .get(Uri.parse("http://$server:8000/parking_lot_details/$uuid/"));
    var json = jsonDecode(response.body);
    return ParkingDetails.fromJson(json);
  }

  @override
  void initState() {
    super.initState();
    slotDetails().then((value) {
      setState(() {
        slot = value;
      });
      parkingDetails(slot.parking_lot!).then((value) {
        parking_lot = value;
      });
    });
    // location details
    _initialCameraPosition = CameraPosition(target: currentLatLng, zoom: 15);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Slot Map"),
      ),
    );
  }
}
