import 'package:bitmain/api/order.dart';
import 'package:bitmain/orders_presenter.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  @override
  OrdersPageState createState() => OrdersPageState();
}

class ViewModel {}
class Loading extends ViewModel {}
class Error extends ViewModel {}
class Data extends ViewModel {
  final List<Order> buyOrders;
  final List<Order> sellOrders;

  Data({this.buyOrders, this.sellOrders});
}



class OrdersPageState extends State<OrdersPage> {
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

  Widget getDataView(Data data)  =>
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        getListView(data.buyOrders, Colors.green),
        getListView(data.sellOrders, Colors.red),
      ],
    );

  Widget getListView(List<Order> orders, Color color) =>
      Flexible (
          child: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (BuildContext context, int index) =>
            getOrderWidget(context, orders[index], color),
      ), flex: 1);

  Widget getOrderWidget(BuildContext context, Order order, Color color) =>
      Container(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "${order.price}",
              style: TextStyle(fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: color),
            ),
            Text(
              "${order.quantity}",
              style: TextStyle(fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: color),
            )
          ],
        ),
      );

  Widget getErrorView() =>
      GestureDetector(
        child: Center(
          child: Text("Network error, try again later"),
        ),
//    onTap: () => _presenter.loadListPairs(),
      );

  Widget getLoadingView() => Center(child: CircularProgressIndicator());

  //endregion

}
