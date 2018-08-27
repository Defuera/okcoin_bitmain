import 'package:bitmain/model/match.dart';
import 'package:bitmain/model/order.dart';

class ViewModel {}
class Loading extends ViewModel {}
class DataError extends ViewModel {}
class Data extends ViewModel {
  final List<Order> buyOrders;
  final List<Order> sellOrders;
  final List<OrderMatch> matchQueue;

  Data({this.buyOrders, this.sellOrders, this.matchQueue});
}
