import 'dart:async';
import 'dart:convert';
import 'package:easypark/Presentation/slotGuidelines.dart';
import 'package:easypark/Presentation/slotMap.dart';
import 'package:easypark/Services/Reservation.dart';
import 'package:easypark/models/ParkingDetails.dart';
import 'package:easypark/models/Slot.dart';
import 'package:flutter/material.dart';
import "../variables.dart";
import "package:http/http.dart" as http;

class ParkingSlots extends StatefulWidget {
  final String uuid;

  const ParkingSlots({super.key, required this.uuid});

  @override
  State<ParkingSlots> createState() => ParkingSlotsState();
}

class ParkingSlotsState extends State<ParkingSlots> {
  bool loading = true;

  List slots = [];

  Slot? selected;

  ParkingDetails parking_lot = ParkingDetails();

  late Timer _timer;

  Future<ParkingDetails> fetchDetails() async {
    var response = await http.get(
        Uri.parse("http://$server:8000/parking_lot_details/${widget.uuid}/"));
    var json = jsonDecode(response.body);
    return ParkingDetails.fromJson(json);
  }

  List displaySlots(start, end) {
    List slots = [];
    try {
      slots = parking_lot.slots!.sublist(start, end);
    } on RangeError {
      int len = parking_lot.slots!.length;
      slots = parking_lot.slots!.sublist(start, len);
    }
    return slots;
  }

  List<Widget> levels(value) {
    double deviceWidth = MediaQuery.of(context).size.width;

    List<Widget> resp = [];
    for (int i = 1; i <= value; i++) {
      resp.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: InkWell(
            onTap: () => {
              setState(() {
                slots = displaySlots(
                    i == 1
                        ? 0
                        : i == 2
                            ? 30
                            : 60,
                    i == 1
                        ? 30
                        : i == 2
                            ? 60
                            : 90);
              })
            },
            child: Container(
                alignment: Alignment.center,
                width: 0.28 * deviceWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.green[600],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Level ${i}",
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          ),
        ),
      );
    }
    return resp;
  }

  Future<void> handleReservation() async {
    int status_code = await Reservation.reserve_slot(selected!.uuid, user_id);
    if (status_code == 200) {
      // success and navigate
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Reservation Successfully booked",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      ));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
              parking_lot.structured! ? SlotGuidelines(uuid: selected!.uuid!) : SlotMap()));
    } else {
      // show error
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.red[400],
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Error",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.warning_amber_rounded, color: Colors.white)
                ],
              ),
              content: const Text(
                "This slot is nolonger available!",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "OK",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))
              ],
            );
          });
    }
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
          parking_lot = value;
          slots = displaySlots(0, 30);
        });
      });
    });

    // initial fetching
    fetchDetails().then((value) {
      setState(() {
        parking_lot = value;
        loading = false;
        slots = displaySlots(0, 30);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(parking_lot.name ?? "Parking Lot"),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                "Opening Time",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(parking_lot.open!),
                              const Text(
                                "Rate Per Hour",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("UGX ${parking_lot.rate!}"),
                              const Text(
                                "Total Occupancy",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(parking_lot.occupancy!),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Closing Time",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(parking_lot.close!),
                              const Text(
                                "Services Provided",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: parking_lot.services_provided!
                                    .map((service) => Text(service))
                                    .toList(),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: levels(parking_lot.number_of_stories!)),
                          SizedBox(height: 10),
                          Expanded(
                              child: Container(
                            child: GridView.count(
                              crossAxisCount: 10,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              childAspectRatio: (2 / 5),
                              scrollDirection: Axis.horizontal,
                              children: slots
                                  .map((slot) => InkWell(
                                        onTap: (slot.occupied || slot.reserved)
                                            ? null
                                            : () {
                                                setState(() {
                                                  selected = slot;
                                                });
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Dialog(
                                                        child: Container(
                                                          height: 150,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                Text(
                                                                  selected!
                                                                      .slot_number!,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          24,
                                                                      color: Colors
                                                                              .grey[
                                                                          800]),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap: () =>
                                                                          Navigator.pop(
                                                                              context),
                                                                      child:
                                                                          Container(
                                                                        width: 0.30 *
                                                                            deviceWidth,
                                                                        alignment:
                                                                            Alignment.center,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            color: Colors.red[400]),
                                                                        child:
                                                                            const Padding(
                                                                          padding:
                                                                              EdgeInsets.all(10.0),
                                                                          child:
                                                                              Text(
                                                                            "Cancel",
                                                                            style:
                                                                                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () =>
                                                                              {
                                                                        print(
                                                                            "Booking slot ${selected!.slot_number}..."),
                                                                        Navigator.pop(
                                                                            context),
                                                                        // handleReservation(),
                                                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SlotGuidelines(uuid: selected!.uuid!)))
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width: 0.30 *
                                                                            deviceWidth,
                                                                        alignment:
                                                                            Alignment.center,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            color: Colors.green[500]),
                                                                        child:
                                                                            const Padding(
                                                                          padding:
                                                                              EdgeInsets.all(10.0),
                                                                          child:
                                                                              Text(
                                                                            "Reserve",
                                                                            style:
                                                                                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                                color: slot == selected
                                                    ? Color.fromARGB(
                                                        129, 0, 0, 0)
                                                    : Colors.grey[800]),
                                            alignment: Alignment.center,
                                            child: (slot.occupied ||
                                                    slot.reserved)
                                                ? Transform.scale(
                                                    scale: 0.8,
                                                    child: Image.asset(
                                                        "assets/car.png"))
                                                : Text(
                                                    slot.slot_number,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                      ))
                                  .toList(),
                            ),
                          )),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ),
    );
  }
}
