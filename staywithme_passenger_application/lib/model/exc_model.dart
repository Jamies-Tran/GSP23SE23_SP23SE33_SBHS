class ServerExceptionModel {
  ServerExceptionModel({this.message});

  String? message;

  factory ServerExceptionModel.fromJson(Map<String, dynamic> json) =>
      ServerExceptionModel(message: json["message"]);
}
