// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kotha/model/balance/user_balance_model.dart';
import 'package:kotha/model/balance/withdraw_model.dart';

import '../../model/constance/constant.dart';
import '../../model/local_db/user_data.dart';

class BalanceNotifier extends ChangeNotifier {
  final String baseUrl = "https://api.porichoy.online/v1";
  Dio dio = Dio();
  UserBalanceModel userBalanceModel = UserBalanceModel();
  WithdrawHistoryModel withdrawHistoryModel = WithdrawHistoryModel();

  Future<Response> postData(String url, dynamic data, String token) => dio.post(
        url,
        data: data,
        options: Options(
          contentType: Headers.jsonContentType,
          sendTimeout: const Duration(milliseconds: 10000),
          receiveTimeout: const Duration(milliseconds: 10000),
          headers: {"Authorization": "Bearer $token"},
        ),
      );

  Future<Response> getData(String url, String token) => dio.get(
        url,
        options: Options(
          sendTimeout: const Duration(milliseconds: 10000),
          receiveTimeout: const Duration(milliseconds: 10000),
          headers: {"Authorization": "Bearer $token"},
        ),
      );

  Future<Response> deleteData(String url, dynamic data, String token) =>
      dio.delete(
        url,
        data: data,
        options: Options(
          sendTimeout: const Duration(milliseconds: 10000),
          receiveTimeout: const Duration(milliseconds: 10000),
          headers: {"Authorization": "Bearer $token"},
        ),
      );

  getUserBalance() async {
    final token = await getAccessToken();
    if (token != null) {
      try {
        final token = await UserData.getAccessToken();
        final response = await getData("$baseUrl/balance/", token);
        if (response.statusCode == 200) {
          userBalanceModel = UserBalanceModel.fromJson(response.data);
        }
      } on DioError catch (e) {
        if (e.type == DioErrorType.connectionTimeout ||
            e.type == DioErrorType.receiveTimeout) {
          print('Timeout error');
        } else if (e.type == DioErrorType.badResponse) {
          print('Response error: ${e.response?.statusCode}');
          if (e.response?.statusCode == 400) {
            userBalanceModel = UserBalanceModel.fromJson(e.response!.data);
          }
        } else if (e.type == DioErrorType.cancel) {
          print('Request cancelled');
        } else {
          print('Other error: $e');
        }
      }
    }
    return null;
  }

  withdrawBalance(dynamic data) async {
    final token = await getAccessToken();
    if (token != null) {
      try {
        final token = await UserData.getAccessToken();
        final response =
            await postData("$baseUrl/balance/withdraw_otp/", data, token);
        if (response.statusCode == 200) {
          return {
            "message": response.data["message"],
            "success": response.data["success"]
          };
        }
      } on DioError catch (e) {
        if (e.type == DioErrorType.connectionTimeout ||
            e.type == DioErrorType.receiveTimeout) {
          print('Timeout error');
        } else if (e.type == DioErrorType.badResponse) {
          print('Response error: ${e.response?.statusCode}');
          if (e.response?.statusCode == 400) {
            return {
              "message": e.response!.data["message"],
              "success": e.response!.data["success"]
            };
          }
        } else if (e.type == DioErrorType.cancel) {
          print('Request cancelled');
        } else {
          print('Other error: $e');
        }
      }
    }
    return null;
  }

  //}/balance/withdraw_verify

  validateWithdrawBalance(dynamic data) async {
    final token = await getAccessToken();
    if (token != null) {
      try {
        final token = await UserData.getAccessToken();
        final response =
            await postData("$baseUrl/balance/withdraw_verify", data, token);
        if (response.statusCode == 200) {
          return {
            "message": response.data["message"],
            "success": response.data["success"]
          };
        }
      } on DioError catch (e) {
        if (e.type == DioErrorType.connectionTimeout ||
            e.type == DioErrorType.receiveTimeout) {
          print('Timeout error');
        } else if (e.type == DioErrorType.badResponse) {
          print('Response error: ${e.response?.statusCode}');
          if (e.response?.statusCode == 400) {
            return {
              "message": e.response!.data["message"],
              "success": e.response!.data["success"]
            };
          }
        } else if (e.type == DioErrorType.cancel) {
          print('Request cancelled');
        } else {
          print('Other error: $e');
        }
      }
    }
    return null;
  }

//withdraw history
  getWithdrawHistory() async {
    final token = await getAccessToken();
    if (token != null) {
      try {
        final token = await UserData.getAccessToken();
        final response = await getData("$baseUrl/balance/withdraws", token);
        if (response.statusCode == 200) {
          withdrawHistoryModel = WithdrawHistoryModel.fromJson(response.data);
          notifyListeners();
        }
      } on DioError catch (e) {
        if (e.type == DioErrorType.connectionTimeout ||
            e.type == DioErrorType.receiveTimeout) {
          print('Timeout error');
        } else if (e.type == DioErrorType.badResponse) {
          print('Response error: ${e.response?.statusCode}');
          if (e.response?.statusCode == 400) {
            withdrawHistoryModel =
                WithdrawHistoryModel.fromJson(e.response!.data);
            notifyListeners();
          }
        } else if (e.type == DioErrorType.cancel) {
          print('Request cancelled');
        } else {
          print('Other error: $e');
        }
      }
    }
    return null;
  }
}

final balanceProvider = ChangeNotifierProvider<BalanceNotifier>((ref) {
  return BalanceNotifier();
});
