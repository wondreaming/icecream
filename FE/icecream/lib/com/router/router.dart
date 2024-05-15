import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icecream/auth/screen/c_qrcode.dart';
import 'package:icecream/auth/screen/p_login_page.dart';
import 'package:icecream/auth/screen/p_signup.dart';
import 'package:icecream/auth/screen/qrscan_page.dart';
import 'package:icecream/com/widget/temp.dart';
import 'package:icecream/home/screen/c_home.dart';
import 'package:icecream/home/screen/p_home.dart';
import 'package:icecream/provider/user_provider.dart';
import 'package:icecream/setting/provider/destination_provider.dart';
import 'package:icecream/setting/screen/child_detail_screen.dart';
import 'package:icecream/setting/screen/child_screen.dart';
import 'package:icecream/setting/screen/destination_screen.dart';
import 'package:icecream/setting/screen/map_screen.dart';
import 'package:icecream/setting/screen/my_page.dart';
import 'package:icecream/setting/screen/search_screen.dart';
import 'package:icecream/setting/screen/setting.dart';
import 'package:icecream/setting/widget/kpostal_wrapper.dart';
import 'package:kpostal/kpostal.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
bool _initialRedirectPerformed = false;

final router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/',
  redirect: (context, state) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // 자동 로그인이 완료된 후에는 리디렉션을 수행하지 않도록 함
    if (_initialRedirectPerformed) {
      return null;
    }

    // 자동 로그인 후 첫 리디렉션 처리
    if (!userProvider.isLoggedIn) {
      return '/p_login';
    } else if (userProvider.isParent) {
      _initialRedirectPerformed = true;
      return '/parents';
    } else {
      _initialRedirectPerformed = true;
      return '/child';
    }
  },
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
          GoRoute(
              path: 'p_login', builder: (context, state) => const LoginPage()),
          GoRoute(
              path: 'signup', builder: (context, state) => const SignUpPage()),
          GoRoute(
              path: 'qrscan_page',
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
                    builder: (context, state) => const ChildScreen(),
                    routes: [
                      // setting의 자녀 1명 페이지
                      GoRoute(
                        path: 'child/:user_id',
                        name: 'child',
                        builder: (context, state) {
                          final userId =
                              int.parse(state.pathParameters['user_id']!);
                          return ChildDetailScreen(
                            user_id: userId,
                          );
                        },
                        routes: [
                          GoRoute(
                            path: 'destination',
                            name: 'destination',
                            builder: (context, state) {
                              // patch에서 넘어오는 data 고려
                              final data =
                                  state.extra as Map<String, dynamic>? ?? null;
                              return DestinationScreen(
                                user_id:
                                    int.parse(state.pathParameters['user_id']!),
                                data: data,
                              );
                            },
                            routes: [
                              GoRoute(
                                path: 'query_parameter',
                                name: 'search',
                                builder: (context, state) {
                                  final user_id = int.parse(state.pathParameters['user_id']!);
                                  return SearchScreen(user_id: user_id);
                                },
                              ),
                              GoRoute(
                                path: 'map',
                                name: 'map',
                                builder: (context, state)  {
                                  final user_id = int.parse(state.pathParameters['user_id']!);
                                  return MapScreen(user_id: user_id);
                                },
                              ),
                              GoRoute(
                                path: 'kpostal',
                                name: 'kpostal',
                                builder: (context, state)  {
                                  final user_id = int.parse(state.pathParameters['user_id']!);
                                  return KpostalWrapper(user_id: user_id);
                                },
                                // builder: (context, state) => KpostalView(
                                //   callback: (Kpostal result) {
                                //     Provider.of<Destination>(context,
                                //         listen: false)
                                //         .changeTheValue(
                                //         result.address,
                                //         result.latitude!,
                                //         result.longitude!);
                                //   },
                                // ),
                              ),
                            ]
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
