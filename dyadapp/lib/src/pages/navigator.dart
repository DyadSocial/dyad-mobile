// Navigates using the parser and router delegates
// Allows us to do stuff like routeState.go('/post/{id}') and the correct
// post page will be pushed to the screen
// Author: Vincent
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
import 'inbox.dart';

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
  final _inboxKey = const ValueKey<String>('Inbox key');
  //final _aboutKey = const ValueKey<String>('About key');
  //final _messageKey = const ValueKey<String>('Message details screen');
  final _postDetailsKey = const ValueKey<String>('Post details screen');
  //final _profileDetailsKey = const ValueKey<String>('Profile details screen');

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    final authState = DyadAuthScope.of(context);
    final pathTemplate = routeState.route.pathTemplate;

    // Intended to jump to message
    //Message? selectedMessage;
    if (pathTemplate == '/message/:messageId') {
      // Route to messageId message
    }

    // if the post exists and the route is /post then get the post
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
        // If logged in successfully jump to login page
        if (routeState.route.pathTemplate == '/login')
          FadeTransitionPage<void>(
            key: _signInKey,
            child: LoginScreen(
              onSignIn: (credentials) async {
                AuthToken.getStatus();
                var signedIn = await authState.signIn(
                    credentials.userName, credentials.password);
                if (signedIn) {
                  routeState.go('/map');
                }
                return signedIn;
              },
            ),
          )
        // Jump to the scaffold to delegate page loader
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
