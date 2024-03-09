import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:lunchmoney/lunchmoney.dart';
import 'package:nibblechange/constants.dart';
import 'package:nibblechange/main.dart';

class GlobalHandler extends ChangeNotifier {
  LunchMoney lunchMoney = LunchMoney("");
  User? user;

  Future<Map<String, dynamic>> login(String accessToken) async {
    lunchMoney = LunchMoney(accessToken);

    try {
      user = await lunchMoney.user.me;

      await secureStorage.write(key: "${StorageKeys.accessToken}", value: accessToken);
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
