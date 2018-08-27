import 'dart:async';
import 'dart:math';

import 'package:bitmain/model/api_service.dart';
import 'package:bitmain/model/match.dart';
import 'package:bitmain/model/order.dart';
import 'package:bitmain/view/orders_page_view.dart';

class OrdersPagePresenter {
  static const _PER_PAGE = 20;
  static const _ORDERS_TO_DISPLAY = 30;
  static const _POLL_DELAY_MILLISECONDS = 500;

  final OrdersPageView _view;
  final _service = ApiService();

  var _ordersLoaded = 0;
  final _buyOrders = List<Order>();
  final _sellOrders = List<Order>();
  final _matchQueue = List<OrderMatch>();

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
          _addBuyOrder(it);
          showData();
          checkMatchForBuyOrder(it);
          break;

        case "sell":
          _addSellOrder(it);
          showData();
          checkMatchForSellOrder(it);
          break;
      }
    });
  }

  void _onMatchingOrders(Order buyOrder, Order sellOrder) {
    print("it's a match!!!");
    final quantity = min<int>(buyOrder.quantity, sellOrder.quantity);
    final price = (buyOrder.price - sellOrder.price) / 2 + sellOrder.price;

    _updatedMatchQueue(quantity, price);
    final remainingBuyOrder = _updateList(_buyOrders, buyOrder, quantity, _addBuyOrder);
    final remainingSellOrder = _updateList(_sellOrders, sellOrder, quantity, _addSellOrder);

    //recursive match handling
    checkMatchForBuyOrder(remainingBuyOrder);
    checkMatchForSellOrder(remainingSellOrder);

    showData(delay: Duration(seconds: 1));

    if (remainingBuyOrder != null && remainingSellOrder != null) {
      throw Exception("illegal state, both orders must not remain");
    }
  }

  ///Returns order with remaining amount or null
  Order _updateList(List<Order> list, Order order, int quantity, void Function(Order order) addOrderFunc) {
    list.remove(order);
    var remainingQuantity = order.quantity - quantity;

    if (remainingQuantity > 0) {
      final updatedOrder = copyOrder(order: order, quantity: remainingQuantity);
      addOrderFunc(updatedOrder);
      return updatedOrder;
    } else {
      return null;
    }
  }

  void _updatedMatchQueue(int quantity, double price) {
    _matchQueue.add(OrderMatch(time: DateTime.now(), quantity: quantity, price: price));
    showData();
  }


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

  Order copyOrder({Order order, int quantity}) {
    return Order(id: order.id, type: order.type, quantity: quantity, price: order.price);
  }

  //todo function with side affect
  bool checkMatchForBuyOrder(Order buyOrder) {
    if (buyOrder != null) {
      final matchingOrder = _sellOrders.firstWhere((sellOrder) => sellOrder.price <= buyOrder.price, orElse: () => null);
      if (matchingOrder != null) {
        _onMatchingOrders(buyOrder, matchingOrder);
        return true;
      }
    }

    return false;
  }

  //todo function with side affect
  bool checkMatchForSellOrder(Order sellOrder) {
    if (sellOrder != null) {
      final matchingOrder = _buyOrders.firstWhere((buyOrder) => buyOrder.price >= sellOrder.price, orElse: () => null);
      if (matchingOrder != null) {
        _onMatchingOrders(matchingOrder, sellOrder);
        return true;
      }
    }

    return false;
  }

  void showData({Duration delay: const Duration(seconds: 0)}) async {
    await Future.delayed(delay);
    _view.showData(buyOrders: _buyOrders, sellOrders: _sellOrders, matchQueue: _matchQueue);
  }

  //endregion

}
