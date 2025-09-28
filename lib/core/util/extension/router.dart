// Created by Sultonbek Tulanov on 28-September 2025


import 'package:go_router/go_router.dart';

extension GoRouterExtension on GoRouter {
  void pushOrReplaceNamed(String name, {Object? extra}) {
    final currentRoute = routerDelegate.currentConfiguration.last.matchedLocation;
    final targetRoute = namedLocation(name);

    if (currentRoute == targetRoute) {
      pushReplacementNamed(name, extra: extra);
    } else {
      pushNamed(name, extra: extra);
    }
  }
}