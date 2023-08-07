class UserInterestModel {
  bool? success;
  String? message;
  List<Data>? data;
  Error? error;

  UserInterestModel({this.success, this.message, this.data, this.error});

  UserInterestModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    error = json['error'] != null ? Error.fromJson(json['error']) : null;
  }
}

class Data {
  int? id;
  int? userId;
  int? interestId;
  int? value;
  String? createdAt;
  String? updatedAt;
  InterestOption? interestOption;

  Data(
      {this.id,
      this.userId,
      this.interestId,
      this.value,
      this.createdAt,
      this.updatedAt,
      this.interestOption});

  Data.fromJson(Map<String, dynamic> json) {
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
