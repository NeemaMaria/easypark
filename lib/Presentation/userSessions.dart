import 'dart:async';
import 'dart:convert';
import 'package:easypark/Presentation/home.dart';
import 'package:easypark/models/ParkingSession.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../variables.dart';
import 'package:http/http.dart' as http;

class UserSessions extends StatefulWidget {
  const UserSessions({super.key});

  @override
  State<UserSessions> createState() => _UserSessionsState();
}

class _UserSessionsState extends State<UserSessions> {
  late Timer _timer;

  bool is_active = false;
  List<ParkingSession> parking_sessions = [];
  ParkingSession? active_session;

  Future<List<ParkingSession>> fetchUserSessions() async {
    var tmp = await http
        .get(Uri.parse("http://$server:8000/user_sessions/$user_id/"));
    List response = jsonDecode(tmp.body) as List;
    return response
        .map((session) =>
            ParkingSession.fromJson(session as Map<String, dynamic>))
        .toList();
  }

  void show_message(status_code, message) {
    Color? bg_color;
    IconData? icon;
    String? title;
    Widget? body;
    double? height;

    double deviceHeight = MediaQuery.of(context).size.height;

    switch (status_code) {
      case 200:
        bg_color = Colors.green;
        icon = Icons.check;
        title = "Success";
        height = 0.25 * deviceHeight;
        body = Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Parking Lot",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Slot Number",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Parked On",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Amount",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message["lot"],
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  message["slot_number"],
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  message["parked_on"],
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "UGX ${message["amount_accumulated"]}",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            )
          ],
        );
        break;

      case 400:
        bg_color = Colors.red[400];
        icon = Icons.fmd_bad_outlined;
        title = "Error";
        height = 0.2 * deviceHeight;
        body = Text(
          message['detail'],
          style: TextStyle(
            color: Colors.white,
          ),
        );
        break;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: height,
              decoration: BoxDecoration(
                  color: bg_color, borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title!,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Icon(
                            icon,
                            color: Colors.white,
                            size: 25,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: body,
                    ),
                    Expanded(child: SizedBox()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "OK",
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });

    if (status_code == 200) {
      setState(() {
        is_active = false;
      });
      fetchUserSessions().then((value) {
        setState(() {
          parking_sessions = value;
        });
      });
    }
  }

  Future<void> terminate_session() async {
    var response = await http.post(Uri.parse(
        "http://$server:8000/release_slot/${active_session!.lot_uuid}/${active_session!.slot}/$user_id/"));
    var message = jsonDecode(response.body);
    show_message(response.statusCode, message);
  }

  @override
  void initState() {
    super.initState();
    // periodic fetching
    const apiCallInterval = Duration(seconds: 2);
    _timer = Timer.periodic(apiCallInterval, (Timer timer) {
      fetchUserSessions().then((value) {
        setState(() {
          parking_sessions = value;
        });
        if (parking_sessions[0].timestamp_end == null) {
          setState(() {
            is_active = true;
            active_session = parking_sessions[0];
          });
        }
      });
    });

    // initial fetching
    fetchUserSessions().then((value) {
      setState(() {
        parking_sessions = value;
      });
      if (parking_sessions[0].timestamp_end == null) {
        setState(() {
          is_active = true;
          active_session = parking_sessions[0];
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => home())),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("My Sessions"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (is_active) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Current Session",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Transform.scale(
                              scale: 1,
                              child: Image.asset("assets/active_car.png")),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                active_session!.lot,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(active_session!.slot_number),
                              Text(active_session!.parked_on.split(', ')[0]),
                              SizedBox(
                                height: 16,
                              ),
                              InkWell(
                                onTap: () => showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Terminate Session?"),
                                        content: Text(
                                            "Are you sure you want to end the current session?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text(
                                                "No",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              )),
                                          TextButton(
                                              onPressed: () => {
                                                    Navigator.pop(context),
                                                    terminate_session()
                                                  },
                                              child: Text(
                                                "Yes",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ))
                                        ],
                                      );
                                    }),
                                child: Card(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "End Session",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Session History",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Container(
                width: double.infinity,
                child: Card(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: DataTable(
                          columns: const [
                             DataColumn(
                                label: Expanded(
                              child: Text("Parking Lot"),
                            )),
                            DataColumn(
                                label: Expanded(
                              child: Text("Slot"),
                            )),
                            DataColumn(
                                label: Expanded(
                              child: Text("Amount"),
                            )),
                          ],
                          rows: parking_sessions.map((session) {
                            return DataRow(cells: [
                              DataCell(Text(session.lot)),
                              DataCell(Text(session.slot_number)),
                              session.amount_accumulated != null
                                  ? DataCell(Text(
                                      session.amount_accumulated.toString()))
                                  : DataCell(Text(
                                      "Ongoing",
                                      style: TextStyle(color: Colors.green),
                                    )),
                            ]);
                          }).toList())),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
