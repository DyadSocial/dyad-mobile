import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:dart_ipify/dart_ipify.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

class LocationDyad extends ChangeNotifier {
  static var currentAddress;
  static var latitude;
  static var longitude;

  getUserPosition() async {
    try{
      LocationPermission permission = await Geolocator.checkPermission();
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      //Location off
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }
      permission = await Geolocator.requestPermission();
      //Check again
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
      //Always denied
      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied, we cannot request permissions. Will instead use Geo-IP which is public.');
      }
      //All permissions good, get location
      final Position currentPosition = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);
      Placemark place = placemarks[0];
      if (place.locality != null) {
        currentAddress = place.locality;
      }
      latitude = currentPosition.latitude;
      longitude = currentPosition.longitude;
      notifyListeners();
    }
    catch(e){
      final Map<String, dynamic> temp = await fetchLocationByIp();
      if (temp != {}) {
        currentAddress = temp['city'];
        latitude = temp['lat'];
        longitude = temp['lon'];
      }
      else{
        currentAddress = "ERROR";
        latitude = 25.0;
        longitude = 25.0;
      }
    }
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
