// author: Vincent
// Default main app but we add an override for the HTTP client

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:dyadapp/src/app.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  setHashUrlStrategy();
  runApp(const Dyad());
}
