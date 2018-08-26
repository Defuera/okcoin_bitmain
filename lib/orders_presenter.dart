import 'package:bitmain/api_service.dart';
import 'package:bitmain/orders_page.dart';

class OrdersPagePresenter {

  final OrdersPageState _state;
  final service = ApiService();

  OrdersPagePresenter(this._state);

  void start() {
    loadOrders();
  }

  void loadOrders() async {
    final orders = await service.getOrders(0, 100);
    final sellOrders = orders.where( (it) => it.type == "sell").toList();
    final buyOrders = orders.where( (it) => it.type == "buy").toList();
    _state.showData(buyOrders : buyOrders, sellOrders: sellOrders);
  }

}