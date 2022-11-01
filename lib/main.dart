import 'package:flutter/material.dart' hide Size;
import 'package:provider/provider.dart';
import 'package:ten_ten_one/cfd_trading.dart';
import 'package:ten_ten_one/dashboard.dart';
import 'package:ten_ten_one/models/balance.model.dart';
import 'package:ten_ten_one/models/seed_backup.model.dart';
import 'package:ten_ten_one/seed.dart';
import 'package:go_router/go_router.dart';

import 'bridge_generated/bridge_definitions.dart';

import 'dart:async';

import 'ffi.io.dart' if (dart.library.html) 'ffi.web.dart';

BalanceModel balanceModel = BalanceModel();
SeedBackupModel seedBackupModel = SeedBackupModel();

void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => balanceModel),
      ChangeNotifierProvider(create: (context) => seedBackupModel),
    ], child: const TenTenOneApp()));

class TenTenOneApp extends StatefulWidget {
  const TenTenOneApp({Key? key}) : super(key: key);

  @override
  State<TenTenOneApp> createState() => _TenTenOneState();
}

class _TenTenOneState extends State<TenTenOneApp> {
  @override
  void initState() {
    super.initState();
    _callInitWallet();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TenTenOne',
      theme: ThemeData(primarySwatch: Colors.teal),
      routerConfig: _router,
    );
  }

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const Dashboard();
          },
          routes: [
            GoRoute(
              path: Seed.subRouteName,
              builder: (BuildContext context, GoRouterState state) {
                return const Seed();
              },
            ),
          ]),
      GoRoute(
        path: CfdTrading.route,
        builder: (BuildContext context, GoRouterState state) {
          return const CfdTrading();
        },
      ),
    ],
  );

  Future<void> _callInitWallet() async {
    await api.initWallet(network: Network.Testnet);

    // initial sync
    _callSync();
    // consecutive syncs
    runPeriodically(_callSync);
  }

  Future<void> _callSync() async {
    final balance = await api.getBalance();
    if (mounted) setState(() => balanceModel.update(balance.confirmed));
  }
}

void runPeriodically(void Function() callback) =>
    Timer.periodic(const Duration(seconds: 20), (timer) => callback());
