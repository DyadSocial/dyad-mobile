// Author: Vincent
// extends page to push on a fade effect during transition
import 'package:flutter/material.dart';

class FadeTransitionPage<T> extends Page<T> {
  final Widget child;
  final Duration duration;

  const FadeTransitionPage({
    LocalKey? key,
    required this.child,
    this.duration = const Duration(milliseconds: 100),
  }) : super(key: key);

  @override
  Route<T> createRoute(BuildContext context) =>
      PageBasedFadeTransitionRoute<T>(this);
}

class PageBasedFadeTransitionRoute<T> extends PageRoute<T> {
  final FadeTransitionPage<T> _page;

  PageBasedFadeTransitionRoute(this._page) : super(settings: _page);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => _page.duration;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    var curveTween = CurveTween(curve: Curves.easeIn);
    return FadeTransition(
      opacity: animation.drive(curveTween),
      child: (settings as FadeTransitionPage).child,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      child;
}
