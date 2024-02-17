import 'package:easypark/models/ParkingGraphic.dart';
import 'package:easypark/models/Slot.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import "package:http/http.dart" as http;

class SlotGuidelines extends StatefulWidget {
  final String uuid;
  const SlotGuidelines({super.key, required this.uuid});

  @override
  State<SlotGuidelines> createState() => SlotGuidelinesState();
}

class SlotGuidelinesState extends State<SlotGuidelines> {

  Slot slot = Slot();

  bool loading = true;

  Future<Slot> fetchDetails() async {

  }


  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: const Text('Custom Shape Example'),
        ),
        body: Stack(
          children: [
            Container(
              height: 0.3 * deviceHeight,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/sheraton.png"),
                      fit: BoxFit.cover)),
            ),
            Column(
              children: [
                SizedBox(height: 0.27 * deviceHeight),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey[900]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 25.0),
                    child: Column(
                      children: [
                        Container(
                          height: 0.25 * deviceHeight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  height: 0.35 * deviceHeight,
                                  width: 0.4 * deviceWidth,
                                  child: ParkingGraphic(
                                      height: 0.35 * deviceHeight)),
                              SizedBox(width: 24.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Flexible(
                                      child: Text(
                                        "Sheraton Hotel",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                    const Text(
                                      "Level 3",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    const Text(
                                      "Slot 26",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    Divider(),
                                    RichText(
                                        text: TextSpan(children: [
                                      const TextSpan(
                                        text: "Drive to ",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      TextSpan(
                                        text: "Level 3 ",
                                        style:
                                            TextStyle(color: Colors.blue[400]),
                                      ),
                                      const TextSpan(
                                        text:
                                            "of the parking block and then to slot number ",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      TextSpan(
                                        text: "26.",
                                        style:
                                            TextStyle(color: Colors.blue[400]),
                                      ),
                                    ])),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 40),
                        Column(
                          children: [
                            Lottie.asset(height: 150, "assets/driving.json"),
                            SizedBox(height: 16.0),
                            InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(25)),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 8.0),
                                  child: Text(
                                    "On your way...",
                                    style: TextStyle(color: Colors.white),
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
              ],
            ),
          ],
        ));
  }
}
