// Authors: Jake and Vincent
// Shows a map centered on current city and active users
// Jake did the map and Vincent did the Active users
// Also pushes the new profile screen if the current user doesn't have a profile

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dyadapp/src/utils/user_session.dart';
import 'package:dyadapp/src/utils/location.dart';
import 'dart:async';

import 'package:provider/provider.dart';

import '../utils/api_provider.dart';
import '../utils/network_handler.dart';
import 'newprofile.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  //Default latitude and longitude to display if location services are disabled and geo ip doesn't work; Rare
  static double latitude = 25.0;
  static double longitude = 25.0;
  static late Timer mapRefresh;
  int weeklyActiveUsers = 0;

  //Initial camera load, will be random position. Ideally, this won't happen because we are using Futurebuilder
  static CameraPosition _InitialPosition = CameraPosition(
      target: LatLng(latitude, longitude), zoom: 12.0, tilt: 15, bearing: 0);

  // Get the user's username and if they don't have push new profile screen
  @override
  initState() {
    //Map refreshes every minute
    () async {
      var username = await UserSession().get("username");
      var userProfile = await APIProvider.getUserProfile(username);
      if (userProfile.isEmpty) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => NewProfileScreen()));
      }
    }();
    // Set a timer to refresh the map periodically
    mapRefresh = Timer.periodic(Duration(seconds: 30), (timer) {
      getPos();
    });
  }

  //Default circle around location
  Set<Circle> circles = Set.from(
    [
      Circle(
        circleId: CircleId('current'),
        center: LatLng(latitude, longitude),
        radius: 6000,
        fillColor: Colors.blue.shade100.withOpacity(0.5),
        strokeColor: Colors.blue.shade100.withOpacity(0.1),
      ),
    ],
  );

  //Asynchronous function to get the current city from location.dart, then draw a circle around it.
  getPos() async {
    //await Future.delayed(const Duration(seconds: 5), (){});
    await LocationDyad().getUserPosition();
    //Dyad only stores the city, instead of the latitude and longitude or direct location of the user
    await UserSession().set("city", LocationDyad.currentAddress);
    _MapScreenState.latitude = LocationDyad.latitude;
    _MapScreenState.longitude = LocationDyad.longitude;
    //Redraw the circle; Purely for user visual, any user within the city displayed at top of screen will see your posts and vice versa
    circles = Set.from(
      [
        Circle(
          circleId: CircleId('current'),
          center: LatLng(latitude, longitude),
          radius: 6000,
          fillColor: Colors.blue.shade100.withOpacity(0.5),
          strokeColor: Colors.blue.shade100.withOpacity(0.1),
        ),
      ],
    );
    return "success";
  }

  //Refresh button will call this and bring user zoomed back out to their general location
  Future<void> _toCurrentLocation() async {
    //Get location again
    getPos();
    final GoogleMapController controller = await _controller.future;
    //Move camera to updated position after getPos call
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 12.0,
        tilt: 15,
        bearing: 0)));
  }

  //Button with question mark for telling users what they are looking at; Floating Alert Dialog
  Future<void> showMapDialog() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("What is this?"),
            content:
                Text("This map tells you where you are sourcing posts from."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () => {Navigator.pop(context)},
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //Use future builder to show the loading screen while location information is grabbed. See future: getPos(), is waiting for this to complete
    return Consumer<LocationDyad>(
      builder: (context, locationDyad, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 70,
          title: Center(
              child: Column(children: [
            Text("Dyad",
                style: TextStyle(fontSize: 30, color: Color(0xFFECEFF4))),
            FutureBuilder<dynamic>(
                initialData: "Unknown",
                future: UserSession().get("city"),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return snapshot.hasData
                      ? Text(snapshot.data ?? "Error getting location",
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFFECEFF4)))
                      : Text('Loading..',
                          style: TextStyle(
                              fontSize: 14, color: Color(0xFFE5E9F0)));
                }),
            FutureBuilder<int>(
                future: grpcClient().runGetActiveUsers(),
                initialData: 0,
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return snapshot.data == 0
                        ? Text("Querying active users..",
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFFECEFF4)))
                        : Text("${snapshot.data} recently active",
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFFECEFF4)));
                  else
                    return SizedBox(height: 1);
                }),
            SizedBox(height: 10)
          ])),
        ),
        // Show a loading screen while we get the currentPos
        body: (latitude == 0 || latitude == 25.0)
            ? FutureBuilder<dynamic>(
                future: getPos(),
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    //If getPos returns with data, then create GoogleMap instance
                    return GoogleMap(
                      initialCameraPosition: _InitialPosition,
                      scrollGesturesEnabled: true,
                      tiltGesturesEnabled: false,
                      rotateGesturesEnabled: false,
                      zoomControlsEnabled: false,
                      zoomGesturesEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      onCameraMove: null,
                      circles: circles,
                    );
                  } else {
                    //Loading while waiting for getPos to return
                    return Center(
                        child: SizedBox(
                      child: CircularProgressIndicator(
                          backgroundColor: Colors.white),
                      height: 25.0,
                      width: 25.0,
                    ));
                  }
                },
              )
            : GoogleMap(
                initialCameraPosition: _InitialPosition,
                scrollGesturesEnabled: true,
                tiltGesturesEnabled: false,
                rotateGesturesEnabled: false,
                zoomControlsEnabled: false,
                zoomGesturesEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                onCameraMove: null,
                circles: circles,
              ),
        // Show user's information about the map and manual refresh button
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
                onPressed: () async => {_toCurrentLocation()},
                child: Icon(Icons.refresh)),
            SizedBox(height: 6),
            FloatingActionButton(
                onPressed: () async => {showMapDialog()},
                child: Icon(Icons.help))
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
