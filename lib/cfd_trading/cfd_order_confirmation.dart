import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ten_ten_one/cfd_trading/cfd_trading.dart';
import 'package:ten_ten_one/models/cfd_trading_state.dart';
import 'package:ten_ten_one/models/order.dart';
import 'package:ten_ten_one/utilities/tto_table.dart';

class CfdOrderConfirmation extends StatelessWidget {
  static const subRouteName = 'cfd-order-confirmation';

  const CfdOrderConfirmation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.decimalPattern('en');

    final cfdTradingState = context.read<CfdTradingState>();
    final order = cfdTradingState.getDraftOrder();

    final openPrice = formatter.format(order.openPrice);
    final liquidationPrice = formatter.format(order.liquidationPrice);
    final estimatedFees = order.estimatedFees.toStringAsFixed(10);
    final margin = order.margin.toStringAsFixed(10);
    final unrealizedPL = order.unrealizedPL.toStringAsFixed(10);
    final expiry = DateFormat('dd.MM.yy-kk:mm').format(order.expiry);
    final quantity = order.quantity.toString();
    final tradingPair = order.tradingPair.toString().split('.')[1].toUpperCase();

    return Scaffold(
        appBar: AppBar(title: const Text('CFD Order Confirmation')),
        body: Container(
          padding: const EdgeInsets.only(top: 15, right: 30, left: 30),
          child: Column(children: [
            Center(child: Text(tradingPair, style: const TextStyle(fontSize: 24))),
            const SizedBox(height: 25),
            TtoTable([
              TtoRow(label: 'Position', value: order.position == Position.long ? 'Long' : 'Short'),
              TtoRow(label: 'Open Price', value: '\$ $openPrice'),
              TtoRow(label: 'Unrealized P/L', value: unrealizedPL, icon: Icons.currency_bitcoin),
              TtoRow(label: 'Margin', value: margin, icon: Icons.currency_bitcoin),
              TtoRow(label: 'Expiry', value: expiry),
              TtoRow(label: 'Liquidation Price', value: '\$ $liquidationPrice'),
              TtoRow(label: 'Quantity', value: quantity),
              TtoRow(label: 'Estimated fees', value: estimatedFees, icon: Icons.currency_bitcoin)
            ]),
            const SizedBox(height: 20),
            Text(
                'This will open a position and lock up $margin BTC in a channel. Would you like to proceed',
                style: const TextStyle(fontSize: 20)),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 20, 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              // todo send order to maker.
                              cfdTradingState.finishOrder();
                              context.go(CfdTrading.route);
                            },
                            child: const Text('Confirm'))
                      ],
                    ),
                  ],
                ),
              ),
            )
          ]),
        ));
  }
}
