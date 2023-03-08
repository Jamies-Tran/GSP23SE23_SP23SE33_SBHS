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
          balanceWalletModel:
              BalanceWalletModel.fromJson(json["balanceWallet"]));

  Map<String, dynamic> toJson() =>
      {"id": id, "passengerWallet": balanceWalletModel};
}

class PassengerWalletModel {
  PassengerWalletModel({this.id, this.depositForHomestays});

  int? id;
  List<PassengerDepositModel>? depositForHomestays;

  factory PassengerWalletModel.fromJson(Map<String, dynamic> json) =>
      PassengerWalletModel(
        id: json["id"],
        depositForHomestays: json["deposits"] != null
            ? List<PassengerDepositModel>.from(
                json["deposits"].map((e) => PassengerDepositModel.fromJson(e)))
            : null,
      );

  int totalDeposit() {
    int total = 0;
    depositForHomestays != null
        ? depositForHomestays?.forEach((element) {
            total = total + element.unpaidAmount!;
          })
        : total = 0;
    return total;
  }
}

class PassengerDepositModel {
  PassengerDepositModel({this.id, this.unpaidAmount, this.paidAmount});

  int? id;
  int? paidAmount;
  int? unpaidAmount;

  factory PassengerDepositModel.fromJson(Map<String, dynamic> json) =>
      PassengerDepositModel(
          id: json["id"],
          unpaidAmount: json["unpaidAmount"],
          paidAmount: json["paidAmount"]);

  Map<String, dynamic> toJson() =>
      {"unpaidAmount": unpaidAmount, "paidAmount": paidAmount};
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
