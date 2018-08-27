import 'package:bitmain/model/match.dart';
import 'package:flutter/material.dart';

class MatchQueueTab extends StatelessWidget {

  static const HEADERS_COUNT = 1;

  final List<OrderMatch> _matchQueue;
  MatchQueueTab(this._matchQueue);

  @override
  Widget build(BuildContext context) => Padding(
      child: getListView(),
      padding: EdgeInsets.all(8.0));

  Widget getListView() => ListView.builder(
          itemCount: _matchQueue.length + HEADERS_COUNT,
          itemBuilder: (BuildContext context, int index) {
            switch (index) {
              case 0:
                return  Padding(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Date", style: TextStyle(fontSize: 18.0)),
                        Text("Price", style: TextStyle(fontSize: 18.0)),
                        Text("Volume", style: TextStyle(fontSize: 18.0)),
                      ],
                    ),
                    padding: new EdgeInsets.symmetric(vertical: 8.0));

              default:
                return getMatchWidget(context, _matchQueue[index - HEADERS_COUNT]);
            }
          });

  Widget getMatchWidget(BuildContext context, OrderMatch match) => Container(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "${match.time.hour}:${match.time.minute}:${match.time.second}",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        Text(
          "${match.price}",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        Text(
          "${match.quantity}",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        )
      ],
    ),
  );

}