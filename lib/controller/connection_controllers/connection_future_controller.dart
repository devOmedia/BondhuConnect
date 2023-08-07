// ignore_for_file: avoid_print

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kotha/model/constance/constant.dart';
import 'package:kotha/model/home/home_data_model.dart';
import 'package:kotha/model/home/liked_profile_model.dart';
import 'package:kotha/model/interest/interest_model.dart';
import 'package:kotha/model/local_db/user_data.dart';

import '../../model/interest/user_interest_model.dart';

class ConnectionFutureController extends ChangeNotifier {
  final String baseUrl = "https://api.porichoy.online/v1";
  Dio dio = Dio();

  Future<Response> postData(String url, dynamic data) => dio.post(
        url,
        data: data,
        options: Options(
            contentType: Headers.jsonContentType,
            sendTimeout: const Duration(milliseconds: 10000),
            receiveTimeout: const Duration(milliseconds: 10000)),
      );

  Future<Response> getData(String url, String token) => dio.get(url,
      options: Options(
        sendTimeout: const Duration(milliseconds: 10000),
        receiveTimeout: const Duration(milliseconds: 10000),
        headers: {"Authorization": "Bearer $token"},
      ));

//get the interest data.
  Future<InterestModel?> getInterestData() async {
    final token = await getAccessToken();

    if (token != null) {
      try {
        final token = await UserData.getAccessToken();
        final response = await getData("$baseUrl/interest/", token);
        if (response.statusCode == 200) {
          return InterestModel.fromJson(response.data);
        }
      } on DioError catch (e) {
        if (e.type == DioErrorType.connectionTimeout ||
            e.type == DioErrorType.receiveTimeout) {
          print('Timeout error');
        } else if (e.type == DioErrorType.badResponse) {
          print('Response error: ${e.response?.statusCode}');
          if (e.response?.statusCode == 400) {
            return InterestModel.fromJson(e.response?.data);
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

  //get the user interest list
  Future<UserInterestModel?> getUserInterestList() async {
    final token = await getAccessToken();
    if (token != null) {
      try {
        final token = await UserData.getAccessToken();
        final response = await getData("$baseUrl/interest/user/", token);

        if (response.statusCode == 200) {
          return UserInterestModel.fromJson(response.data);
        }
      } on DioError catch (e) {
        if (e.type == DioErrorType.connectionTimeout ||
            e.type == DioErrorType.receiveTimeout) {
          print('Timeout error');
        } else if (e.type == DioErrorType.badResponse) {
          print(
              '================>>> Response error: ${e.response?.statusCode}');
          if (e.response?.statusCode == 400) {
            return UserInterestModel.fromJson(e.response?.data);
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

  //get the home  data.
  Future<HomeDataModel?> getHomeData() async {
    final token = await getAccessToken();

    if (token != null) {
      try {
        final token = await UserData.getAccessToken();
        final response = await getData("$baseUrl/home/", token);
        if (response.statusCode == 200) {
          return HomeDataModel.fromJson(response.data);
        }
      } on DioError catch (e) {
        if (e.type == DioErrorType.connectionTimeout ||
            e.type == DioErrorType.receiveTimeout) {
          print('Timeout error');
        } else if (e.type == DioErrorType.badResponse) {
          print('Response error: ${e.response?.statusCode}');
          if (e.response?.statusCode == 400) {
            return HomeDataModel.fromJson(e.response?.data);
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

  //get the liked user profile  data.
  Future<LikedProfileModel?> getLikedUserProfileData() async {
    final token = await getAccessToken();
    if (token != null) {
      try {
        final token = await UserData.getAccessToken();
        final response = await getData("$baseUrl/profile/my_like/", token);
        if (response.statusCode == 200) {
          return LikedProfileModel.fromJson(response.data);
        }
      } on DioError catch (e) {
        if (e.type == DioErrorType.connectionTimeout ||
            e.type == DioErrorType.receiveTimeout) {
          print('Timeout error');
        } else if (e.type == DioErrorType.badResponse) {
          print('Response error: ${e.response?.statusCode}');
          if (e.response?.statusCode == 400) {
            return LikedProfileModel.fromJson(e.response?.data);
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

final controller =
    Provider<ConnectionFutureController>((ref) => ConnectionFutureController());

//interest provider.
final interestProvider = FutureProvider<InterestModel?>((ref) async {
  return ref.watch(controller).getInterestData();
});

final homeProvider = FutureProvider<HomeDataModel?>((ref) async {
  return ref.watch(controller).getHomeData();
});

final likedUserProvider = FutureProvider<LikedProfileModel?>((ref) async {
  return ref.watch(controller).getLikedUserProfileData();
});

final userInterestProvider = FutureProvider<UserInterestModel?>((ref) async {
  return ref.watch(controller).getUserInterestList();
});
