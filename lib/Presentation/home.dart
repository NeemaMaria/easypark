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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 39, 39, 39),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Padding(
                    padding:const EdgeInsets.all(16.0),
                    child:Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                            Flexible(
                              child: Text(
                                "Parking at Urban Parking Shelton Street Car Park, WC2H",
                                style: TextStyle(
                                  color:Color.fromARGB(255, 218, 218, 218),
                                  fontSize: 24
                                )),
                            ),
                              Container(
                                height:40,
                                width:40,
                                decoration: BoxDecoration(
                                  color:Color.fromARGB(255, 218, 218,218),
                                  borderRadius:BorderRadius.all(Radius.circular(5)),
                                ),
                                child: const Icon(
                                  Icons.share_location,
                                  size: 30,
                                ),
                              ),
                          ]
                        ),
                        SizedBox(height:8.0),
                        Divider(
                          color: Colors.grey,
                        ),
                        SizedBox(height:10),
                        
         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Enter After",
                                  style:TextStyle(color:Colors.grey),),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "04 April at 10:30pm"
                                    ,
                                  style: TextStyle(
                                    color:Color.fromARGB(255, 218, 218, 218),
                                    fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height:8.0),
                                   Text(
                                  "Duration",
                                  style:TextStyle(color:Colors.grey),),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "24 Hours"
                                    ,
                                  style: TextStyle(
                                    color:Color.fromARGB(255, 218, 218, 218),
                                    fontWeight: FontWeight.bold),
                                  ),
                              ],
                            ),
                             Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                               Text(
                                  "Exit Before",
                                  style:TextStyle(color:Colors.grey),),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "05 April at 10:30pm"
                                    ,
                                  style: TextStyle(
                                    color:Color.fromARGB(255, 218, 218, 218),
                                    fontWeight: FontWeight.bold),),
                                    SizedBox(height:8),
                                    Text(
                                  "Booking Price",
                                  style:TextStyle(color:Colors.grey),),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "\$52.00",
                                    
                                  style: TextStyle(
                                    color:Color.fromARGB(255, 218, 218, 218),
                                    fontWeight: FontWeight.bold),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height:10,),
                        Transform.scale(
                          scaleY: 0.7,
                          child: Image.asset(
                            "assets/barcode.png"
                            ))
                      
                      ],
                    )
                  ),
                ),
              )
          ],
        ),
        ),
      
    );
  }
}
