// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kotha/model/authentiacations/forget_password/forget_password_phone_number_model.dart';
import 'package:kotha/model/authentiacations/login_model.dart';
import 'package:kotha/model/authentiacations/registration_model.dart';
import 'package:kotha/model/authentiacations/registration_validate_otp_model.dart';
import 'package:kotha/model/interest/interest_model.dart';
import 'package:kotha/model/local_db/user_data.dart';

import '../../../model/constance/constant.dart';
import '../../../model/interest/user_interest_model.dart';
import '../../../view/screens/authentications/login_with_opt_model.dart';

class AuthenticationNotifier extends ChangeNotifier {
  final String baseUrl = "https://api.porichoy.online/v1";
  Dio dio = Dio();
  bool isLoading = false;
  bool isOtpLoading = false;
  bool isServerError = false;
  UserInterestModel userInterest = UserInterestModel();

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

  Future<LoginModel?> getUserLoggedIn(dynamic data) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await postData("$baseUrl/login", data, null);

      if (response.statusCode == 200) {
        isLoading = false;
        notifyListeners();
        //store the access token.
        UserData.setAccessToken(
            LoginModel.fromJson(response.data).data!.tokens!.access!.token!);
        //store the refresh token
        UserData.setRefreshToken(
            LoginModel.fromJson(response.data).data!.tokens!.refresh!.token!);
        UserData.setUser(LoginModel.fromJson(response.data).data!.user!);
//access token expire time.
        UserData.setAccessTokenExpireTime(
            LoginModel.fromJson(response.data).data!.tokens!.access!.expires!);
//refresh token expire time.
        UserData.setRefreshTokenExpireTime(
            LoginModel.fromJson(response.data).data!.tokens!.refresh!.expires!);
        return LoginModel.fromJson(response.data);
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
          return LoginModel.fromJson(e.response?.data);
        }
      } else if (e.type == DioErrorType.cancel) {
        print('Request cancelled');
      } else {
        print('Other error: $e');
      }
    }
    isLoading = false;
    notifyListeners();
    return null;
  }

  Future<LoginWithOTPModel?> getUserLoggedInWithOTP(dynamic data) async {
    isLoading = true;
    notifyListeners();
    try {
      final response =
          await postData("$baseUrl/verify_otp_to_login/", data, null);

      if (response.statusCode == 201 || response.statusCode == 200) {
        isLoading = false;
        notifyListeners();

        //store the access token.
        UserData.setAccessToken(LoginWithOTPModel.fromJson(response.data)
            .data!
            .tokens!
            .access!
            .token!);
        //store the refresh token
        UserData.setRefreshToken(LoginWithOTPModel.fromJson(response.data)
            .data!
            .tokens!
            .refresh!
            .token!);
        UserData.setUser(LoginWithOTPModel.fromJson(response.data).data!.user!);
//access token expire time.
        UserData.setAccessTokenExpireTime(
            LoginWithOTPModel.fromJson(response.data)
                .data!
                .tokens!
                .access!
                .expires!);
//refresh token expire time.
        UserData.setRefreshTokenExpireTime(
            LoginWithOTPModel.fromJson(response.data)
                .data!
                .tokens!
                .refresh!
                .expires!);
        return LoginWithOTPModel.fromJson(response.data);
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
          return LoginWithOTPModel.fromJson(e.response?.data);
        }
      } else if (e.type == DioErrorType.cancel) {
        print('Request cancelled');
      } else {
        print('Other error: $e');
      }
    }
    isLoading = false;
    notifyListeners();
    return null;
  }

  Future sendUserLoggedOTP(dynamic data) async {
    isLoading = true;
    notifyListeners();
    try {
      final response =
          await postData("$baseUrl/send_otp_to_login/", data, null);

      if (response.statusCode == 201 || response.statusCode == 200) {
        isLoading = false;
        notifyListeners();

        return {
          "message": response.data["message"],
          "success": response.data["success"]
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
            "success": e.response!.data["success"]
          };
        }
      } else if (e.type == DioErrorType.cancel) {
        print('Request cancelled');
      } else {
        print('Other error: $e');
      }
    }
    isLoading = false;
    notifyListeners();
    return null;
  }

  Future<RegistrationModel?> userSignUp(dynamic data) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await postData("$baseUrl/register/send_otp", data, null);

      if (response.statusCode == 201) {
        isLoading = false;
        notifyListeners();
        return RegistrationModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      isLoading = false;
      notifyListeners();
      if (e.type == DioErrorType.connectionTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        print('Timeout error');
      } else if (e.type == DioErrorType.badResponse) {
        print('================>>> Response error: ${e.response?.statusCode}');
        if (e.response?.statusCode == 400) {
          return RegistrationModel.fromJson(e.response?.data);
        }
      } else if (e.type == DioErrorType.cancel) {
        print('Request cancelled');
      } else {
        print('Other error: $e');
      }
    }
    return null;
  }

