class Prediction {
  Prediction({this.description});

  String? description;

  factory Prediction.fromJson(Map<String, dynamic> json) =>
      Prediction(description: json["description"]);
}

class PlacesResult {
  PlacesResult({this.predictions});

  List<Prediction>? predictions;

  factory PlacesResult.fromJson(Map<String, dynamic> json) => PlacesResult(
      predictions: List<Prediction>.from(
          json["predictions"].map((e) => Prediction.fromJson(e))));
}
