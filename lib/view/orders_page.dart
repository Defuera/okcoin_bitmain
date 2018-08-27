import 'package:bitmain/model/match.dart';
import 'package:bitmain/model/order.dart';
import 'package:bitmain/presenter/orders_presenter.dart';
import 'package:bitmain/view/orders_page_view.dart';
import 'package:bitmain/view/orders_page_view_model.dart';
import 'package:bitmain/view/tabs/match_queue_tab.dart';
import 'package:bitmain/view/tabs/orders_tab.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  @override
  OrdersPageState createState() => OrdersPageState();
}

class OrdersPageState extends State<OrdersPage> implements OrdersPageView {
  OrdersPagePresenter _presenter;
  ViewModel _viewModel = Loading();

  @override
  void initState() {
    super.initState();
    _presenter = OrdersPagePresenter(this);
    _presenter.start();
  }

  //region state manipulation

  @override
  void showLoading() {
    setState(() {
      _viewModel = Loading();
    });
  }

  @override
  void showData({List<Order> buyOrders, List<Order> sellOrders, List<OrderMatch> matchQueue}) {
    setState(() {
      _viewModel = Data(buyOrders: buyOrders, sellOrders: sellOrders, matchQueue: matchQueue);
    });
  }

  @override
  void showError() {
    setState(() {
      _viewModel = DataError();
    });
  }

  //endregion

  @override
  Widget build(BuildContext context) {
    var widget;

    if (_viewModel is Loading) {
      widget = getLoadingView();
    } else if (_viewModel is DataError) {
      widget = getErrorView();
    } else if (_viewModel is Data) {
      widget = getTabsView(_viewModel);
    }

    return DefaultTabController(
        // The number of tabs / content sections we need to display
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            primary: true,
            title: Text("Bitmain trader"),
            bottom:  TabBar(
              tabs: [
                Tab(text: "Orders"),
                Tab(text: "Trades"),
              ],
            ),
          ),
          body: widget,
        ));
  }

  //region views

  Widget getTabsView(Data data) =>
      TabBarView(
        children: [
          OrdersTab(data),
          MatchQueueTab(data.matchQueue),
        ]
      );

  Widget getErrorView() => GestureDetector(
        child: Center(
          child: Text("Network error, trying to reconnect..."),
        ),
      );

  Widget getLoadingView() => Center(child: CircularProgressIndicator());

  //endregion

}
