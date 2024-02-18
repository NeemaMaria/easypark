import 'package:easypark/mapbox/mapbox_requests.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

// parse the request to mapbox to get the geometry, duration and distance

Future<Map> getDirectionsAPIResponse(LatLng currentLatLng, double latitude, double longitude) async {
  final response = await getDrivingRouteUsingMapbox(
      currentLatLng,
      LatLng(latitude,
          longitude));
  Map geometry = response['routes'][0]['geometry'];
  num duration = response['routes'][0]['duration'];
  num distance = response['routes'][0]['distance'];

  Map modifiedResponse = {
    "geometry": geometry,
    "duration": duration,
    "distance": distance,
  };
  return modifiedResponse;
}