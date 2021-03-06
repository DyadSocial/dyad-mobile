// Author: Vincent
// The Scaffold which encapsulates all other pages and renders them
// when the correct navbar Icon is pressed
// Also has a MultiProvider giving a hierarchical form of state management

import 'package:flutter/material.dart';
import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:dyadapp/src/pages/map.dart';
import 'package:dyadapp/src/routing.dart';
import 'package:dyadapp/src/widgets/fade_transition_page.dart';
import 'package:dyadapp/src/data.dart';
import 'package:dyadapp/src/pages/feed.dart';
import 'package:dyadapp/src/pages/inbox.dart';
import 'package:provider/provider.dart';
import 'package:quiver/collection.dart';

import '../utils/data/group.dart';
import '../utils/location.dart';
/*
Class DyadScaffold
Description: Stateless widget with build() creating a navigation bar
*/

class DyadScaffold extends StatelessWidget {
  const DyadScaffold({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    final selectedIndex = _getSelectedIndex(routeState.route.pathTemplate);

    return MultiProvider(
      providers: [
      ChangeNotifierProvider<LocationDyad>(
        create: (context) => LocationDyad()
      ),
      ChangeNotifierProvider<Group>(
        create: (context) => Group()
      ) ],
      child: Scaffold(
        body: AdaptiveNavigationScaffold(
          selectedIndex: selectedIndex,
          body: const DyadScaffoldBody(),
          onDestinationSelected: (idx) {
            if (idx == 0) {
              routeState.go('/feed/all');
            } else if (idx == 1) {
              routeState.go('/map');
            } else if (idx == 2) {
              routeState.
              go('/inbox');
            }
          },
          destinations: const [
            AdaptiveScaffoldDestination(
              title: 'Feed',
              icon: Icons.feed,
            ),
            AdaptiveScaffoldDestination(
              title: 'Map',
              icon: Icons.map,
            ),
            AdaptiveScaffoldDestination(
              title: 'Inbox',
              icon: Icons.inbox,
            ),
          ],
        ),
      ),
    );
  }

  int _getSelectedIndex(String pathTemplate) {
    print(pathTemplate);
    if (pathTemplate == '/feed/all') return 0;
    if (pathTemplate == '/map') return 1;
    if (pathTemplate == '/inbox') return 2;
    return 0;
  }
}

class DyadScaffoldBody extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const DyadScaffoldBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentRoute = RouteStateScope.of(context).route;

    return Scaffold(
      body: Navigator(
        key: navigatorKey,
        onPopPage: (route, dynamic result) => route.didPop(result),
        pages: [
          if (currentRoute.pathTemplate.startsWith('/inbox'))
            FadeTransitionPage<void>(
              key: const ValueKey('inbox'),
              child: InboxPage(),
            )
          // Prevent Navigator from building with non-defined path
          else if (currentRoute.pathTemplate.startsWith('/map'))
            FadeTransitionPage<void>(
              key: const ValueKey('map'),
              child: MapScreen(),
            )
          else
            const FadeTransitionPage<void>(
              key: ValueKey('feed'),
              child: FeedScreen(),
            )
        ],
      ),
    );
  }
}
