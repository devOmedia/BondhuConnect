class LikedProfileModel {
  bool? success;
  String? message;
  List<Data>? data;
  Error? error;

  LikedProfileModel({this.success, this.message, this.data, this.error});

  LikedProfileModel.fromJson(Map<String, dynamic> json) {
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
  int? profileId;
  String? createdAt;
  String? updatedAt;
  Profile? profile;

  Data(
      {this.id,
      this.userId,
      this.profileId,
      this.createdAt,
      this.updatedAt,
      this.profile});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    profileId = json['profile_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
  }
}

class Profile {
  int? id;
  String? name;
  String? email;
  String? gender;
  String? photoUrl;

  Profile({this.id, this.name, this.email, this.gender, this.photoUrl});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    gender = json['gender'];
    photoUrl = json['photo_url'];
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
