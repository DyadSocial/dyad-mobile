// author: Vincent
// Default main app but we add an override for the HTTP client

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:dyadapp/src/app.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
  }
  HttpOverrides.global = new MyHttpOverrides();
  setHashUrlStrategy();
  // Update the factory to use Ffi Implementation
  databaseFactory = databaseFactoryFfi;
  runApp(const Dyad());
}
