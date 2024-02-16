import 'package:easypark/models/Slot.dart';

class ParkingDetails {
  final String uuid;
  final String name;
  final String image_url;
  final double latitude;
  final double longitude;
  final int rate;
  final String open;
  final String close;
  final int number_of_stories;
  final List services_provided;
  final String occupancy;
  final List slots;

  const ParkingDetails({
    required this.uuid,
    required this.name,
    required this.image_url,
    required this.latitude,
    required this.longitude,
    required this.rate,
    required this.open,
    required this.close,
    required this.number_of_stories,
    required this.services_provided,
    required this.occupancy,
    required this.slots,
  });

  factory ParkingDetails.fromJson(Map<String, dynamic> json) {
    return ParkingDetails(
        uuid: json['uuid'],
        name: json['name'],
        image_url: json['image'],
        latitude: double.parse(json['latitude']),
        longitude: double.parse(json['longitude']),
        rate: json['rate'],
        open: format_time(json['open']),
        close: format_time(json['close']),
        number_of_stories: json['number_of_stories'],
        services_provided: json['services_provided'],
        occupancy: json['occupancy'],
        slots: json['slots'].map((slot) => Slot.fromJson(slot)).toList());
  }
}

String format_time(time) {
  List arr = time.split(":");
  return arr.sublist(0,2).join(":");
}