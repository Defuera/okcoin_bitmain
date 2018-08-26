class Order {
  final int id;
  final String type;
  final int quantity;
  final int price;

  Order({this.id, this.type, this.quantity, this.price});

  factory Order.fromJson(Map<String, dynamic> jsonMap) => Order(
      id: jsonMap["id"],
      type: jsonMap["type"],
      quantity: jsonMap["quantity"],
      price: jsonMap["price"]
  );

}


class OrderList {
  List<Order> orders;

  OrderList({this.orders});

  factory OrderList.fromJson(List<dynamic> json) =>
      OrderList(orders: (json.map((i) => Order.fromJson(i)).toList()));
}
