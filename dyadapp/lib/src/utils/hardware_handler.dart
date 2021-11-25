import 'package:flutter_blue/flutter_blue.dart';
import 'package:geolocator/geolocator.dart';

class HardwareHandler {
  FlutterBlue fbInstance = FlutterBlue.instance;

  void getMacs() {
    fbInstance.startScan(timeout: Duration(seconds: 10));
    // Listen to scan results
    var subscription = fbInstance.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi} mac -> ' +
            r.advertisementData.serviceUuids.join(', ').toUpperCase());
      }
    });
    fbInstance.stopScan();
  }

  Future<Position> getGps() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      return Future.error(
          'Location services are disabled. Please enable them in system settings.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions denied.');
      }
    }
    Future<Position> position = Geolocator.getCurrentPosition();
    print('Position: ${position}');
    return await position;
  }

  void pushNotification() {
    //TODO: Use firebase messaging???
    // https://medium.com/comerge/implementing-push-notifications-in-flutter-apps-aef98451e8f1
  }
}
