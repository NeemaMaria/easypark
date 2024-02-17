import 'package:easypark/models/Slot.dart';

class ParkingDetails {
  String? uuid;
  String? name;
  String? image_url;
  double? latitude;
  double? longitude;
  int? rate;
  String? open;
  String? close;
  int? number_of_stories;
  List? services_provided;
  String? occupancy;
  int? free_slots;
  List? slots;
  bool? structured;

  ParkingDetails({
    this.uuid,
    this.name,
    this.image_url,
    this.latitude,
    this.longitude,
    this.rate,
    this.open,
    this.close,
    this.number_of_stories,
    this.services_provided,
    this.occupancy,
    this.free_slots,
    this.slots,
    this.structured,
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
        free_slots: freeSlots(json['occupancy']),
        slots: json['slots'].map((slot) => Slot.fromJson(slot)).toList(),
        structured: json['structured']
        );
  }
}

String format_time(time) {
  List arr = time.split(":");
  return arr.sublist(0,2).join(":");
}

int freeSlots(occupancy) {
  List arr = occupancy.split("/");
  return int.parse(arr[1]) - int.parse(arr[0]);
}