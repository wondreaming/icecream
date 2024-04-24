import 'package:go_router/go_router.dart';
import 'package:icecream/com/widget/temp.dart';
import 'package:icecream/home/screen/c_home.dart';
import 'package:icecream/home/screen/p_home.dart';
import 'package:icecream/goal/screen/goal.dart';
import 'package:icecream/noti/screen/notification.dart';
import 'package:icecream/setting/screen/setting.dart';

final router = GoRouter(
  routes: [
    GoRoute(
        path: '/',
        builder: (context, state) {
          return const Temp();
        },
        routes: [
          GoRoute(
              path: 'parents',
              builder: (context, state) {
                return const PHome();
              },
              routes: [
                GoRoute(
                    path: 'goal',
                    builder: (context, state) {
                      return const Goal();
                    }),
                GoRoute(
                    path: 'notification',
                    builder: (context, state) {
                      return const Noti();
                    }),
                GoRoute(
                    path: 'setting',
                    builder: (context, state) {
                      return const Setting();
                    }),
              ]),
          GoRoute(
            path: 'children',
            builder: (context, state) {
              return const CHome();
            },
          ),
        ]),
  ],
);
