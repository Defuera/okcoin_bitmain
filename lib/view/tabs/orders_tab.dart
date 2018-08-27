import 'package:bitmain/model/order.dart';
import 'package:bitmain/view/orders_page_view_model.dart';
import 'package:flutter/material.dart';

class OrdersTab extends StatelessWidget {

  static const ORDERS_LIST_HEADERS_COUNT = 2;

  final Data _data;
  OrdersTab(this._data);

  @override
  Widget build(BuildContext context) => Padding(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          getListView("Buy", _data.buyOrders, Colors.green),
          Padding(padding: new EdgeInsets.all(16.0)),
          getListView("Sell", _data.sellOrders, Colors.red),
        ],
      ),
      padding: EdgeInsets.all(8.0));

  Widget getListView(String title, List<Order> orders, Color color) => Flexible(
      child: ListView.builder(
          itemCount: orders.length + ORDERS_LIST_HEADERS_COUNT,
          itemBuilder: (BuildContext context, int index) {
            switch (index) {
              case 0:
                return Text(title, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: color));

              case 1:
                return Padding(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Price", style: TextStyle(fontSize: 18.0)),
                        Text("Amount", style: TextStyle(fontSize: 18.0)),
                      ],
                    ),
                    padding: new EdgeInsets.symmetric(vertical: 8.0));

              default:
                return getOrderWidget(context, orders[index - ORDERS_LIST_HEADERS_COUNT], color);
            }
          }),
      flex: 1);

  Widget getOrderWidget(BuildContext context, Order order, Color color) => Container(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "${order.price}",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          "${order.quantity}",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: color),
        )
      ],
    ),
  );



}