import 'package:geolocator/geolocator.dart';
import 'package:dyadapp/src/utils/user_session.dart';

class LocationDyad {
  Future<Map<String, double>> getUserPosition() async {
    final Position _currentPosition = await _getCurrentLocation();
    //To be used in the map screen
    await UserSession().set("latitude", _currentPosition.latitude);
    await UserSession().set("longitude", _currentPosition.longitude);

    Map<String, double> map1 = {
      'latitude': _currentPosition.latitude,
      'longitude': _currentPosition.longitude
    };

    return map1;
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
      permission = await Geolocator.requestPermission();
      //Check again
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }
    //Always denied
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    //All permissions good, get location
    return await Geolocator.getCurrentPosition();
  }
}
