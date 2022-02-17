import 'dart:async';

import 'package:dyadapp/src/pages/scaffold.dart';
import 'package:flutter/material.dart';

import 'package:dyadapp/src/utils/dyad_auth.dart';
import 'package:dyadapp/src/routing.dart';
import 'package:dyadapp/src/data.dart';
import 'package:dyadapp/src/pages/login.dart';
import 'package:dyadapp/src/widgets/fade_transition_page.dart';
import 'package:dyadapp/src/utils/database_handler.dart';

import '../utils/auth_token.dart';
import 'feed.dart';

class DyadNavigator extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const DyadNavigator({
    required this.navigatorKey,
    Key? key,
  }) : super(key: key);

  @override
  _DyadNavigatorState createState() => _DyadNavigatorState();
}

class _DyadNavigatorState extends State<DyadNavigator> {
  final _signInKey = const ValueKey('Sign in');
  final _scaffoldKey = const ValueKey<String>('App scaffold');
  final _feedKey = const ValueKey<String>('Feed key');
  //final _aboutKey = const ValueKey<String>('About key');
  //final _messageKey = const ValueKey<String>('Message details screen');
  final _postDetailsKey = const ValueKey<String>('Post details screen');
  //final _profileDetailsKey = const ValueKey<String>('Profile details screen');

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    final authState = DyadAuthScope.of(context);
    final pathTemplate = routeState.route.pathTemplate;

    //Message? selectedMessage;
    if (pathTemplate == '/message/:messageId') {
      // Route to messageId message
    }

    Future<Post?>? selectedPost;
    if (pathTemplate == '/post/:postId') {
      selectedPost =
          DatabaseHandler().getPost(routeState.route.parameters['postId']);
    }

    //User? selectedProfile;
    if (pathTemplate == '/profile/:userId') {
      // Route to userId profile
    }
    return Navigator(
      key: widget.navigatorKey,
      onPopPage: (route, dynamic result) {
        if (route.settings is Page &&
            (route.settings as Page).key == _postDetailsKey) {
          routeState.go('feed');
        }
        return route.didPop(result);
      },
      pages: [
        if (routeState.route.pathTemplate == '/login')
          FadeTransitionPage<void>(
            key: _signInKey,
            child: LoginScreen(
              onSignIn: (credentials) async {
                AuthToken.getStatus();
                var signedIn = await authState.signIn(
                    credentials.userName, credentials.password);
                if (signedIn) {
                  routeState.go('/feed');
                }
              },
            ),
          )
        else ...[
          FadeTransitionPage<void>(
            key: _scaffoldKey,
            child: const DyadScaffold(),
          )
        ],
      ],
    );
  }
}
