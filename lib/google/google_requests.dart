import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:http/http.dart" as http;

String mode = "driving";

Future getDrivingRouteUsingGoogle(LatLng source, LatLng destination) async {
  String url = "https://maps.googleapis.com/maps/api/directions/json?destination=${destination.latitude},${destination.longitude}&origin=${source.latitude},${source.longitude}&mode=${mode}&key=${dotenv.env['GOOGLE_MAPS_API']}";
  try {
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  } catch (e) {
    print(e);
  }
}