// validate the otp for sign up
  Future<RegistrationValidateOTPModel?> validateSignUpOTP(dynamic data) async {
    isOtpLoading = true;
    notifyListeners();
    try {
      print("===============>>>");
      print(data);
      final response =
          await postData("$baseUrl/register/verify_otp", data, null);

      if (response.statusCode == 201) {
        isOtpLoading = false;
        notifyListeners();
        // store the tokens
        UserData.setAccessToken(
            RegistrationValidateOTPModel.fromJson(response.data)
                .data!
                .tokens!
                .access!
                .token!);
        UserData.setRefreshToken(
            RegistrationValidateOTPModel.fromJson(response.data)
                .data!
                .tokens!
                .refresh!
                .token!);
        //access token expire time.
        UserData.setAccessTokenExpireTime(
            RegistrationValidateOTPModel.fromJson(response.data)
                .data!
                .tokens!
                .access!
                .expires!);
//refresh token expire time.
        UserData.setRefreshTokenExpireTime(
            RegistrationValidateOTPModel.fromJson(response.data)
                .data!
                .tokens!
                .refresh!
                .expires!);
        return RegistrationValidateOTPModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      isOtpLoading = false;
      notifyListeners();
      if (e.type == DioErrorType.connectionTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        print('Timeout error');
      } else if (e.type == DioErrorType.badResponse) {
        print('================>>> Response error: ${e.response?.statusCode}');
        if (e.response?.statusCode == 400) {
          return RegistrationValidateOTPModel.fromJson(e.response?.data);
        }
      } else if (e.type == DioErrorType.cancel) {
        print('Request cancelled');
      } else {
        print('Other error: $e');
      }
    }
    return null;
  }

// validate the otp for forget password.
  Future<Map?> validateForgetPasswordOTP(dynamic data) async {
    isOtpLoading = true;
    notifyListeners();
    try {
      final response = await postData("$baseUrl/verify_otp", data, null);

      if (response.statusCode == 200) {
        isOtpLoading = false;
        notifyListeners();
        return {
          "success": response.data["success"],
          "message": response.data["message"]
        };
      }
    } on DioError catch (e) {
      isOtpLoading = false;
      notifyListeners();
      if (e.type == DioErrorType.connectionTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        print('Timeout error');
      } else if (e.type == DioErrorType.badResponse) {
        print('================>>> Response error: ${e.response?.statusCode}');
        if (e.response?.statusCode == 400) {
          return {
            "success": e.response!.data["success"],
            "message": e.response!.data["message"]
          };
        }
      } else if (e.type == DioErrorType.cancel) {
        print('Request cancelled');
      } else {
        print('Other error: $e');
      }
    }
    return null;
  }

// reset the password.
  Future<Map?> resetPassword(dynamic data) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await postData("$baseUrl/reset_password", data, null);

      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading = false;
        notifyListeners();
        return {
          "success": response.data["success"],
          "message": response.data["message"]
        };
      }
    } on DioError catch (e) {
      isLoading = false;
      notifyListeners();
      if (e.type == DioErrorType.connectionTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        print('Timeout error');
      } else if (e.type == DioErrorType.badResponse) {
        print('================>>> Response error: ${e.response?.statusCode}');
        if (e.response?.statusCode == 400) {
          return {
            "success": e.response!.data["success"],
            "message": e.response!.data["message"]
          };
        }
      } else if (e.type == DioErrorType.cancel) {
        print('Request cancelled');
      } else {
        print('Other error: $e');
      }
    }
    return null;
  }

  //get the interest list
  Future<InterestModel?> getInterestList() async {
    isLoading = true;
    isServerError = false;
    notifyListeners();
    final token = await getAccessToken();
    if (token != null) {
      try {
        final response = await getData("$baseUrl/interest/", token);

        if (response.statusCode == 200) {
          isLoading = false;
          notifyListeners();
          return InterestModel.fromJson(response.data);
        }
      } on DioError catch (e) {
        isLoading = false;
        notifyListeners();
        if (e.type == DioErrorType.connectionTimeout ||
            e.type == DioErrorType.receiveTimeout) {
          print('Timeout error');
        } else if (e.type == DioErrorType.badResponse) {
          print(
              '================>>> Response error: ${e.response?.statusCode}');
          if (e.response?.statusCode == 400) {
            return InterestModel.fromJson(e.response?.data);
          } else if (e.response?.statusCode == 500) {
            isServerError = true;
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

  //
//add interest item of a user.

  Future<dynamic> addUserInterest(dynamic data) async {
    isLoading = true;
    isServerError = false;
    notifyListeners();
    final token = await getAccessToken();
    if (token != null) {
      try {
        final token = await UserData.getAccessToken();
        final response = await postData("$baseUrl/interest/user/", data, token);

        if (response.statusCode == 201) {
          isLoading = false;
          notifyListeners();
          return {
            "success": response.data["success"],
            "message": response.data["message"]
          };
        }
      } on DioError catch (e) {
        isLoading = false;
        notifyListeners();
        if (e.type == DioErrorType.connectionTimeout ||
            e.type == DioErrorType.receiveTimeout) {
          print('Timeout error');
        } else if (e.type == DioErrorType.badResponse) {
          print(
              '================>>> Response error: ${e.response?.statusCode}');
          if (e.response?.statusCode == 400) {
            return {
              "success": e.response!.data["success"],
              "message": e.response!.data["message"]
            };
          } else if (e.response?.statusCode == 500) {
            isServerError = true;
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

  // check the phone number for forget password and send the otp to the number.
  Future<ForgetPasswordPhoneNumberModel?> getOTPForForgetPassword(
      dynamic data) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await postData("$baseUrl/forgot_password", data, null);

      if (response.statusCode == 201) {
        isLoading = false;
        notifyListeners();
        return ForgetPasswordPhoneNumberModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      isLoading = false;
      notifyListeners();
      if (e.type == DioErrorType.connectionTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        print('Timeout error');
      } else if (e.type == DioErrorType.badResponse) {
        print('================>>> Response error: ${e.response?.statusCode}');
        if (e.response?.statusCode == 400) {
          return ForgetPasswordPhoneNumberModel.fromJson(e.response?.data);
        }
      } else if (e.type == DioErrorType.cancel) {
        print('Request cancelled');
      } else {
        print('Other error: $e');
      }
    }
    return null;
  }
}

final authenticationProvider =
    ChangeNotifierProvider<AuthenticationNotifier>((ref) {
  return AuthenticationNotifier();
});
