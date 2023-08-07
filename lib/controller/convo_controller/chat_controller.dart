// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kotha/model/constance/constant.dart';
import 'package:kotha/model/convo/chat/getChatUserModel.dart';
import 'package:kotha/model/convo/chat/user_chat_details_model.dart';
import 'package:kotha/model/local_db/user_data.dart';

class ChatController {
  final String baseUrl = "https://api.porichoy.online/v1";
  Dio dio = Dio();

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

  Future<Response> getData(String url, String token) => dio.get(
        url,
        options: Options(
          sendTimeout: const Duration(milliseconds: 10000),
          receiveTimeout: const Duration(milliseconds: 10000),
          headers: {"Authorization": "Bearer $token"},
        ),
      );

  Future<ChatUserListModel?> getChatUserList() async {
    final token = await getAccessToken();

    if (token != null) {
      try {
        final token = await UserData.getAccessToken();
        final response = await getData("$baseUrl/convo/rooms/", token);

        if (response.statusCode == 200) {
          return ChatUserListModel.fromJson(response.data);
        }
      } on DioError catch (e) {
        if (e.type == DioErrorType.connectionTimeout ||
            e.type == DioErrorType.receiveTimeout) {
          print('Timeout error');
        } else if (e.type == DioErrorType.badResponse) {
          print('Response error: ${e.response?.statusCode}');
          if (e.response?.statusCode == 400) {
            return ChatUserListModel.fromJson(e.response?.data);
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

  Future<UserChatDetailsModel?> getChatDetails(String id) async {
    final token = await getAccessToken();
    if (token != null) {
      try {
        final token = await UserData.getAccessToken();
        final response =
            await getData("$baseUrl/convo/room_details/$id/", token);

        if (response.statusCode == 200) {
          return UserChatDetailsModel.fromJson(response.data);
        }
      } on DioError catch (e) {
        if (e.type == DioErrorType.connectionTimeout ||
            e.type == DioErrorType.receiveTimeout) {
          print('Timeout error');
        } else if (e.type == DioErrorType.badResponse) {
          print('Response error: ${e.response?.statusCode}');
          if (e.response?.statusCode == 400) {
            return UserChatDetailsModel.fromJson(e.response?.data);
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

final provider = Provider<ChatController>((ref) {
  return ChatController();
});

final chatProvider = FutureProvider<ChatUserListModel?>((ref) async {
  return ref.watch(provider).getChatUserList();
});

final chatDetailsProvider =
    FutureProvider.family<UserChatDetailsModel?, String>((ref, id) async {
  return ref.watch(provider).getChatDetails(id);
});
