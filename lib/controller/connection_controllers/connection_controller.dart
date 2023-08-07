// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kotha/model/local_db/user_data.dart';
import 'package:kotha/model/user_profile/other_profile_model.dart';

import '../../model/constance/constant.dart';
import '../../model/user_profile/user_profile_model.dart';

class ConnectionController extends ChangeNotifier {
  final String baseUrl = "https://api.porichoy.online/v1";
  Dio dio = Dio();
  UserProfileModel? userProfileModel;
  OtherProfileModel? otherProfileModel;

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

//add to the fev list.
  Future<dynamic> addToFev(int id) async {
    final token = await getAccessToken();
    if (token != null) {
      try {
        final token = await UserData.getAccessToken();
        final response =
            await postData("$baseUrl/profile/like/$id/", {}, token);
        if (response.statusCode == 200 || response.statusCode == 201) {
          return {
            "message": response.data["message"],
            "success": response.data["success"],
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
              "success": e.response!.data["success"],
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

  //delete to the fev list.
  Future<dynamic> deleteFromFev(int id) async {
    final token = await getAccessToken();
    if (token != null) {
      try {
        final token = await UserData.getAccessToken();
        final response =
            await deleteData("$baseUrl/profile/like/$id/", {}, token);
        if (response.statusCode == 200 || response.statusCode == 201) {
          return {
            "message": response.data["message"],
            "success": response.data["success"],
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
              "success": e.response!.data["success"],
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

  //get the user profile data.
  Future getUserProfileData() async {
    final token = await getAccessToken();

    if (token != null) {
      try {
        final token = await UserData.getAccessToken();
        final response = await getData("$baseUrl/profile/", token);
        if (response.statusCode == 200) {
          userProfileModel = UserProfileModel.fromJson(response.data);
        }
      } on DioError catch (e) {
        if (e.type == DioErrorType.connectionTimeout ||
            e.type == DioErrorType.receiveTimeout) {
          print('Timeout error');
        } else if (e.type == DioErrorType.badResponse) {
          print('Response error: ${e.response?.statusCode}');
          if (e.response?.statusCode == 400) {
            userProfileModel = UserProfileModel.fromJson(e.response?.data);
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

  //get the other user profile data.
  Future<OtherProfileModel?> getOtherUserModel(int id) async {
    final token = await getAccessToken();

    if (token != null) {
      try {
        final token = await UserData.getAccessToken();
        final response = await getData("$baseUrl/profile/user/$id/", token);
        if (response.statusCode == 200) {
          return OtherProfileModel.fromJson(response.data);
        }
      } on DioError catch (e) {
        if (e.type == DioErrorType.connectionTimeout ||
            e.type == DioErrorType.receiveTimeout) {
          print('Timeout error');
        } else if (e.type == DioErrorType.badResponse) {
          print('Response error: ${e.response?.statusCode}');
          if (e.response?.statusCode == 400) {
            return OtherProfileModel.fromJson(e.response?.data);
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

final connectionProvider = ChangeNotifierProvider<ConnectionController>((ref) {
  return ConnectionController();
});
