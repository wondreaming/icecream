import 'package:go_router/go_router.dart';
import 'package:icecream/auth/screen/c_qrcode.dart';
import 'package:icecream/auth/screen/qrscan_page.dart';
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
          return const Temp();
        },
        routes: [
          GoRoute(
              path: 'c_qrcode',
              builder: (context, state) => const QRCodePage()),
          GoRoute(path: 'qrscan_page',
              builder: (context, state) => const QRScanPage()),
          GoRoute(path: 'child', builder: (context, state) => const CHome()),
          GoRoute(
            path: 'parents',
            builder: (context, state) => const PHome(),
            routes: [
              // setting 페이지
              GoRoute(
                path: 'setting',
                name: 'setting',
                builder: (context, state) => const Setting(),
                routes: [
                  // setting 페이지의 마이페이지
                  GoRoute(
                    path: 'my_page',
                    name: 'my_page',
                    builder: (context, state) => const MyPage(),
                  ),
                  // setting 페이지의 자녀 관리 페이지
                  GoRoute(
                    path: 'children',
                    name: 'children',
                    builder: (context, state) => const ChildrenScreen(),
                    routes: [
                      // setting의 자녀 1명 페이지
                      GoRoute(
                        path: 'child',
                        name: 'child',
                        builder: (context, state) => const ChildScreen(),
                        routes: [
                          GoRoute(
                            path: 'location',
                            name: 'location',
                            builder: (context, state) => const LocationScreen(),
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
              return const CHome();
            },
          ),
        ]),
  ],
);
