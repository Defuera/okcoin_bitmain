import 'package:bitmain/view/orders_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Bitmain orders app',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new OrdersPage(),
    );
  }
}
