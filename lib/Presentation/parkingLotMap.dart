import 'package:easypark/mapbox/directions_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class ParkingLotMap extends StatefulWidget {
  final double lat;
  final double lon;
  final String name;

  const ParkingLotMap({super.key, required this.lat, required this.lon, required this.name});

  @override
  State<ParkingLotMap> createState() => _ParkingLotMapState();
}

class _ParkingLotMapState extends State<ParkingLotMap> {

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
        geometry: LatLng(widget.lat, widget.lon),
        iconSize: 0.2,
        iconImage: "assets/icon.png"));

    _addSourceAndLineLayer();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialCameraPosition = CameraPosition(target: currentLatLng, zoom: 16);
    // location details
      getDirectionsAPIResponse(currentLatLng, widget.lat, widget.lon)
          .then((value) {
        setState(() {
          modifiedMap = value;
        });
      });
      slotPosition = CameraPosition(
          target: LatLng(widget.lat, widget.lon), zoom: 15);
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
                  height: deviceHeight,
                  child: MapboxMap(
                    accessToken: dotenv.env['MAPBOX_SECRET_TOKEN'],
                    initialCameraPosition: _initialCameraPosition,
                    onMapCreated: _onMapCreated,
                    onStyleLoadedCallback: _onStyleLoadedCallback,
                    myLocationEnabled: true,
                    myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
                    minMaxZoomPreference: const MinMaxZoomPreference(10, 20),
                  ),
                ),
                Column(
                  children: [
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
                              widget.name,
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
                  ],
                )
          ],
        ),
      ),
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