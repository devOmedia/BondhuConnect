// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kotha/model/authentiacations/token_model.dart';
import 'package:kotha/model/constance/color_constant.dart';
import 'package:kotha/model/local_db/user_data.dart';
import 'package:kotha/view/screens/authentications/login_screen.dart';

const String baseUrl = "https://api.porichoy.online/v1";

class AppConstants {
  static const appPadding = EdgeInsets.symmetric(vertical: 60, horizontal: 16);

  static getSpace(double size) => SizedBox(height: size);

  static getSnackBar(void Function() onPressed) => SnackBar(
        content: const Text('Something went wrong, please try again later.'),
        action: SnackBarAction(
          label: 'ok',
          onPressed: onPressed,
        ),
      );

  static Container screenBackgroundColor() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0XFFFFEDE8),
            KColors.primaryColor,
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          //tileMode: TileMode.mirror,
        ),
      ),
    );
  }
}

class Keys {
  static const AppID = 1828821299;
  static const appSign =
      "6f05ba5987adbc4966d56aede6d8e9f378527f5b17f563290ce65d9fc65dad76";

  //static const token =
  // "04AAAAAGQuaLYAEHM5MmYxd2tqcXdhazIyM3MAoE4exn4c23NFi63UzErIxxJLrGSEK7/2BmEiF72C6ChxPMtw10LCjN1KVMu+j8oWbVBYmh5ycWMVFDnEIRsGWxFgmFM0TJzVA+kvL98xKP8NII5rIQ6PKCBSmnU8D6esHwPi9ZY6ZUAIYpy5FXA4E+/QRgFsDBmD5Yt+LotCRRaY1DOlY/++xfTOo/nPMx+bxA4xt4HrtjrkQMUIGiURus0=";
}

//token call back method,
// because the server man send response 400 on token expire
//returns false if expired
//returns true  if not expired
Future<String?> getAccessToken() async {
  final String accessTime = await UserData.getAccessTokenExpireTime();
  final String refreshTime = await UserData.getRefreshTokenExpireTime();
  final accessDateTime = DateTime.parse(accessTime); // formate to date time.
  final refreshDateTime = DateTime.parse(refreshTime);
  final currentTime = DateTime.now();

  final Dio dio = Dio();

  //check access token expire
  if (currentTime.isAfter(accessDateTime)) {
    // current time is before, token expired
    log("access token invalid");

    if (refreshDateTime.isBefore(currentTime)) {
      //refresh token valid

      try {
        final response = await dio.get(
          "$baseUrl/refresh_token/",
        );

        if (response.statusCode == 200) {
          final data = response.data;
          UserData.setAccessToken(
              TokenModel.fromJson(data).data!.access!.token!); //store token
          UserData.setRefreshToken(
              TokenModel.fromJson(data).data!.refresh!.token!);
          UserData.setAccessTokenExpireTime(
              TokenModel.fromJson(data).data!.access!.expires!); // expire time.
          UserData.setRefreshTokenExpireTime(
              TokenModel.fromJson(data).data!.access!.expires!);

          return TokenModel.fromJson(data)
              .data!
              .access!
              .token!; // return the new token.
        }
      } on DioError catch (e) {
        if (e.type == DioErrorType.connectionTimeout ||
            e.type == DioErrorType.receiveTimeout) {
          print('Timeout error');
        } else if (e.type == DioErrorType.badResponse) {
          print('Response error: ${e.response?.statusCode}');
        } else if (e.type == DioErrorType.cancel) {
          print('Request cancelled');
        } else {
          print('Other error: $e');
        }
        return null; //if this cause error.
      }
    } else {
      //refresh token  expired
      showMyDialog();
      return null;
    }
  }
  //access token valid
  return await UserData.getAccessToken();
}

gotoLogin(BuildContext context) async {
  UserData.deleteToken()
      .then((_) => Navigator.pushReplacementNamed(context, LoginScreen.id));
}

final navigatorKey = GlobalKey<NavigatorState>();

void showMyDialog() {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) => Center(
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            const Text("Something went wrong, please try again latter."),
            MaterialButton(
              onPressed: () {
                gotoLogin(context);
              },
              child: const Text("Ok"),
            )
          ],
        ),
      ),
    ),
  );
}
