class ChatUserListModel {
  bool? success;
  String? message;
  List<Data>? data;
  Error? error;

  ChatUserListModel({this.success, this.message, this.data, this.error});

  ChatUserListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add( Data.fromJson(v));
      });
    }
    error = json['error'] != null ?  Error.fromJson(json['error']) : null;
  }

}

class Data {
  int? id;
  User? user;
  bool? isBlocked;
  List<Conversations>? conversations;

  Data({this.id, this.user, this.isBlocked, this.conversations});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    isBlocked = json['isBlocked'];
    if (json['conversations'] != null) {
      conversations = <Conversations>[];
      json['conversations'].forEach((v) {
        conversations!.add( Conversations.fromJson(v));
      });
    }
  }

}

class User {
  String? name;
  int? id;
  int? photoId;
  Medium? medium;

  User({this.name, this.id, this.photoId, this.medium});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    photoId = json['photo_id'];
    medium =
        json['medium'] != null ?  Medium.fromJson(json['medium']) : null;
  }

}

class Medium {
  int? id;
  int? userId;
  String? type;
  String? url;
  bool? isVerified;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Medium(
      {this.id,
      this.userId,
      this.type,
      this.url,
      this.isVerified,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Medium.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    url = json['url'];
    isVerified = json['isVerified'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
  }


}

class Conversations {
  int? id;
  String? type;
  String? content;
  bool? isSeen;
  bool? isSender;
  String? createdAt;

  Conversations(
      {this.id,
      this.type,
      this.content,
      this.isSeen,
      this.isSender,
      this.createdAt});

  Conversations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    content = json['content'];
    isSeen = json['isSeen'];
    isSender = json['isSender'];
    createdAt = json['createdAt'];
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
