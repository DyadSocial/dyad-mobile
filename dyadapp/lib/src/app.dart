import 'package:flutter/material.dart';

import 'package:dyadapp/src/utils/dyad_auth.dart';
import 'package:dyadapp/src/routing.dart';
import 'package:dyadapp/src/pages/navigator.dart';

import 'package:dyadapp/src/utils/theme_model.dart';
import 'package:provider/provider.dart';

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
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => ThemeModel(),
        child: RouteStateScope(
          notifier: _routeState,
          child: Consumer(
            builder: (context, ThemeModel themeNotifier, child) {
              return DyadAuthScope(
                notifier: _auth,
                child: MaterialApp.router(
                  routerDelegate: _routerDelegate,
                  routeInformationParser: _routeParser,
                  theme: themeNotifier.isDark
                      ? ThemeData.from(
                          colorScheme: ColorScheme.fromSwatch(
                              primarySwatch: Colors.blueGrey),
                        )
                      : ThemeData.light(),
                  /* ThemeData(
                    pageTransitionsTheme: const PageTransitionsTheme(
                      builders: <TargetPlatform, PageTransitionsBuilder>{
                        TargetPlatform.android:
                            FadeUpwardsPageTransitionsBuilder(),
                        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                        TargetPlatform.linux:
                            FadeUpwardsPageTransitionsBuilder(),
                        TargetPlatform.windows:
                            FadeUpwardsPageTransitionsBuilder(),
                        
                      }, */
                ),
              );
            },
          ),
        ),
      );

  Future<ParsedRoute> _guard(ParsedRoute from) async {
    final signedIn = _auth.isSignedIn;
    final signInRoute = ParsedRoute('/login', '/login', {}, {});
    // from sign in page
    if (!signedIn && from.pathTemplate == '/about') {
      return from;
    }
    if (!signedIn) {
      if (from != signInRoute) {
        return signInRoute;
      } else if (from.pathTemplate == '/about') {
        return from;
      }
    } else if (signedIn && from == signInRoute) {
      return ParsedRoute('/feed', '/feed', {}, {});
    }
    return from;
  }

  void _handleAuthStateChanged() {
    if (!_auth.isSignedIn) {
      _routeState.go('/login');
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
