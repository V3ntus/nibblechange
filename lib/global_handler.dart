import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:lunchmoney/lunchmoney.dart';

class GlobalHandler extends ChangeNotifier {
  LunchMoney lunchMoney = LunchMoney("");
  User? user;

  Future<Map<String, dynamic>> login(String accessToken) async {
    lunchMoney = LunchMoney(accessToken);

    try {
      user = await lunchMoney.user.me;
    } on DioException catch (e) {
      final data = e.response?.data;
      return {
        "did_error": true,
        "message": (data is Map && data.containsKey("message")) ? data["message"] : data,
      };
    }
    return {
      "did_error": false,
      "message": "",
    };
  }
}
