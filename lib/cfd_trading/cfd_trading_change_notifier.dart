import 'package:flutter/material.dart';
import 'package:ten_ten_one/model/order.dart';

/// Responsible for managing the state across the different Cfd Trading screens.
class CfdTradingChangeNotifier extends ChangeNotifier {
  final List<Order> _orders = [];
  List<Order> listOrders() => _orders;

  // the selected tab index needs to be managed in an app state as otherwise
  // a the order confirmation screen could not change tabs to the cfd overview
  // screen.
  int selectedIndex = 0;

  // the expanded flag is manage here to remember if the user has collapsed the
  // closed orders or not. It seems after routing the ephemeral state gets lost,
  // hence we have to manage that state here as app state.
  bool expanded = false;

  // manages the draft order state, so that the user can navigate through the app
  // and does not lose her selection when coming back. the draft order will be set
  // to null once the order has been confirmed.
  Order? draftOrder;

  void persist(Order order) {
    final index = _orders.indexWhere((o) => o.id == order.id);

    if (index >= 0) {
      _orders.removeAt(index);
    }

    _orders.add(order);

    super.notifyListeners();
  }
}
