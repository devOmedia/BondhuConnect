// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kotha/model/constance/constant.dart';
import 'package:kotha/model/local_db/user_data.dart';

import '../../../model/policy/policy_model.dart';

class SettingNotifier {
  final String baseUrl = "https://api.porichoy.online/v1";
  Dio dio = Dio();
  bool isLoading = false;
  bool isOtpLoading = false;
  bool isServerError = false;

  Future<Response> postData(String url, dynamic data, String? token) =>
      dio.post(
        url,
        data: data,
        options: Options(
          contentType: Headers.jsonContentType,
          sendTimeout: const Duration(milliseconds: 10000),
          receiveTimeout: const Duration(milliseconds: 10000),
          headers: {"Authorization": "Bearer $token"},
        ),
      );

  Future<Response> getData(String url, String token) => dio.get(url,
      options: Options(
        sendTimeout: const Duration(milliseconds: 10000),
        receiveTimeout: const Duration(milliseconds: 10000),
        headers: {"Authorization": "Bearer $token"},
      ));

  Future<PolicyModel?> getCookies(String url) async {
    final token = await getAccessToken();

    if (token != null) {
      try {
        final token = await UserData.getAccessToken();
        final response = await getData("$baseUrl/policies/$url/", token);
        if (response.statusCode == 200) {
          return PolicyModel.fromJson(response.data);
        }
      } on DioError catch (e) {
        if (e.type == DioErrorType.connectionTimeout ||
            e.type == DioErrorType.receiveTimeout) {
          print('Timeout error');
        } else if (e.type == DioErrorType.badResponse) {
          print('Response error: ${e.response?.statusCode}');
          if (e.response?.statusCode == 400) {
            return PolicyModel.fromJson(e.response?.data);
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

final settingNotifierProvider = Provider<SettingNotifier>((ref) {
  return SettingNotifier();
});

final SettingProvider =
    FutureProvider.family<PolicyModel?, String>((ref, url) async {
  return ref.watch(settingNotifierProvider).getCookies(url);
});
