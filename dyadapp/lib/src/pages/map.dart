import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dyadapp/src/utils/location.dart';
import 'package:dyadapp/src/utils/user_session.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double longitude = 25.0;
  double latitude = 25.0;
  static final LatLng _kMapCenter = LatLng(25, 25);
  static final CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps Demo'),
      ),
      body: GoogleMap(
        initialCameraPosition: _kInitialPosition,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => {
          LocationDyad().getUserPosition(),
          print(UserSession().get("latitude")),
          print(UserSession().get("longitude")),
        },
      ),
    );
  }
}

Future<Map<String, double>> getPos() async {
  Map<String, double> map = await LocationDyad().getUserPosition();
  return map;
}
