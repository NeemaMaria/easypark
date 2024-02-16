import 'dart:convert';
import 'package:easypark/models/ParkingLot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import "package:http/http.dart" as http;
import "../variables.dart";

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final TextEditingController _search = TextEditingController();

  List<ParkingLot> parking_lots = [];
  ParkingLot nearest_lot = ParkingLot();

  Future<List<ParkingLot>> fetchData() async {
    var response = await http
        .get(Uri.parse("http://$server:8000/nearest_parking_lots/$lat/$lon/"));
    List lots = jsonDecode(response.body) as List;
    return lots.map((lot) => ParkingLot.fromJson(lot)).toList();
  }

  Column organize_lots(List parking_lots) {
    double deviceWidth = MediaQuery.of(context).size.width;
    List<Widget> lots = [];

    for (int i = 0; i < parking_lots.length; i += 2) {
      Widget pair = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildParkingLotWidget(parking_lots[i], deviceWidth),
          if (i + 1 < parking_lots.length)
            buildParkingLotWidget(parking_lots[i + 1], deviceWidth),
        ],
      );
      lots.add(pair);
    }

    return Column(
      children: lots,
    );
  }

  Widget buildParkingLotWidget(ParkingLot lot, double deviceWidth) {
    return Container(
      width: 0.46 * deviceWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 8,
            width: 4,
          ),
          Container(
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                image: DecorationImage(
                    image: NetworkImage("http://$server:8000${lot.image_url}/"),
                    fit: BoxFit.cover)),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lot.name!,
                style: const TextStyle(
                  color: Color.fromARGB(255, 10, 2, 2),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${lot.distance!.toStringAsFixed(1)}km",
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.grey[600]),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData().then(((value) {
      setState(() {
        nearest_lot = value[0];
        parking_lots = value.sublist(1);
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 0, 47, 1),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 30,
                            color: Color.fromARGB(255, 218, 218, 218),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Location",
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 218, 218, 218))),
                              Text(
                                location_name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 218, 218, 218)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                        controller: _search,
                        decoration: const InputDecoration(
                          hintText: "Search Parking",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Color.fromARGB(255, 218, 218, 218),
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 39, 39, 39),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Parking at ${nearest_lot.name}", // find how to make it flexible
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 218, 218, 218),
                                          fontSize: 24)),
                                  Text(
                                    "${nearest_lot.distance!.toStringAsFixed(2)}Km away",
                                    style: TextStyle(color: Colors.grey[500]),
                                  )
                                ],
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 218, 218, 218),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                child: const Icon(
                                  Icons.share_location,
                                  size: 30,
                                ),
                              ),
                            ]),
                        const SizedBox(height: 8.0),
                        const Divider(
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Enter After",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "${nearest_lot.open} am",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 218, 218, 218),
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  "Duration",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "16 Hours",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 218, 218, 218),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Exit Before",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "${nearest_lot.close} pm",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 218, 218, 218),
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Booking Price",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "UGX ${nearest_lot.rate}",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 218, 218, 218),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Transform.scale(
                            scaleY: 0.7,
                            child: Image.asset("assets/barcode.png")),
                      ],
                    )),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nearest Parking Lots',
                    style: TextStyle(
                      color: Color.fromARGB(255, 10, 2, 2),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'See More',
                    style: TextStyle(
                      color: Color.fromARGB(255, 10, 2, 2),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.all(10.0), // Adjust the padding as needed
                child: organize_lots(parking_lots)),
          ],
        ),
      ),
    );
  }
}
