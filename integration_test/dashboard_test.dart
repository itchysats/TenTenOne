import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ten_ten_one/balance.dart';
import 'package:ten_ten_one/dashboard.dart';
import 'package:ten_ten_one/models/balance_model.dart';
import 'package:ten_ten_one/models/seed_backup_model.dart';
import 'package:ten_ten_one/seed.dart';

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
  ],
);

Widget createDashboard(balanceModel, seedBackupModel) => MultiProvider(
        providers: [
          ChangeNotifierProvider<BalanceModel>(create: (context) => balanceModel),
          ChangeNotifierProvider<SeedBackupModel>(create: (context) => seedBackupModel)
        ],
        child: MaterialApp.router(
          routerConfig: _router,
        ));

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Dashboard widget tests', () {
    testWidgets('test if balance is rendered', (tester) async {
      await tester.pumpWidget(createDashboard(BalanceModel(), SeedBackupModel()));

      expect(find.byType(Balance), findsOneWidget);
    });

    testWidgets('test if balance gets updated', (tester) async {
      final balanceModel = BalanceModel();
      await tester.pumpWidget(createDashboard(balanceModel, SeedBackupModel()));

      Text balance = find.byKey(const Key('balance')).evaluate().first.widget as Text;
      // balance is empty on start
      expect(balance.data, '-1');
      balanceModel.update(1001);
      await tester.pumpAndSettle();

      balance = find.byKey(const Key('balance')).evaluate().first.widget as Text;
      expect(balance.data, '1,001');
    });

    testWidgets('test if seed backup warning remains after checking but without done button click',
        (tester) async {
      // this test will log an error as the wallet is not initialised. This can be ignored as the wallet
      // is not needed for that test.

      final seedBackupModel = SeedBackupModel();
      await tester.pumpWidget(createDashboard(BalanceModel(), seedBackupModel));

      expect(find.byType(BackupSeedCard), findsOneWidget);

      await tester.tap(find.byType(BackupSeedCard));
      // seed screen should be loaded
      await tester.pumpAndSettle();

      expect(find.byType(SeedWord), findsNWidgets(12));
      expect(find.byType(Checkbox), findsOneWidget);

      // pop the last navigation, meaning go back to the screen where you came from.
      final NavigatorState navigator = tester.state(find.byType(Navigator));
      navigator.pop();
      await tester.pumpAndSettle();

      expect(find.byType(BackupSeedCard), findsOneWidget);
    });

    testWidgets('test if seed backup warning disappears after checkbox is checked', (tester) async {
      // this test will log an error as the wallet is not initialised. This can be ignored as the wallet
      // is not needed for that test.
      final seedBackupModel = SeedBackupModel();
      await tester.pumpWidget(createDashboard(BalanceModel(), seedBackupModel));

      expect(find.byType(BackupSeedCard), findsOneWidget);

      await tester.tap(find.byType(BackupSeedCard));
      // seed screen should be loaded
      await tester.pumpAndSettle();

      expect(find.byType(SeedWord), findsNWidgets(12));
      expect(find.byType(Checkbox), findsOneWidget);

      await tester.tap(find.byType(Checkbox));

      expect(find.byType(ElevatedButton), findsOneWidget);
      await tester.tap(find.byType(ElevatedButton));

      expect(find.byType(BackupSeedCard), findsNothing);
    });
  });
}
