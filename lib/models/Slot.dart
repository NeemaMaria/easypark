class Slot {
  String? uuid;
  String? parking_lot;
  String? slot_number;
  double? latitude;
  double? longitude;
  bool? occupied;
  bool? reserved;

  Slot(
      {this.uuid,
      this.parking_lot,
      this.slot_number,
      this.occupied,
      this.reserved,
      this.latitude,
      this.longitude});

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
        uuid: json['uuid'],
        parking_lot: json['parking_lot'],
        slot_number: json['slot_number'],
        latitude:
            json['latitude'] != null ? double.parse(json['latitude']) : null,
        longitude:
            json['longitude'] != null ? double.parse(json['longitude']) : null,
        occupied: json['occupied'],
        reserved: json['reserved']);
  }
}
