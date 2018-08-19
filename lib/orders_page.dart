import 'package:bitmain/api/order.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => new _OrdersPageState();
}

enum Status { LOADING, DATA, ERROR }

class _OrdersPageState extends State<OrdersPage> {
  var _status = Status.LOADING;
  List<Order> _data;

  @override
  Widget build(BuildContext context) {
    var widget;

    switch (_status) {
      case Status.LOADING:
        widget = getLoadingView();
        break;
      case Status.DATA:
        widget = getListView();
        break;
      case Status.ERROR:
        widget = getErrorView();
        break;
    }

    return Scaffold(
      appBar: AppBar(
        primary: true,
        title: Text("Orders"),
      ),
      body: widget,
    );
  }

  Widget getListView() => ListView.builder(
        itemCount: _data.length,
        itemBuilder: (BuildContext context, int index) =>
            getOrderWidget(context, _data[index]),
      );

  GestureDetector getOrderWidget(BuildContext context, Order order) {
    return GestureDetector(
        child: InkWell(
//      onTap: () => _presenter.navigateTo(context, ),
      child: new Container(
        padding: new EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "${order.price}",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              "${order.quantity}",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    ));
  }

  Widget getErrorView() => GestureDetector(
        child: Center(
          child: Text("Network error, try again later"),
        ),
//    onTap: () => _presenter.loadListPairs(),
      );

  Widget getLoadingView() => Center(child: CircularProgressIndicator());
}
