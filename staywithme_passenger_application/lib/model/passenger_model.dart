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
      this.avatarUrl});

  String? username;
  String? password;
  String? email;
  String? address;
  String? phone;
  String? gender;
  String? idCardNumber;
  String? dob;
  String? avatarUrl;

  factory PassengerModel.fromJson(Map<String, dynamic> json) => PassengerModel(
      username: json["username"],
      password: json["password"],
      address: json["address"],
      phone: json["phone"],
      email: json["email"],
      avatarUrl: json["avatarUrl"],
      idCardNumber: json["idCardNumber"],
      dob: json["dob"],
      gender: json["gender"]);

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

class PassengerWalletModel {
  PassengerWalletModel(
      {this.id, this.depositForHomestays, this.passengerBalanceWallet});

  int? id;
  List<PassengerDepositModel>? depositForHomestays;
  BalanceWalletModel? passengerBalanceWallet;

  factory PassengerWalletModel.fromJson(Map<String, dynamic> json) =>
      PassengerWalletModel(
          id: json["id"],
          depositForHomestays: json["depositForHomestays"] ??
              json["depositForHomestays"]
                  .map((e) => PassengerDepositModel.fromJson(e)),
          passengerBalanceWallet:
              BalanceWalletModel.fromJson(json["passengerBalanceWallet"]));
}

class PassengerDepositModel {
  PassengerDepositModel({this.id, this.deposit});

  int? id;
  int? deposit;

  factory PassengerDepositModel.fromJson(Map<String, dynamic> json) =>
      PassengerDepositModel(id: json["id"], deposit: json["deposit"]);

  Map<String, dynamic> toJason() => {"deposit": deposit};
}

class BalanceWalletModel {
  BalanceWalletModel({this.id, this.totalBalance, this.passengerWalletModel});

  int? id;
  int? totalBalance;
  PassengerWalletModel? passengerWalletModel;

  factory BalanceWalletModel.fromJson(Map<String, dynamic> json) =>
      BalanceWalletModel(
          id: json["id"],
          totalBalance: json["totalBalance"],
          passengerWalletModel:
              PassengerWalletModel.fromJson(json["passengerWallet"]));

  Map<String, dynamic> toJson() => {"totalBalance": totalBalance};
}
