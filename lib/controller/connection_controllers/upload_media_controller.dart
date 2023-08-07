// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kotha/model/constance/constant.dart';
import 'package:kotha/model/media/upload_media_model.dart';
import 'package:http_parser/http_parser.dart';

import '../../model/local_db/user_data.dart';

class MediaNotifier extends ChangeNotifier {
  final String baseUrl = "https://api.porichoy.online/v1";
  Dio dio = Dio();
  bool isLoading = false;
  bool isOtpLoading = false;

  Future<Response> postData(String url, dynamic data, String token) => dio.post(
        url,
        data: data,
        options: Options(
          contentType: Headers.jsonContentType,
          // sendTimeout: const Duration(milliseconds: 10000),
          // receiveTimeout: const Duration(milliseconds: 10000),
          headers: {"Authorization": "Bearer $token"},
        ),
      );

  Future<Response> getData(String url, String token) => dio.get(url,
      options: Options(
        sendTimeout: const Duration(milliseconds: 10000),
        receiveTimeout: const Duration(milliseconds: 10000),
        headers: {"Authorization": "Bearer $token"},
      ));

//upload the image file
// set the url to image to upload image
// and video to upload video file.
  Future<UploadMediaModel?> uploadMedia(String url, File mediaFile) async {
    isLoading = true;
    final token = await getAccessToken();

    if (token != null) {
      try {
        log(mediaFile.path.split('/').last);
        final data = FormData.fromMap({
          url: MultipartFile.fromFileSync(
            mediaFile.path,
            filename: mediaFile.path.split('/').last,
            contentType: MediaType(
              url,
              mediaFile.path.split('/').last.split(".")[1],
            ),
          ),
        });

        final token = await UserData.getAccessToken();
        final response = await postData("$baseUrl/media/$url", data, token);
        if (response.statusCode == 201) {
          isLoading = false;
          notifyListeners();
          return UploadMediaModel.fromJson(response.data);
        }
      } on DioError catch (e) {
        isLoading = false;
        notifyListeners();
        if (e.type == DioErrorType.connectionTimeout ||
            e.type == DioErrorType.receiveTimeout) {
          print('Timeout error');
        } else if (e.type == DioErrorType.badResponse) {
          print('Response error: ${e.response?.statusCode}');
          if (e.response?.statusCode == 400) {
            return UploadMediaModel.fromJson(e.response?.data);
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

  Future<dynamic> deleteMedia(int id) async {
    final token = await getAccessToken();

    if (token != null) {
      try {
        final token = await UserData.getAccessToken();
        final response = await dio.delete("$baseUrl/media/$id/",
            options: Options(
              headers: {"Authorization": "Bearer $token"},
            ));
        if (response.statusCode == 200 || response.statusCode == 201) {
          return {
            "message": response.data["message"],
            "success": response.data["success"],
          };
        }
      } on DioError catch (e) {
        isLoading = false;
        notifyListeners();
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
  }
}

final mediaProvider = ChangeNotifierProvider<MediaNotifier>((ref) {
  return MediaNotifier();
});
