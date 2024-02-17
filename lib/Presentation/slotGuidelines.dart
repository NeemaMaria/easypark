import 'dart:async';
import 'dart:convert';
import 'package:easypark/Presentation/userSessions.dart';
import 'package:easypark/models/ParkingDetails.dart';
import 'package:easypark/models/ParkingGraphic.dart';
import 'package:easypark/models/Slot.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import "package:http/http.dart" as http;
import "../variables.dart";

class SlotGuidelines extends StatefulWidget {
  final String uuid;

  const SlotGuidelines({super.key, required this.uuid});

  @override
  State<SlotGuidelines> createState() => SlotGuidelinesState();
}

class SlotGuidelinesState extends State<SlotGuidelines> {
  Slot slot = Slot();
  ParkingDetails parking_lot = ParkingDetails();

  bool loading = true;

  late Timer _timer;

  Future<Slot> fetchDetails() async {
    var response = await http
        .get(Uri.parse("http://$server:8000/slot_details/${widget.uuid}/"));
    var json = jsonDecode(response.body);
    return Slot.fromJson(json);
  }

  Future<ParkingDetails> fetchParkingDetails(uuid) async {
    var response = await http
        .get(Uri.parse("http://$server:8000/parking_lot_details/$uuid/"));
    var json = jsonDecode(response.body);
    return ParkingDetails.fromJson(json);
  }

  List<String> parseLocation(String str) {
    List arr = str.split('-');
    return [arr[0][2], arr[1]];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // periodic fetching
    const apiCallInterval = Duration(seconds: 2);
    _timer = Timer.periodic(apiCallInterval, (Timer timer) {
      fetchDetails().then((value) {
        setState(() {
          slot = value;
        });
        fetchParkingDetails(slot.parking_lot).then((value) {
          setState(() {
            parking_lot = value;
          });
        });
      });
    });

    fetchDetails().then((value) {
      setState(() {
        slot = value;
      });
      fetchParkingDetails(slot.parking_lot).then((value) {
        setState(() {
          parking_lot = value;
          loading = false;
        });
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: loading
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Container(
                    height: 0.3 * deviceHeight,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "http://$server:8000${parking_lot.image_url}"),
                            fit: BoxFit.cover)),
                  ),
                  Column(
                    children: [
                      SizedBox(height: 0.05 * deviceHeight),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                  size: 25,
                                )),
                            SizedBox(width: 10),
                            Text(
                              parking_lot.name!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 0.17 * deviceHeight),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25)),
                              color: Colors.grey[900]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 25.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 0.25 * deviceHeight,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          height: 0.35 * deviceHeight,
                                          width: 0.4 * deviceWidth,
                                          child: ParkingGraphic(
                                              height: 0.35 * deviceHeight)),
                                      SizedBox(width: 24.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                parking_lot.name!,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            Text(
                                              "Level ${parseLocation(slot.slot_number!)[0]}",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                            Text(
                                              "Slot ${parseLocation(slot.slot_number!)[1]}",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                            Divider(),
                                            RichText(
                                                text: TextSpan(children: [
                                              const TextSpan(
                                                text: "Drive to ",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              TextSpan(
                                                text:
                                                    "Level ${parseLocation(slot.slot_number!)[0]} ",
                                                style: TextStyle(
                                                    color: Colors.blue[400]),
                                              ),
                                              const TextSpan(
                                                text:
                                                    "of the parking block and then to slot number ",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              TextSpan(
                                                text:
                                                    "${parseLocation(slot.slot_number!)[1]}.",
                                                style: TextStyle(
                                                    color: Colors.blue[400]),
                                              ),
                                            ])),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 100),
                                slot.occupied!
                                    ? Column(
                                        children: [
                                          SizedBox(height: 150),
                                          InkWell(
                                            onTap: () => Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        UserSessions())),
                                            child: Container(
                                              height: 45,
                                              width: 0.35 * deviceWidth,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: Colors.blue[400],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                    horizontal: 16.0),
                                                child: Text(
                                                  "Park",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          Lottie.asset(
                                              height: 150,
                                              "assets/driving.json"),
                                          SizedBox(height: 16.0),
                                          InkWell(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                    vertical: 8.0),
                                                child: Text(
                                                  "On your way...",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ));
  }
}
