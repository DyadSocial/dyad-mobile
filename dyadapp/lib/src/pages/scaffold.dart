import 'package:flutter/material.dart';
import 'package:adaptive_navigation/adaptive_navigation.dart';

import 'package:dyadapp/src/routing.dart';
import 'package:dyadapp/src/widgets/fade_transition_page.dart';
import 'package:dyadapp/src/data.dart';
import 'package:dyadapp/src/pages/feed.dart';
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

    return Scaffold(
      body: AdaptiveNavigationScaffold(
        selectedIndex: selectedIndex,
        body: const DyadScaffoldBody(),
        onDestinationSelected: (idx) {
          if (idx == 0) {
            routeState.go('/feed');
          } else if (idx == 1) {
            routeState.go('/inbox');
          }
        },
        destinations: const [
          AdaptiveScaffoldDestination(
            title: 'Feed',
            icon: Icons.feed,
          ),
          AdaptiveScaffoldDestination(
            title: 'Inbox',
            icon: Icons.inbox,
          ),
        ],
      ),
    );
  }

  int _getSelectedIndex(String pathTemplate) {
    if (pathTemplate.startsWith('/feed')) return 0;
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

    return Navigator(
      key: navigatorKey,
      onPopPage: (route, dynamic result) => route.didPop(result),
      pages: [
        if (currentRoute.pathTemplate.startsWith('/feed'))
          const FadeTransitionPage<void>(
            key: ValueKey('feed'),
            child: FeedScreen(),
          )
        // Prevent Navigator from building with non-defined path
        else
          FadeTransitionPage<void>(
            key: const ValueKey('empty'),
            child: Container(),
          ),
      ],
    );
  }
}
