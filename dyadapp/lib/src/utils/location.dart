import 'package:geolocator/geolocator.dart';
import 'package:dyadapp/src/utils/user_session.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:dart_ipify/dart_ipify.dart';
import 'dart:convert';

class LocationDyad {
  static var currentAddress;
  static var latitude;
  static var longitude;
  static var enabled;
  getUserPosition() async {
    //If location services are enabled, use method _getCurrentLocation to get what to display on the map
    final Position currentPosition = await _getCurrentLocation();
    //To be used in the map screen
    if(enabled == true){
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);
      Placemark place = placemarks[0];
      if (place.locality != null) {
        currentAddress = place.locality;
      }
      latitude = currentPosition.latitude;
      longitude = currentPosition.longitude;
    }
    //If location is disabled, use method fetchLocationByIp to get what to display on map. Uses the public geo-ip instead.
    else{
      final Map<String, dynamic> temp = await fetchLocationByIp();
      if(temp != {}){
        currentAddress = temp['city'];
        latitude = temp['lat'];
        longitude = temp['lon'];
      }
    }
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
          'Location permissions are permanently denied, we cannot request permissions. Will instead use Geo-IP which is public.');
    }

    //All permissions good, get location
    enabled = true;
    return await Geolocator.getCurrentPosition();
  }

  Future<Map<String, dynamic>> fetchLocationByIp() async{
    //Ip-api uses public ip to get location, which is public
    final ipv4 = await Ipify.ipv4();
    final response = await http.get(Uri.parse('http://ip-api.com/json/' + ipv4));

    if (response.statusCode == 200){
      Map<String, dynamic> temp = jsonDecode(response.body);
      return temp;
    }
    else{
      return {};
    }
  }
}
