import 'dart:convert';
import 'package:easypark/Presentation/userSessions.dart';
import 'package:easypark/mapbox/directions_handler.dart';
import 'package:easypark/models/ParkingDetails.dart';
import 'package:easypark/models/Slot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:http/http.dart" as http;
import 'package:lottie/lottie.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

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
  LatLng currentLatLng = LatLng(double.parse(dotenv.env['LAT']!), double.parse(dotenv.env['LON']!));
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
        .get(Uri.parse("http://${dotenv.env['SERVER']}:8000/slot_details/${widget.uuid}/"));
    var json = jsonDecode(response.body);
    return Slot.fromJson(json);
  }

  Future<ParkingDetails> parkingDetails(uuid) async {
    var response = await http
        .get(Uri.parse("http://${dotenv.env['SERVER']}:8000/parking_lot_details/$uuid/"));
    var json = jsonDecode(response.body);
    return ParkingDetails.fromJson(json);
  }

  Future<void> park() async {
    var response = await http.post(Uri.parse(
        "http://${dotenv.env['SERVER']}:8000/park_in_slot/${parking_lot.uuid}/${slot.uuid}/${dotenv.env['USER_ID']}/"));
    if (response.statusCode == 200) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => UserSessions()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green[500],
          content: const Text("Parking Session Active")));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.red[400],
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Error",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.warning_amber_rounded, color: Colors.white)
                ],
              ),
              content: const Text(
                "Something went wrong. Try again!",
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("OK", style: TextStyle(color: Colors.white)))
              ],
            );
          });
    }
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
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: MapboxMap(
                    accessToken: dotenv.env['MAPBOX_SECRET_TOKEN'],
                    initialCameraPosition: _initialCameraPosition,
                    onMapCreated: _onMapCreated,
                    onStyleLoadedCallback: _onStyleLoadedCallback,
                    myLocationEnabled: true,
                    myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
                    minMaxZoomPreference: const MinMaxZoomPreference(14, 17),
                  ),
                ),
                Column(children: [
                  SizedBox(height: 0.01 * deviceHeight),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: Colors.green[400],
                              borderRadius: BorderRadius.circular(100)),
                          child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon:
                                  Icon(Icons.arrow_back, color: Colors.white)),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.green[400]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Text(
                              slot.slot_number!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  slot.occupied!
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Column(
                            children: [
                              SizedBox(height: 150),
                              InkWell(
                                onTap: () => park(),
                                child: Container(
                                  height: 45,
                                  width: 0.35 * deviceWidth,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.blue[400],
                                      borderRadius: BorderRadius.circular(25)),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    child: Text(
                                      "Park",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Column(
                            children: [
                              Lottie.asset(height: 100, "assets/driving.json"),
                              SizedBox(height: 16.0),
                              InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(25)),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 8.0),
                                    child: Text(
                                      "On your way...",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                ])
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
