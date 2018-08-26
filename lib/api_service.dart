import 'dart:async';
import 'dart:convert';

import 'package:bitmain/api/order.dart';
import 'package:http/http.dart';

class ApiService {
  static const _BASE_URL = "http://localhost";
  static const _ANDROID_EMULATOR_BASE_URL = "http://10.0.2.2:5001";

  Future<List<Order>> getOrders(int start, int size) async {
    final url = "$_ANDROID_EMULATOR_BASE_URL/listOrders?start=$start&size=$size";

    try {
      final response = await get(url);
      final List<dynamic> parsedJson = json.decode(response.body);

      return OrderList.fromJson(parsedJson).orders;
    } catch (exception) {
      print(exception.toString());

      return Future.error(exception);
    }
  }
}
