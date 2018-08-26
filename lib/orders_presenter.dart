import 'dart:async';

import 'package:bitmain/api/order.dart';
import 'package:bitmain/api_service.dart';
import 'package:bitmain/orders_page.dart';

class OrdersPagePresenter {
  static const _PER_PAGE = 20;
  static const _ORDERS_TO_DISPLAY = 30;
  static const _POLL_DELAY_SECONDS = 2;

  final OrdersPageView _view;
  final _service = ApiService();

  final _orders = List<Order>();

  OrdersPagePresenter(this._view);

  void start() {
    loadOrders();
  }

  void loadOrders() async {
    try {
      final orders = await _service.getOrders(_orders.length, _PER_PAGE);
      onDataLoaded(orders);
      loadDataDelayed();
    } catch (error) {
      _view.showError();
      loadDataDelayed();
    }
  }

  void loadDataDelayed() => Future.delayed(Duration(seconds: _POLL_DELAY_SECONDS), () => loadOrders());


  onDataLoaded(List<Order> orders) {
    _orders.addAll(orders);

    final sellOrders = _orders.where((it) => it.type == "sell").toList();
    final buyOrders = _orders.where((it) => it.type == "buy").toList();

    //order desc
    buyOrders.sort(nullSafeSort);
    trimList(buyOrders, _ORDERS_TO_DISPLAY);

    //order asc
    sellOrders.sort((a, b) => nullSafeSort(b, a));
    trimList(sellOrders, _ORDERS_TO_DISPLAY);

    _view.showData(buyOrders: buyOrders, sellOrders: sellOrders);
  }

  void trimList(List<Order> list, int length) {
    if (list.length > length) {
      list.length = length;
    }
  }

  int nullSafeSort(a, b) {
    if (a == null || b == null) {
      return 0;
    } else {
      return b.price - a.price;
    }
  }

}
