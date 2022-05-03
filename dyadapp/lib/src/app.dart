// author: Vincent
// Main app where we register our path templates,
// provide keys to pages,
// initial models,
// main theme colors,
// and set up routing
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
  final _themeModel = ThemeModel();
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
        '/post',
        '/settings',
        '/profile',
        '/profile/:profileId',
        '/post/:postId',
        '/inbox',
        '/map'
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
          child: ThemeModelScope(
            notifier: _themeModel,
            child: Consumer(
              builder: (context, ThemeModel themeNotifier, child) {
                return DyadAuthScope(
                  notifier: _auth,
                  child: MaterialApp.router(
                      debugShowCheckedModeBanner: false,
                      routerDelegate: _routerDelegate,
                      routeInformationParser: _routeParser,
                      theme: themeNotifier.isDark
                          ? ThemeData.from(
                              colorScheme: ColorScheme(
                                  brightness: Brightness.dark,
                                  background: Color(0xFF3B4252),
                                  onBackground: Color(0xFFE5E9F0),
                                  primary: Color(0xFF88C0D0),
                                  primaryVariant: Color(0xFF88C0D0),
                                  onPrimary: Color(0xFF2E3440),
                                  error: Color(0xFFBF616A),
                                  onError: Color(0xFFECEFF4),
                                  secondary: Color(0xFF81A1C1),
                                  secondaryVariant: Color(0xFF81A1C1),
                                  onSecondary: Color(0xFF2E3440),
                                  surface: Color(0xFF5E81AC),
                                  onSurface: Color(0xFFECEFF4)))
                          : ThemeData.from(
                              colorScheme: ColorScheme(
                                  brightness: Brightness.light,
                                  background: Color(0xFFE3F2FC),
                                  onBackground: Color(0xFF5C566A),
                                  primary: Color(0xFF88C0D0),
                                  primaryVariant: Color(0xFF88C0D0),
                                  onPrimary: Color(0xFF2E3440),
                                  error: Color(0xFFBF616A),
                                  onError: Color(0xFFECEFF4),
                                  secondary: Colors.white,
                                  secondaryVariant: Color(0xFF8FBCBB),
                                  onSecondary: Color(0xFF88C0D0),
                                  surface: Color(0xFF81A1C1),
                                  onSurface: Color(0xFFECEFF4)))),
                );
              },
            ),
          ),
        ),
      );

  Future<ParsedRoute> _guard(ParsedRoute from) async {
    final signedIn = _auth.isSignedIn; //for testing while db is down
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
