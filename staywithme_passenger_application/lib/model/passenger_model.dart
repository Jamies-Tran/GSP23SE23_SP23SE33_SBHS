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
