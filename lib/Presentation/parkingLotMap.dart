import 'package:easypark/google/directions_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class ParkingLotMap extends StatefulWidget {
  final double lat;
  final double lon;
  final String name;

  const ParkingLotMap(
      {super.key, required this.lat, required this.lon, required this.name});

  @override
  State<ParkingLotMap> createState() => _ParkingLotMapState();
}

class _ParkingLotMapState extends State<ParkingLotMap> {
  GoogleMapController? mapController;

  MapType _mapType = MapType.normal;

  // user location
  // Location location = Location();
  // LocationData? userLocation;

  Set<Marker> markers = {};

  Set<Polyline> polylines = {};

  bool loading = true;

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    setState(() {
      markers.add(Marker(
        markerId: MarkerId(widget.name),
        position: LatLng(widget.lat, widget.lon),
        infoWindow: InfoWindow(title: widget.name),
      ));
      markers.add(Marker(
          markerId: MarkerId("User Location"),
          position: LatLng(double.parse(dotenv.env['LAT']!),
              double.parse(dotenv.env['LON']!)),
          infoWindow: InfoWindow(title: "My Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen)));
    });
  }

  // if we want to base off the user's location
  // Future<void> _getUserLocation() async {
  //   final user_location = await location.getLocation();
  //   setState(() {
  //     userLocation = user_location;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    getDirectionsAPIResponse(
            LatLng(double.parse(dotenv.env['LAT']!),
                double.parse(dotenv.env['LON']!)),
            widget.lat,
            widget.lon)
        .then((value) {
      setState(() {
        polylines = value;
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
                      height: deviceHeight,
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        myLocationButtonEnabled: false,
                        myLocationEnabled: true,
                        compassEnabled: false,
                        mapType: _mapType,
                        polylines: polylines,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(
                              double.parse(dotenv.env['LAT']!),
                              double.parse(dotenv.env['LON']!),
                            ),
                            zoom: 12),
                        markers: markers,
                      )),
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
                                  icon: Icon(Icons.arrow_back,
                                      color: Colors.white)),
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
                            Expanded(
                              child: SizedBox(),
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: Colors.green[400],
                                  borderRadius: BorderRadius.circular(100)),
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _mapType = _mapType == MapType.normal
                                          ? MapType.satellite
                                          : MapType.normal;
                                    });
                                  },
                                  icon: Icon(Icons.flip_to_front_outlined,
                                      color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
