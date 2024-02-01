import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  TextEditingController _search = TextEditingController();
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 47, 1),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25)
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        child: Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 30,
                            color:Color.fromARGB(255, 218, 218, 218),),
                            SizedBox(
                              width: 16,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Location",
                                style:TextStyle(color:Color.fromARGB(255, 218, 218, 218))),
                                Text(
                                  "Kampala, Uganda",
                                  style: TextStyle(fontWeight: FontWeight.bold,
                                  color:Color.fromARGB(255, 218, 218, 218)),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height:30,),
                      TextFormField(
                        controller: _search,
                        decoration:InputDecoration(
                          hintText: "Search Parking",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor:Color.fromARGB(255, 218, 218, 218),
                        )
                      ),
                      SizedBox(height:30,),
                    ],
                  ),
                ),
              ),
          ],
        ),
        ),
      
    );
  }
}
