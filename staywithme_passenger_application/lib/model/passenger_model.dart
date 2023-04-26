import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

class PassengerModel {
  PassengerModel(
      {this.username,
      this.password,
      this.email,
      this.address,
      this.phone,
      this.gender,
      this.idCardNumber,
      this.dob,
      this.avatarUrl,
      this.passengerPropertyModel});

  String? username;
  String? password;
  String? email;
  String? address;
  String? phone;
  String? gender;
  String? idCardNumber;
  String? dob;
  String? avatarUrl;
  PassengerPropertyModel? passengerPropertyModel;

  factory PassengerModel.fromJson(Map<String, dynamic> json) => PassengerModel(
      username: json["username"],
      password: json["password"],
      address: json["address"],
      phone: json["phone"],
      email: json["email"],
      avatarUrl: json["avatarUrl"],
      idCardNumber: json["idCardNumber"],
      dob: json["dob"],
      gender: json["gender"],
      passengerPropertyModel:
          PassengerPropertyModel.fromJson(json["passengerProperty"]));

  Map<String, String?> toJson() => {
        "username": username,
        "password": password,
        "address": address,
        "phone": phone,
        "email": email,
        "avatarUrl": avatarUrl,
        "idCardNumber": idCardNumber,
        "dob": dob,
        "gender": gender
      };
}

class PassengerPropertyModel {
  PassengerPropertyModel({this.id, this.balanceWalletModel});

  int? id;
  BalanceWalletModel? balanceWalletModel;

  factory PassengerPropertyModel.fromJson(Map<String, dynamic> json) =>
      PassengerPropertyModel(
        id: json["id"],
        balanceWalletModel: BalanceWalletModel.fromJson(
          json["balanceWallet"],
        ),
      );

  Map<String, dynamic> toJson() =>
      {"id": id, "passengerWallet": balanceWalletModel};
}

class PassengerWalletModel {
  PassengerWalletModel({this.id, this.deposits});

  int? id;
  List<DepositModel>? deposits;

  factory PassengerWalletModel.fromJson(Map<String, dynamic> json) =>
      PassengerWalletModel(
        id: json["id"],
        deposits: json["deposits"] != null
            ? List<DepositModel>.from(
                json["deposits"].map((e) => DepositModel.fromJson(e)))
            : null,
      );

  int totalDeposit() {
    int total = 0;
    deposits != null
        ? deposits?.forEach((deposit) {
            for (BookingDepositModel bookingDeposit
                in deposit.bookingDeposits!) {
              total = total + bookingDeposit.unpaidAmount!;
            }
          })
        : total = 0;
    return total;
  }
}

class BalanceWalletModel {
  BalanceWalletModel(
      {this.id,
      this.totalBalance,
      this.actualBalance,
      this.passengerWalletModel});

  int? id;
  int? totalBalance;
  int? actualBalance;
  PassengerWalletModel? passengerWalletModel;

  factory BalanceWalletModel.fromJson(Map<String, dynamic> json) =>
      BalanceWalletModel(
          id: json["id"],
          totalBalance: json["totalBalance"],
          actualBalance: json["actualBalance"],
          passengerWalletModel:
              PassengerWalletModel.fromJson(json["passengerWallet"]));

  Map<String, dynamic> toJson() => {"totalBalance": totalBalance};
}
