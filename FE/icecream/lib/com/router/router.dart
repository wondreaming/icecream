import 'package:go_router/go_router.dart';
import 'package:icecream/auth/screen/c_qrcode.dart';
import 'package:icecream/com/widget/temp.dart';
import 'package:icecream/home/screen/c_home.dart';
import 'package:icecream/home/screen/p_home.dart';
import 'package:icecream/setting/screen/child_screen.dart';
import 'package:icecream/setting/screen/children_screen.dart';
import 'package:icecream/setting/screen/location_screen.dart';
import 'package:icecream/setting/screen/my_page.dart';
import 'package:icecream/setting/screen/search_screen.dart';
import 'package:icecream/setting/screen/setting.dart';

final router = GoRouter(
  routes: [
    GoRoute(
        path: '/',
        builder: (context, state) {
          return Temp();
        },
        routes: [
          GoRoute(path: 'c_qrcode', builder:(context, state) => QRCodePage()),
          GoRoute(
            path: 'parents',
            builder: (context, state) => PHome(),
            routes: [
              // setting 페이지
              GoRoute(
                path: 'setting',
                name: 'setting',
                builder: (context, state) => Setting(),
                routes: [
                  // setting 페이지의 마이페이지
                  GoRoute(
                    path: 'my_page',
                    name: 'my_page',
                    builder: (context, state) => MyPage(),
                  ),
                  // setting 페이지의 자녀 관리 페이지
                  GoRoute(
                    path: 'children',
                    name: 'children',
                    builder: (context, state) => ChildrenScreen(),
                    routes: [
                      // setting의 자녀 1명 페이지
                      GoRoute(
                        path: 'child',
                        name: 'child',
                        builder: (context, state) => ChildScreen(),
                        routes: [
                          GoRoute(
                            path: 'location',
                            name: 'location',
                            builder: (context, state) => LocationScreen(),
                            routes: [
                              GoRoute(
                                path: 'query_parameter',
                                name: 'search',
                                builder: (context, state) => SearchScreen(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
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
