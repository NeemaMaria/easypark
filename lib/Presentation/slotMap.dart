import 'dart:convert';
import 'package:easypark/mapbox/directions_handler.dart';
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
  late CameraPosition slotPosition; // the parking slot
  Map? modifiedMap;

  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
  }

  _addSourceAndLineLayer() async {
    // Can animate camera to focus on the item
    controller.animateCamera(CameraUpdate.newCameraPosition(slotPosition));

    // Add a polyLine between source and destination
    Map geometry = modifiedMap!["geometry"]; // slot geometry details
    final _fills = {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "id": 0,
          "properties": <String, dynamic>{},
          "geometry": geometry,
        },
      ],
    };

    // Add new source and lineLayer
    await controller.addSource("fills", GeojsonSourceProperties(data: _fills));
    await controller.addLineLayer(
      "fills",
      "lines",
      LineLayerProperties(
        lineColor: Colors.green.toHexStringRGB(),
        lineCap: "round",
        lineJoin: "round",
        lineWidth: 2,
      ),
    );
  }

  _onStyleLoadedCallback() async {
    controller.addSymbol(SymbolOptions(
        geometry: LatLng(slot.latitude!, slot.longitude!),
        iconSize: 0.2,
        iconImage: "assets/icon.png"));

    _addSourceAndLineLayer();
  }

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
    _initialCameraPosition = CameraPosition(target: currentLatLng, zoom: 16);
    slotDetails().then((value) {
      setState(() {
        slot = value;
      });
      parkingDetails(slot.parking_lot!).then((value) {
        parking_lot = value;
      });

      // location details
      getDirectionsAPIResponse(currentLatLng, slot.latitude!, slot.longitude!)
          .then((value) {
        setState(() {
          modifiedMap = value;
        });
      });
      slotPosition = CameraPosition(
          target: LatLng(slot.latitude!, slot.longitude!), zoom: 15);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Slot Map"),
      ),
      body: SafeArea(
          child: Stack(
        children: [
          SizedBox(
            height: 0.9 * MediaQuery.of(context).size.height,
            child: MapboxMap(
              accessToken: secret_token,
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: _onMapCreated,
              onStyleLoadedCallback: _onStyleLoadedCallback,
              myLocationEnabled: true,
              myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
              minMaxZoomPreference: const MinMaxZoomPreference(14, 17),
            ),
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.animateCamera(
              CameraUpdate.newCameraPosition(_initialCameraPosition));
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
