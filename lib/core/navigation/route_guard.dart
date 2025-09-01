// Created by Sultonbek Tulanov on 31-August 2025
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../feature/auth/presentation/bloc/auth_state_cubit.dart';

class RouteGuard {
  static String? checkAuthRedirect(BuildContext context, String currentPath) {
    final authStatusCubit = context.read<AuthStatusCubit>();
    final isLoggedIn = authStatusCubit.state;

    const publicRoutes = ['/splash', '/login', '/register'];
    const privateRoutes = ['/home'];

    if (!isLoggedIn && privateRoutes.any((route) => currentPath.startsWith(route))) {
      return '/login';
    }

    if (isLoggedIn && publicRoutes.contains(currentPath) && currentPath != '/splash') {
      return '/home';
    }

    return null;
  }
}
 
