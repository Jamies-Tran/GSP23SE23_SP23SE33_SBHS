class PaymentModel {
  PaymentModel({this.amount, this.orderInfo = "PASSENGER_WALLET", this.payUrl});

  // username
  int? amount;
  // wallet type
  String? orderInfo;
  String? payUrl;

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      PaymentModel(payUrl: json["payUrl"]);

  Map<String, dynamic> toJson() => {"amount": amount, "orderInfo": orderInfo};
}

class PaymentHistoryModel {
  PaymentHistoryModel({this.amount, this.createdDate, this.paymentMethod});

  int? amount;
  String? createdDate;
  String? paymentMethod;

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) =>
      PaymentHistoryModel(
          amount: json["amount"],
          createdDate: json["createdDate"],
          paymentMethod: json["paymentMethod"]);
}
