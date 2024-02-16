class ParkingLot {
  String? uuid;
  String? name;
  String? image_url;
  String? open;
  String? close;
  int? rate;
  double? latitude;
  double? longitude;
  String? occupancy;
  double? distance;

  ParkingLot({
    this.uuid,
    this.name,
    this.image_url,
    this.open,
    this.close,
    this.rate,
    this.latitude,
    this.longitude,
    this.occupancy,
    this.distance,
  });

  factory ParkingLot.fromJson(Map<String, dynamic> json) {
    return ParkingLot(
      uuid: json['uuid'], 
      name: json['name'], 
      image_url: json['image'], 
      open: json['open'], 
      close: json['close'], 
      rate: json['rate'], 
      latitude: json['latitude'], 
      longitude: json['longitude'], 
      occupancy: json['occupancy'], 
      distance: json['distance']
      );
  }
}