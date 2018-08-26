import 'package:bitmain/api_service.dart';
import 'package:bitmain/orders_page.dart';

const ORDERS_TO_DISPLAY = 20;

class OrdersPagePresenter {
  final OrdersPageView _view;
  final service = ApiService();

  OrdersPagePresenter(this._view);

  void start() {
    loadOrders();
  }

  void loadOrders() async {
    final orders = await service.getOrders(0, 100);
    final sellOrders = orders.where((it) => it.type == "sell").toList();
    final buyOrders = orders.where((it) => it.type == "buy").toList();

    //order desc
    buyOrders.sort((a, b) => b.price.compareTo(a.price));
    buyOrders.length = ORDERS_TO_DISPLAY;

    //order asc
    sellOrders.sort((a, b) => a.price.compareTo(b.price));
    sellOrders.length = ORDERS_TO_DISPLAY;

    _view.showData(buyOrders: buyOrders, sellOrders: sellOrders);
  }
}
