import 'package:go_router/go_router.dart';
import 'package:icecream/com/widget/temp.dart';
import 'package:icecream/home/screen/c_home.dart';
import 'package:icecream/home/screen/p_home.dart';

final router = GoRouter(
  routes: [
    GoRoute(
        path: '/',
        builder: (context, state) {
          return Temp();
        },
        routes: [
          GoRoute(
            path: 'parents',
            builder: (context, state) {
              return PHome();
            },
            routes: [

            ]
          ),
          GoRoute(
            path: 'children',
            builder: (context, state) {
              return CHome();
            },
          ),
        ]),
  ],
);
