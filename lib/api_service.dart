

import 'dart:async';
import 'dart:convert';

import 'package:bitmain/api/order.dart';
import 'package:http/http.dart';

const BASE_URL = "http://localhost";
const ANDROID_EMULATOR_BASE_URL = "http://10.0.2.2:5001";


class ApiService {

  Future<List<Order>> getOrders(int start, int size) async {
    final url = "$ANDROID_EMULATOR_BASE_URL/listOrders?start=$start&size=$size";

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