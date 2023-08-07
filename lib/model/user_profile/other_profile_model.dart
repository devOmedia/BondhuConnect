import 'package:flutter/foundation.dart';

class OtherProfileModel {
  bool? success;
  String? message;
  Data? data;
  Error? error;

  OtherProfileModel({this.success, this.message, this.data, this.error});

  OtherProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    error = json['error'] != null ? Error.fromJson(json['error']) : null;
  }
}

class Data {
  Int32List? photoId;
  String? about;
  String? name;
  int? id;
  dynamic medium;
  List<UserInterests>? userInterests;

  Data(
      {this.photoId,
      this.about,
      this.name,
      this.id,
      this.medium,
      this.userInterests});

  Data.fromJson(Map<String, dynamic> json) {
    photoId = json['photo_id'];
    about = json['about'];
    name = json['name'];
    id = json['id'];
    medium = json['medium'];
    if (json['user_interests'] != null) {
      userInterests = <UserInterests>[];
      json['user_interests'].forEach((v) {
        userInterests!.add(UserInterests.fromJson(v));
      });
    }
  }
}

class UserInterests {
  int? id;
  int? userId;
  int? interestId;
  int? value;
  String? createdAt;
  String? updatedAt;
  InterestOption? interestOption;

  UserInterests(
      {this.id,
      this.userId,
      this.interestId,
      this.value,
      this.createdAt,
      this.updatedAt,
      this.interestOption});

  UserInterests.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    interestId = json['interest_id'];
    value = json['value'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    interestOption = json['interest_option'] != null
        ? InterestOption.fromJson(json['interest_option'])
        : null;
  }
}

class InterestOption {
  int? id;
  String? name;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  InterestOption(
      {this.id, this.name, this.isActive, this.createdAt, this.updatedAt});

  InterestOption.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}

class Error {
  bool? status;
  int? code;
  String? message;

  Error({this.status, this.code, this.message});

  Error.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
  }
}
