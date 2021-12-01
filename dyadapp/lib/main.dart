import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:dyadapp/src/app.dart';

void main() {
  setHashUrlStrategy();

  runApp(const Dyad());
}
