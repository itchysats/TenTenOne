import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ten_ten_one/models/service_model.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 60,
                  width: 60,
                  child: SvgPicture.asset("assets/10101_logo.svg"),
                ),
                const Text("One-Stop ⚡️ Wallet", style: TextStyle(fontSize: 16)),
                Text(
                  "Trading, Bets & More",
                  style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.primary),
                )
              ],
            ),
          ),
          ListTile(
            title: Text(ServiceGroup.wallet.label),
            leading: Icon(ServiceGroup.wallet.icon),
            onTap: () {
              GoRouter.of(context).go("/");
            },
          ),
          ListTile(
            title: Text(Service.trade.label),
            leading: Icon(Service.trade.icon),
            onTap: () {
              GoRouter.of(context).go(Service.trade.route);
            },
          ),
          ExpansionTile(
            title: Text(ServiceGroup.invest.label),
            leading: Icon(ServiceGroup.invest.icon),
            initiallyExpanded: true,
            children: [
              ListTile(
                title: Text(Service.dca.label),
                leading: Icon(Service.dca.icon),
                onTap: () {
                  GoRouter.of(context).go(Service.dca.route);
                },
              ),
              ListTile(
                title: Text(Service.savings.label),
                leading: Icon(Service.savings.icon),
                onTap: () {
                  GoRouter.of(context).go(Service.savings.route);
                },
              ),
            ],
          ),
          ListTile(
            title: const Text("Settings"),
            leading: const Icon(Icons.settings),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
