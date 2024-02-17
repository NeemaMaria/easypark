import 'dart:convert';
import 'package:easypark/Presentation/nearestSlots.dart';
import 'package:easypark/Presentation/parkingSlots.dart';
import 'package:easypark/models/ParkingDetails.dart';
import 'package:flutter/material.dart';
import "../variables.dart";
import "package:http/http.dart" as http;

class ParkingLotDetails extends StatefulWidget {
  final String uuid;
  final double distance;

  const ParkingLotDetails(
      {super.key, required this.uuid, required this.distance});

  @override
  State<ParkingLotDetails> createState() => _ParkingLotDetailsState();
}

class _ParkingLotDetailsState extends State<ParkingLotDetails> {
  late ParkingDetails parking_lot;
  bool loading = true;

  Future<ParkingDetails> fetchData() async {
    var response = await http.get(
        Uri.parse("http://$server:8000/parking_lot_details/${widget.uuid}/"));
    var jsonObj = jsonDecode(response.body);
    return ParkingDetails.fromJson(jsonObj);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData().then((value) {
      setState(() {
        parking_lot = value;
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
            : Stack(
                children: [
                  Container(
                    height: 0.35 * deviceHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "http://$server:8000${parking_lot.image_url}/"),
                            fit: BoxFit.cover)),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 0.06 * deviceHeight,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50)),
                                child: Card(
                                  color: Colors.white,
                                  child: Icon(Icons.arrow_back_ios_rounded),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 0.19 * deviceHeight,
                      ),
                      Container(
                        height: 0.65 * deviceHeight,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 80,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 10.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          parking_lot.name!,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.green[500],
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6.0,
                                                horizontal: 10.0),
                                            child: Text(
                                              "UGX ${parking_lot.rate}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 0.27 * deviceWidth,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                            width: 2.0,
                                            color: Color.fromARGB(
                                                255, 6, 68, 119))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.time_to_leave_outlined,
                                          color: Colors.grey[800],
                                        ),
                                        Text(
                                          "${parking_lot.free_slots} Slots",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[800]),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: 0.27 * deviceWidth,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                            width: 2.0,
                                            color: Color.fromARGB(
                                                255, 6, 68, 119))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.access_time_rounded,
                                          color: Colors.grey[800],
                                        ),
                                        Text(
                                          "${parking_lot.open}am",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[800]),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: 0.27 * deviceWidth,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                            width: 2.0,
                                            color: Color.fromARGB(
                                                255, 6, 68, 119))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.grey[800],
                                        ),
                                        Text(
                                          "${widget.distance.toStringAsFixed(2)} km",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[800]),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                "Description",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                "This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. ",
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                            SizedBox(height: 16.0),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                "Services Provided",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: parking_lot.services_provided!
                                    .map((service) => Text("• $service"))
                                    .toList(),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ParkingSlots(uuid: parking_lot.uuid!))),
                                    child: Container(
                                      height: 50,
                                      width: 0.42 * deviceWidth,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.blue[600],
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 12.0),
                                        child: Text(
                                          "View Lot",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => NearestSlots(uuid: parking_lot.uuid!, structured: parking_lot.structured!,))),
                                    child: Container(
                                      height: 50,
                                      width: 0.42 * deviceWidth,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.green[600],
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 12.0),
                                        child: Text(
                                          "Reserve slot",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ));
  }
}
