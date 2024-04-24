import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icecream/com/widget/temp.dart';
import 'package:icecream/main.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return Temp();
      },
    ),
  ],
);
