import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:knome/components/dashboard_card.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'constants/constants.dart';
import 'home_screen.dart';
import 'view_garden.dart';
import 'main.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _database = FirebaseDatabase.instance.ref();

  String _temp = "";
  String _humidity = "";
  String _light = "";
  String _soil = "";
  String _vent = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _activateListeners();
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
  //Function to listen for changes in data from Firebase realtime database
  void _activateListeners() {
    //Listen for changes on temp data
    _database.child("temp/temp").onValue.listen((event) {
      final String temp = event.snapshot.value.toString();
      setState(() {
        _temp = temp;
      });
    });
    //Listen for changes on humidity data
    _database.child("humidity/humidity").onValue.listen((event) {
      final String humidity = event.snapshot.value.toString();
      setState(() {
        _humidity = humidity;
      });
    });

    //Listen for changes on soil data
    _database.child("soil/soil").onValue.listen((event) {
      final String soil = event.snapshot.value.toString();
      setState(() {
        _soil = soil;
      });
    });

    //Listen for changes on light data
    _database.child("light/light").onValue.listen((event) {
      final String light;
      if(event.snapshot.value.toString()=="off"){
        light="Off";
      }
      else{
        light="On";
      }
      setState(() {
        _light = light;
      });
    });

    //Listen for changes on ventilation data
    _database.child("ventilation/ventilation").onValue.listen((event) {
      final String vent;
      if(event.snapshot.value.toString()=="off"){
        vent="Off";
      }
      else{
        vent="On";
      }
      setState(() {
        _vent = vent;
      });
    });
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                "assets/images/tree-bg-transp.png",
                height: 180,
                width: 180,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30.0, right: 55.0),
                child: Text(
                  "HOME",
                  style: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              )
            ],
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              margin: EdgeInsets.only(top: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          child: Text(
                            "STATION 1",
                            style: kTextButtonStyle
                          ),
                        ),
                        Row(
                          //crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            DashboardCard(
                              cardName: "Temperature",
                              cardIconData: Icons.device_thermostat,
                              cardValue: "$_temp°C",
                            ),
                            DashboardCard(
                              cardName: "Soil moisture",
                              cardIconData: Icons.water_drop,
                              cardValue: "$_soil%",
                            ),
                          ],
                        ),
                        Row(
                          //crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            DashboardCard(
                              cardName: "Humidity",
                              cardIconData: Icons.cloud_sync,
                              cardValue: "$_humidity%",
                            ),
                            DashboardCard(
                              cardName: "Water level",
                              cardIconData: Icons.water,
                              cardValue: "79%",
                            ),
                          ],
                        ),
                        Row(
                          //crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            DashboardCard(
                              cardName: "Lights",
                              cardIconData: Icons.light_mode,
                              cardValue: _light,
                            ),
                            DashboardCard(
                              cardName: "Ventilation",
                              cardIconData: Icons.air,
                              cardValue: _vent,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                  //child: _widgetOptions.elementAt(_selectedIndex),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
