import 'dart:async';

import 'package:bitmain/api/order.dart';
import 'package:bitmain/api_service.dart';
import 'package:bitmain/orders_page.dart';


class OrdersPagePresenter {

  static const _PER_PAGE = 20;
  static const _ORDERS_TO_DISPLAY = 20;

  final OrdersPageView _view;
  final _service = ApiService();

  final _orders = List<Order>();

  OrdersPagePresenter(this._view);

  void start() {
    loadOrders();
  }

  void loadOrders() async {
    print("loadOrders ${_orders.length}");
    try {
      final orders = await _service.getOrders(_orders.length, _PER_PAGE);
      onDataLoaded(orders);
      Future.delayed(Duration(seconds: 2), () =>loadOrders());
    } catch (error) {
      Future.delayed(Duration(seconds: 2), () =>loadOrders());
      _view.showError();
    }

  }

  onDataLoaded(List<Order> orders) {
    print("onDataLoaded ${orders.length}");
    _orders.addAll(orders);

    final sellOrders = _orders.where((it) => it.type == "sell").toList();
    final buyOrders = _orders.where((it) => it.type == "buy").toList();

    //order desc
    buyOrders.sort((a, b) => b.price.compareTo(a.price));
    buyOrders.length = _ORDERS_TO_DISPLAY;

    //order asc
    sellOrders.sort((a, b) => a.price.compareTo(b.price));
    sellOrders.length = _ORDERS_TO_DISPLAY;

    _view.showData(buyOrders: buyOrders, sellOrders: sellOrders);
  }

}
