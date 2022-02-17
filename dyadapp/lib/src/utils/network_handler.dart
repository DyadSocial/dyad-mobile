import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:flutter/material.dart';

enum ClientState {
  advertising,
  invisible,
  off
}

class NetworkHandler extends ChangeNotifier {
  final ClientState _clientState;

  NetworkHandler(clientState) : this._clientState = clientState;

  set connectedDevices(List<Device> devices) {
    if (devices == _devices) return;
    _devices = devices;
    notifyListeners();
  }

  // Available hosts
  List<Device> _devices = [];

  // Connected hosts
  List<Device> _connectedDevices = [];
  late NearbyService nearbyService;

  // asynchronous data transfer
  late StreamSubscription subscription;
  late StreamSubscription receievedDataSubscription;
}

/*
  void init() async {
    nearbyService = NearbyService();
    String devInfo = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      devInfo = (await deviceInfo.androidInfo).model as String;
    } else if (Platform.isIOS) {
      devInfo = (await deviceInfo.iosInfo).model as String;
    }
    await nearbyService.init(
      serviceType: 'mpconn',
      deviceName: devInfo,
      strategy: Strategy.P2P_CLUSTER,
      callback: (isRunning) async {
        if (isRunning) {
          if (clientState == ClientState.advertising) {
            await nearbyService.stopAdvertisingPeer();
            await nearbyService.stopBrowsingForPeers();
            await Future.delayed(Duration(microseconds: 200));
            await nearbyService.startBrowsingForPeers();
            await nearbyService.startAdvertisingPeer();
          } else if (clientState == ClientState.invisible) {
            await nearbyService.stopBrowsingForPeers();
            await Future.delayed(Duration(microseconds: 200));
            await nearbyService.startBrowsingForPeers();
          }
        }
      }
    );
    subscription = nearbyService.stateChangedSubscription(callback: (devicesList)
    {
      devicesList.forEach((element) {
        print("deviceId: ${element.deviceId} | deviceName: ${element
            .deviceName} | state: ${element.state}");

        if (Platform.isAndroid) {
          if (element.state == SessionState.connected) {
            nearbyService.stopBrowsingForPeers();
          } else {
            nearbyService.startBrowsingForPeers();
          }
        }
      });

      setState(() {
        devices.clear();
        devices.addAll(devicesList);
        connectedDevices.clear();
        connectedDevices.addAll(devicesList
          .where((device) => device.state == SessionState.connected)
          .toList());
      });
    });

    receivedDataSubscription = nearbyService.dataReceivedSubscription(callback: (data) {
      print("dataReceivedSubscription: ${jsonEncode(data)}");
      showToast(jsonEncode(data),
          content: contex,
          axis: Axis. horizontal,
          alignment: Alignment.center,
          position: StyledToastPosition.bottom);
    });


  }

}
*/