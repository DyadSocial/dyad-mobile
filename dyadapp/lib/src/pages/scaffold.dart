import 'package:flutter/material.dart';
import 'package:adaptive_navigation/adaptive_navigation.dart';

import 'package:dyadapp/src/routing.dart';
import 'package:dyadapp/src/widgets/fade_transition_page.dart';
import 'package:dyadapp/src/data.dart';
import 'package:dyadapp/src/pages/feed.dart';
import 'package:dyadapp/src/pages/inbox.dart';
import 'package:quiver/collection.dart';
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
            routeState.go('/feed/all');
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
    if (pathTemplate == '/feed/all') return 0;
    if (pathTemplate == '/feed/self') return 1;
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
