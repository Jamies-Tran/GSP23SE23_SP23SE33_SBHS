class ServerExceptionModel {
  ServerExceptionModel({this.message, this.statusCode});

  String? message;
  int? statusCode;

  factory ServerExceptionModel.fromJson(Map<String, dynamic> json) =>
      ServerExceptionModel(
          message: json["message"], statusCode: json["statusCode"]);
}
