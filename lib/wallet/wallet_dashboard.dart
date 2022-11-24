import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:ten_ten_one/balance.dart';
import 'package:ten_ten_one/models/balance_model.dart';
import 'package:ten_ten_one/models/seed_backup_model.dart';
import 'package:ten_ten_one/models/service_model.dart';
import 'package:ten_ten_one/payment_history_change_notifier.dart';
import 'package:ten_ten_one/wallet/channel_change_notifier.dart';
import 'package:ten_ten_one/wallet/receive_on_chain.dart';
import 'package:ten_ten_one/wallet/payment_history_list_item.dart';
import 'package:ten_ten_one/wallet/seed.dart';
import 'package:ten_ten_one/wallet/service_card.dart';

import 'package:ten_ten_one/menu.dart';
import 'package:ten_ten_one/app_bar_with_balance.dart';
import 'action_card.dart';
import 'open_channel.dart';

class WalletDashboard extends StatefulWidget {
  const WalletDashboard({Key? key}) : super(key: key);

  @override
  State<WalletDashboard> createState() => _WalletDashboardState();
}

class _WalletDashboardState extends State<WalletDashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final seedBackupModel = context.watch<SeedBackupModel>();
    final bitcoinBalance = context.watch<BitcoinBalance>();
    final lightningBalance = context.watch<LightningBalance>();
    final paymentHistory = context.watch<PaymentHistory>();
    final channel = context.watch<ChannelChangeNotifier>();

    List<Widget> widgets = [
      const ServiceNavigation(),
    ];

    if (!seedBackupModel.backup) {
      widgets.add(ActionCard(CardDetails(
          route: Seed.route,
          title: "Create Wallet Backup",
          subtitle: "You have not backed up your wallet yet, make sure you create a backup!",
          icon: const Icon(Icons.warning))));
    }

    if (bitcoinBalance.amount.asSats == 0) {
      widgets.add(ActionCard(CardDetails(
          route: ReceiveOnChain.route,
          title: "Deposit Bitcoin",
          subtitle:
              "Deposit Bitcoin into your wallet to enable opening a channel for trading on Lightning",
          icon: const Icon(Icons.link))));
    }

    if (bitcoinBalance.amount.asSats != 0 && lightningBalance.amount.asSats == 0) {
      widgets.add(ActionCard(CardDetails(
        route: OpenChannel.route,
        title: "Open Channel",
        subtitle: "Open a channel to enable trading on Lightning",
        disabled: channel.isInitialising(),
        icon: channel.isInitialising()
            ? Container(
                width: 22,
                height: 22,
                padding: const EdgeInsets.all(2.0),
                child: const CircularProgressIndicator(
                  color: Colors.grey,
                  strokeWidth: 3,
                ),
              )
            : const Icon(Icons.launch),
      )));
    }

    final paymentHistoryList = ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      itemCount: paymentHistory.history.length,
      itemBuilder: (context, index) {
        return PaymentHistoryListItem(data: paymentHistory.history[index]);
      },
    );

    widgets.add(paymentHistoryList);

    const balanceSelector = BalanceSelector.both;

    return SafeArea(
      child: Scaffold(
        drawer: const Menu(),
        appBar: PreferredSize(
            child: const AppBarWithBalance(balanceSelector: balanceSelector),
            preferredSize: Size.fromHeight(balanceSelector.preferredHeight)),
        body: ListView(padding: const EdgeInsets.only(left: 20, right: 20), children: widgets),
      ),
    );
  }
}

class ServiceNavigation extends StatelessWidget {
  const ServiceNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          GestureDetector(
            onTap: () => {GoRouter.of(context).go(Service.cfd.route)},
            child: const ServiceCard(Service.cfd),
          ),
          GestureDetector(
            onTap: () => {GoRouter.of(context).go(Service.sportsbet.route)},
            child: const ServiceCard(Service.sportsbet),
          ),
          GestureDetector(
            onTap: () => {GoRouter.of(context).go(Service.exchange.route)},
            child: const ServiceCard(Service.exchange),
          ),
          GestureDetector(
            onTap: () => {GoRouter.of(context).go(Service.savings.route)},
            child: const ServiceCard(Service.savings),
          ),
        ],
      ),
    );
  }
}
