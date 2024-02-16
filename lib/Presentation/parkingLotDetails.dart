import 'package:flutter/material.dart';
import "../variables.dart";

class ParkingLotDetails extends StatefulWidget {
  final String uuid;

  const ParkingLotDetails({super.key, required this.uuid});

  @override
  State<ParkingLotDetails> createState() => _ParkingLotDetailsState();
}

class _ParkingLotDetailsState extends State<ParkingLotDetails> {
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: 0.35 * deviceHeight,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/chapel.png"), fit: BoxFit.cover)),
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
            Expanded(
              child: Container(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "College of Computing",
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                  color: Colors.green[500],
                                  borderRadius: BorderRadius.circular(25)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                                    child: Text(
                                      "UGX 5000",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                      ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 50,
                            width: 0.27 * deviceWidth,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                    width: 2.0,
                                    color: Color.fromARGB(255, 6, 68, 119))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.time_to_leave_outlined,
                                  color: Colors.grey[800],
                                ),
                                Text(
                                  "10 Slots",
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
                                    color: Color.fromARGB(255, 6, 68, 119))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  color: Colors.grey[800],
                                ),
                                Text(
                                  "8:00 am",
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
                                    color: Color.fromARGB(255, 6, 68, 119))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.grey[800],
                                ),
                                Text(
                                  "2.3 km",
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
                      child: Flexible(
                          child: Text(
                        "This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. This is a parking lot. ",
                        style: TextStyle(color: Colors.grey[700]),
                      )),
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
                        children: [
                          Text("• CCTV"),
                          Text("• Valet Parking"),
                          Text("• Security"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            child: Container(
                              height: 50,
                              width: 0.42 * deviceWidth,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.blue[600],
                                borderRadius: BorderRadius.circular(25)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                child: Text(
                                  "View Lot",
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                  ),
                              ),
                            ),
                          ),
                          InkWell(
                            child: Container(
                              height: 50,
                              width: 0.42 * deviceWidth,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.green[600],
                                borderRadius: BorderRadius.circular(25)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                child: Text(
                                  "Reserve slot",
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
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
            )
          ],
        ),
      ],
    ));
  }
}