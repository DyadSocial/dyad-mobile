import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dyadapp/src/utils/user_session.dart';
import 'package:dyadapp/src/utils/location.dart';
import 'dart:async';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  static double latitude = 25.0;
  static double longitude = 25.0;
  late Timer mapRefresh;

  //Initial camera load, will be random position. Ideally, this won't happen because we are using Futurebuilder
  static CameraPosition _InitialPosition = CameraPosition(
      target: LatLng(latitude, longitude), zoom: 12.0, tilt: 15, bearing: 0);

  @override
  initState() {
    mapRefresh = Timer.periodic(Duration(seconds: 60), (timer) {
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
    await Future.delayed(const Duration(seconds: 5), (){});
    await LocationDyad().getUserPosition();
    UserSession().set("city", LocationDyad.currentAddress);
    _MapScreenState.latitude = LocationDyad.latitude;
    _MapScreenState.longitude = LocationDyad.longitude;
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
    getPos();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 12.0,
        tilt: 15,
        bearing: 0)));
  }

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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 60,
        title: Center(
            child: Column(children: [
              Text("Dyad", style: TextStyle(fontSize: 30, color: Color(0xFFECEFF4))),
              Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: FutureBuilder<dynamic>(
                    future: UserSession().get("city"),
                    builder:
                        (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      return snapshot.hasData
                          ? Text(snapshot.data ?? "Error getting location",
                          style: TextStyle(
                              fontSize: 14, color: Color(0xFFECEFF4)))
                          : Text('Loading..',
                          style: TextStyle(
                              fontSize: 14, color: Color(0xFFE5E9F0)));
                    }),
              )
            ])),
      ),
      body: FutureBuilder<dynamic>(
        future: getPos(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
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
            return Center(
                child: SizedBox(
              child: CircularProgressIndicator(backgroundColor: Colors.white),
              height: 25.0,
              width: 25.0,
            ));
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              onPressed: () async => {_toCurrentLocation()},
              child: Icon(Icons.refresh)),
          SizedBox(height: 6),
          FloatingActionButton(
              onPressed: () async => {showMapDialog()}, child: Icon(Icons.help))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
