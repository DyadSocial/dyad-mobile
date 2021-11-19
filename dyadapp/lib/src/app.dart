import 'package:flutter/material.dart';

import 'utils/dyad_auth.dart';
import 'routing.dart';
import 'auth.dart';
import 'pages/navigator.dart';

class Dyad extends StatefulWidget {
  const Dyad({Key? key}) : super(key: key);

  @override
  _DyadState createState() => _DyadState();
}

class _DyadState extends State<Dyad> {
  final _auth = DyadAuth();
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final RouteState _routeState;
  late final SimpleRouterDelegate _routerDelegate;
  late final TemplateRouteParser _routeParser;

  @override
  void initState() {
    _routeParser = TemplateRouteParser(
      allowedPaths: [
        '/login',
        '/feed',
      ],
      guard: _guard,
      initialRoute: '/login',
    );

    _routeState = RouteState(_routeParser);

    _routerDelegate = SimpleRouterDelegate(
      routeState: _routeState,
      navigatorKey: _navigatorKey,
      builder: (context) => DyadNavigator(
        navigatorKey: _navigatorKey,
      ),
    );

    _auth.addListener(_handleAuthStateChanged);

    super.initState();
  }

  @override
  Widget build(BuildContext context) => RouteStateScope(
        notifier: _routeState,
        child: DyadAuthScope(
          notifier: _auth,
          child: MaterialApp.router(
            routerDelegate: _routerDelegate,
            routeInformationParser: _routeParser,
            theme: ThemeData(
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: <TargetPlatform, PageTransitionsBuilder>{
                  TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
                },
              ),
            ),
          ),
        ),
      );

  Future<ParsedRoute> _guard(ParsedRoute from) async {
    final signedIn = _auth.isSignedIn;
    final signInRoute = ParsedRoute('/signin', '/signin', {}, {});

    if (!signedIn && from != signInRoute) {
      return signInRoute;
    } else if (signedIn && from == signInRoute) {
      return ParsedRoute('/feed', '/feed', {}, {});
    }
    return from;
  }

  void _handleAuthStateChanged() {
    if (!_auth.isSignedIn) {
      _routeState.go('/signin');
    }
  }

  @override
  void dispose() {
    _auth.removeListener(_handleAuthStateChanged);
    _routeState.dispose();
    _routerDelegate.dispose();
    super.dispose();
  }
}
