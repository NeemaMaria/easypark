import 'package:easypark/Presentation/home.dart';
import 'package:easypark/Presentation/slotMap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:location/location.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const EasyPark());
}

class EasyPark extends StatefulWidget {
  const EasyPark({super.key});

  @override
  State<EasyPark> createState() => _EasyParkState();
}

class _EasyParkState extends State<EasyPark> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      handleLocationPermissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Easy Park",
        debugShowCheckedModeBanner: false,
        // home: SlotMap(uuid: dotenv.env['SLOT_ID']!));
        home: home());
  }
}

Future handleLocationPermissions() async {
  Location _location = Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;

  _serviceEnabled = await _location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await _location.requestService();
  }

  _permissionGranted = await _location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await _location.requestPermission();
  }
}
