import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class lot extends StatefulWidget {
  const lot({super.key});

  @override
  State<lot> createState() => _lotState();
}
class _lotState extends State<lot> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Select Your Slot'),
        ),
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '1st Floor',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '2nd Floor',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '3rd Floor',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                Text(
                  'Entry',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(width: 10.0),
                
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Text(
                      'P6',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Selected',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(width: 10.0),
                Text(
                  'P6-06',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {},
              child: Text('Proceed with slot (P6-06)'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                minimumSize: Size(200.0, 50.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
