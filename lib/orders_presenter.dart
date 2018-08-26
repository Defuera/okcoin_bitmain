import 'dart:async';
import 'dart:math';

import 'package:bitmain/api_service.dart';
import 'package:bitmain/model/order.dart';
import 'package:bitmain/orders_page.dart';

class OrdersPagePresenter {
  static const _PER_PAGE = 20;
  static const _ORDERS_TO_DISPLAY = 30;
  static const _POLL_DELAY_MILLISECONDS = 500;

  final OrdersPageView _view;
  final _service = ApiService();

  var _ordersLoaded = 0;
  final _buyOrders = List<Order>();
  final _sellOrders = List<Order>();

  OrdersPagePresenter(this._view);

  void start() {
    loadOrders();
  }

  void loadOrders() async {
    try {
      final orders = await _service.getOrders(_ordersLoaded, _PER_PAGE);
      _onDataLoaded(orders);
      _loadDataDelayed();
    } catch (error, stacktrace) {
      print(stacktrace.toString());
      _view.showError();
      _loadDataDelayed();
    }
  }

  _onDataLoaded(List<Order> orders) {
    _ordersLoaded += orders.length;

    orders.forEach((it) {
      print("new ${it.type} order: [${it.price}, ${it.quantity}]");

      switch (it.type) {
        case "buy":
          final matchingSellOrder = _sellOrders.firstWhere(
                  (sellOrder) => sellOrder.price < it.price,
                  orElse: () => null);
          if (matchingSellOrder != null) { //todo recursion needed
            _onMatchingOrders(it, matchingSellOrder);
          } else {
            _addBuyOrder(it); //order desc
          }
          break;

        case "sell":
          final matchingBuyOrder = _buyOrders.firstWhere(
                  (buyOrder) => buyOrder.price > it.price,
              orElse: () => null);
          if (matchingBuyOrder != null) { //todo recursion needed
            _onMatchingOrders(matchingBuyOrder, it);
          } else {
            _addSellOrder(it); //order desc
          }

          break;
      }
    });

    _view.showData(buyOrders: _buyOrders, sellOrders: _sellOrders);
  }

  void _onMatchingOrders(Order buyOrder, Order sellOrder) {
    final quantity = min<int>(buyOrder.quantity, sellOrder.quantity);
//    final price = (buyOrder.price - sellOrder.price) / 2 + sellOrder.price;
    print("it's a match!!!");

    _buyOrders.remove(buyOrder);
    var remainingBuyOrderQuantity = buyOrder.quantity - quantity;
    if (remainingBuyOrderQuantity > 0) {
      final updatedBuyOrder = copyOrder(order: buyOrder, quantity: remainingBuyOrderQuantity);
      _addBuyOrder(updatedBuyOrder); //order desc
    }

    _sellOrders.remove(sellOrder);
    var remainingSellOrderQuantity = sellOrder.quantity - quantity;
    if (remainingSellOrderQuantity > 0) {
      final updatedSellOrder = copyOrder(order: sellOrder, quantity: remainingSellOrderQuantity);
      _addSellOrder(updatedSellOrder); //order desc
    }
  }

  Order copyOrder({Order order, int quantity}) {
    return Order(id: order.id, type: order.type, quantity: quantity, price: order.price);
  }

  void checkForMatches(Order order, List<Order> matchQueue) {}

  //region helper functions

  void _addBuyOrder(Order updatedBuyOrder) => _addItem(updatedBuyOrder, _buyOrders, (a, b) => b.price - a.price);

  void _addSellOrder(Order updatedSellOrder) => _addItem(updatedSellOrder, _sellOrders, (a, b) => a.price - b.price);

  void _addItem(Order newOrder, List<Order> list, Function(Order a, Order b) sortFunction) {
    list.add(newOrder);
    list.sort(sortFunction);
    if (list.length > _ORDERS_TO_DISPLAY) {
      list.length = _ORDERS_TO_DISPLAY;
    }
  }

  void _loadDataDelayed() => Future.delayed(Duration(milliseconds: _POLL_DELAY_MILLISECONDS), () => loadOrders());

  //endregion

}
