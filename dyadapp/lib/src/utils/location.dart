import 'package:geolocator/geolocator.dart';
import 'package:dyadapp/src/utils/user_session.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class LocationDyad {
  static var currentAddress;
  static var latitude;
  static var longitude;
  static var enabled;
  getUserPosition() async {
    final Position currentPosition = await _getCurrentLocation();
    //To be used in the map screen
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude, currentPosition.longitude);
    Placemark place = placemarks[0];
    if (place.locality != null) {
      currentAddress = place.locality;
    }
    latitude = currentPosition.latitude;
    longitude = currentPosition.longitude;
  }

  Future<Position> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    //Location off
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    //Permission denied once
    if (permission == LocationPermission.denied) {
      enabled = false;
      permission = await Geolocator.requestPermission();
      //Check again
      if (permission == LocationPermission.denied) {
        enabled = false;
        return Future.error('Location permissions are denied.');
      }
    }
    //Always denied
    if (permission == LocationPermission.deniedForever) {
      enabled = false;
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    //All permissions good, get location
    enabled = true;
    return await Geolocator.getCurrentPosition();
  }
}
