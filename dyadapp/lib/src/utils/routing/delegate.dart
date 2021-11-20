// Copyright 2014 The Chromium Authors. All rights reserved. See LICENSE file.

/*
Class SimpleRouterDelegate
Description: Responds to push and pop route intents and notifies router to 
rebuild. Also acts as the builder for Router widget and builds a navigating
widget (class Navigator).
*/

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'parsed_route.dart';
import 'route_state.dart';

class SimpleRouterDelegate extends RouterDelegate<ParsedRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<ParsedRoute> {
  final RouteState routeState;
  final WidgetBuilder builder;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  SimpleRouterDelegate({
    required this.routeState,
    required this.builder,
    required this.navigatorKey,
  }) {
    routeState.addListener(notifyListeners);
  }

  @override
  Widget build(BuildContext context) => builder(context);

  @override
  Future<void> setNewRoutePath(ParsedRoute configuration) async {
    routeState.route = configuration;
    return SynchronousFuture(null);
  }

  @override
  ParsedRoute get currentConfiguration => routeState.route;

  @override
  void dispose() {
    routeState.removeListener(notifyListeners);
    routeState.dispose();
    super.dispose();
  }
}
