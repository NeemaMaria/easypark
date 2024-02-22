import 'package:easypark/google/google_requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<Set<Polyline>> getDirectionsAPIResponse(
    LatLng currentLatLng, double latitude, double longitude) async {
  List<LatLng> polylineCoordinates = [];

  final response = await getDrivingRouteUsingGoogle(
      currentLatLng, LatLng(latitude, longitude));
  print(response);
  String encoded_polyline =
      response['routes'][0]['overview_polyline']['points'];

  List<PointLatLng> decodedPolyPoints =
      PolylinePoints().decodePolyline(encoded_polyline);
  decodedPolyPoints.forEach((PointLatLng point) {
    polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  });

  return {
    Polyline(
      polylineId: PolylineId('overview_polyline'),
      color: Colors.blue,
      points: polylineCoordinates,
      width: 4,
    ),
  };
}