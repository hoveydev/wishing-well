import 'package:flutter/material.dart';

const Curve defaultTransitionCurve = Curves.easeInOut;

Widget slideUpTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  const begin = Offset(0.0, 1.0);
  const end = Offset.zero;

  final tween = Tween(
    begin: begin,
    end: end,
  ).chain(CurveTween(curve: defaultTransitionCurve));

  return SlideTransition(position: animation.drive(tween), child: child);
}

Widget slideUpWithParallaxTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  const slideBegin = Offset(0.0, 1.0);
  const slideEnd = Offset.zero;

  final slideTween = Tween(
    begin: slideBegin,
    end: slideEnd,
  ).chain(CurveTween(curve: defaultTransitionCurve));

  const parallaxBegin = Offset.zero;
  const parallaxEnd = Offset(-0.15, 0.0);

  final parallaxTween = Tween(
    begin: parallaxBegin,
    end: parallaxEnd,
  ).chain(CurveTween(curve: defaultTransitionCurve));

  return SlideTransition(
    position: animation.drive(slideTween),
    child: SlideTransition(
      position: secondaryAnimation.drive(parallaxTween),
      child: child,
    ),
  );
}

Widget slideInRightTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  const slideBegin = Offset(1.0, 0.0);
  const slideEnd = Offset.zero;

  final slideTween = Tween(
    begin: slideBegin,
    end: slideEnd,
  ).chain(CurveTween(curve: defaultTransitionCurve));

  const parallaxBegin = Offset.zero;
  const parallaxEnd = Offset(-0.15, 0.0);

  final parallaxTween = Tween(
    begin: parallaxBegin,
    end: parallaxEnd,
  ).chain(CurveTween(curve: defaultTransitionCurve));

  return SlideTransition(
    position: animation.drive(slideTween),
    child: SlideTransition(
      position: secondaryAnimation.drive(parallaxTween),
      child: child,
    ),
  );
}

Widget slideDownTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  const begin = Offset.zero;
  const end = Offset(0.0, -0.15);

  final tween = Tween(
    begin: begin,
    end: end,
  ).chain(CurveTween(curve: defaultTransitionCurve));

  return SlideTransition(
    position: secondaryAnimation.drive(tween),
    child: child,
  );
}

Widget noTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) => child;
