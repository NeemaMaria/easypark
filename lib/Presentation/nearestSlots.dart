import 'dart:async';
import 'dart:convert';
import 'package:card_swiper/card_swiper.dart';
import 'package:easypark/Presentation/slotGuidelines.dart';
import 'package:easypark/Presentation/slotMap.dart';
import 'package:easypark/Services/Reservation.dart';
import 'package:easypark/models/Slot.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import "../variables.dart";

class NearestSlots extends StatefulWidget {
  final String uuid;
  final bool structured;

  const NearestSlots({super.key, required this.uuid, required this.structured});

  @override
  State<NearestSlots> createState() => _NearestSlotsState();
}

class _NearestSlotsState extends State<NearestSlots> {
  List<Slot> parking_slots = [];

  Slot? selected;

  late Timer _timer;

  Future<List<Slot>> fetchSlots() async {
    var response = await http.get(
        Uri.parse("http://$server:8000/nearest_open_slots/${widget.uuid}/"));
    List json = jsonDecode(response.body) as List;
    return json.map((slot) => Slot.fromJson(slot)).toList();
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
              widget.structured ? SlotGuidelines(uuid: selected!.uuid!) : SlotMap()));
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
      fetchSlots().then((value) {
        setState(() {
          parking_slots = value;
        });
      });
    });

    fetchSlots().then((value) {
      setState(() {
        parking_slots = value;
        selected = parking_slots[0];
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
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Nearest Slots"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Swiper(
          onIndexChanged: (index) {
            setState(() {
              selected = parking_slots[index];
            });
          },
          itemBuilder: (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[800],
              ),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.0),
                    Container(
                      height: 10,
                      color: Colors.white,
                    ),
                    SizedBox(height: 20),
                    Text(
                      parking_slots[index].slot_number!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Container(
                      height: 100,
                      child: Image.asset("assets/logo.png"),
                    ),
                    Expanded(child: SizedBox()),
                    InkWell(
                      onTap: () {
                        handleReservation();
                        print("Booking slot ${selected!.slot_number}...");
                      },
                      child: Container(
                        width: 0.3 * deviceWidth,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.green[500],
                          borderRadius: BorderRadius.circular(25)
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Reserve",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                ),
            );
          },
          loop: false,
          itemCount: parking_slots.length,
          viewportFraction: 0.8,
          scale: 0.9,
        ),
      ),
    );
  }
}
