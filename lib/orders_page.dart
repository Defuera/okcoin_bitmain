import 'package:bitmain/model/order.dart';
import 'package:bitmain/orders_presenter.dart';
import 'package:flutter/material.dart';

//region view model classes

class ViewModel {}
class Loading extends ViewModel {}
class Error extends ViewModel {}
class Data extends ViewModel {
  final List<Order> buyOrders;
  final List<Order> sellOrders;

  Data({this.buyOrders, this.sellOrders});
}

//endregion


class OrdersPageView {

  void showLoading() {}

  void showData({List<Order> buyOrders, List<Order> sellOrders}) {}

  void showError() {}

}

class OrdersPage extends StatefulWidget {
  @override
  OrdersPageState createState() => OrdersPageState();
}

class OrdersPageState extends State<OrdersPage> implements OrdersPageView {

  static const ORDERS_LIST_HEADERS_COUNT = 2;

  OrdersPagePresenter _presenter;
  ViewModel _viewModel = Loading();

  @override
  void initState() {
    super.initState();
    _presenter = OrdersPagePresenter(this);
    _presenter.start();
  }


  //region state manipulation

  void showLoading() {
    setState(() {
      _viewModel = Loading();
    });
  }

  void showData({List<Order> buyOrders, List<Order> sellOrders}) {
    setState(() {
      _viewModel = Data(buyOrders: buyOrders, sellOrders: sellOrders);
    });
  }

  void showError() {
    setState(() {
      _viewModel = Error();
    });
  }

  //endregion


  @override
  Widget build(BuildContext context) {
    var widget;

    if (_viewModel is Loading) {
      widget = getLoadingView();
    } else if (_viewModel is Error) {
      widget = getErrorView();
    } else if (_viewModel is Data) {
      widget = getDataView(_viewModel);
    }

    return Scaffold(
      appBar: AppBar(
        primary: true,
        title: Text("Orders"),
      ),
      body: widget,
    );
  }


  //region widgets

  Widget getDataView(Data data) => Padding(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          getListView("Buy", data.buyOrders, Colors.green),
          Padding(padding: new EdgeInsets.all(16.0)),
          getListView("Sell", data.sellOrders, Colors.red),
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

  Widget getErrorView() => GestureDetector(
        child: Center(
          child: Text("Network error, try again later"),
        ),
//    onTap: () => _presenter.loadListPairs(),
      );

  Widget getLoadingView() => Center(child: CircularProgressIndicator());

  //endregion

}
