class TotalHomestayFromCityProvinceModel {
  TotalHomestayFromCityProvinceModel(
      {this.cityProvince, this.total, this.avatarUrl});

  String? cityProvince;
  String? avatarUrl;
  int? total;

  factory TotalHomestayFromCityProvinceModel.fromJson(
          Map<String, dynamic> json) =>
      TotalHomestayFromCityProvinceModel(
          cityProvince: json["cityProvince"], total: json["total"]!);
}

class TotalBlocHomestayFromCityProvinceModel {
  TotalBlocHomestayFromCityProvinceModel(
      {this.cityProvince, this.total, this.avatarUrl});

  String? cityProvince;
  String? avatarUrl;
  int? total;

  factory TotalBlocHomestayFromCityProvinceModel.fromJson(
          Map<String, dynamic> json) =>
      TotalBlocHomestayFromCityProvinceModel(
          cityProvince: json["cityProvince"], total: json["total"]);
}

class TotalHomestayFromLocationModel {
  TotalHomestayFromLocationModel({this.totalBlocs, this.totalHomestays});

  List<TotalHomestayFromCityProvinceModel>? totalHomestays;
  List<TotalBlocHomestayFromCityProvinceModel>? totalBlocs;

  factory TotalHomestayFromLocationModel.fromJson(Map<String, dynamic> json) =>
      TotalHomestayFromLocationModel(
          totalHomestays: List<TotalHomestayFromCityProvinceModel>.from(
              json["totalHomestays"]!
                  .map((e) => TotalHomestayFromCityProvinceModel.fromJson(e))),
          totalBlocs: List<TotalBlocHomestayFromCityProvinceModel>.from(
              json["totalBlocs"]!.map(
                  (e) => TotalBlocHomestayFromCityProvinceModel.fromJson(e))));
}
