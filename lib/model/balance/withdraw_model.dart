class WithdrawHistoryModel {
  bool? success;
  String? message;
  List<Data>? data;
  Error? error;

  WithdrawHistoryModel({this.success, this.message, this.data, this.error});

  WithdrawHistoryModel.fromJson(Map<String, dynamic> json) {
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
  String? withdrawId;
  int? userId;
  int? balanceId;
  String? bankName;
  String? accountNumber;
  int? amount;
  String? receiveTime;
  String? status;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.withdrawId,
    this.userId,
    this.balanceId,
    this.bankName,
    this.accountNumber,
    this.amount,
    this.receiveTime,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    withdrawId = json['withdraw_id'];
    userId = json['user_id'];
    balanceId = json['balance_id'];
    bankName = json['bank_name'];
    accountNumber = json['account_number'];
    amount = json['amount'];
    receiveTime = json['receive_time'];
    status = json['status'];
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
