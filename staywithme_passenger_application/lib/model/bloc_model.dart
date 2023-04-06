import 'package:staywithme_passenger_application/model/homestay_model.dart';

class BlocHomestayModel {
  BlocHomestayModel(
      {this.name,
      this.address,
      this.cityProvince,
      this.status,
      this.totalAverageRating,
      this.numberOfRating,
      this.homestays,
      this.homestayServices,
      this.homestayRules,
      this.ratings});

  String? name;
  String? address;
  String? cityProvince;
  String? status;
  double? totalAverageRating;
  int? numberOfRating;
  List<HomestayInBlocModel>? homestays;
  List<HomestayServiceModel>? homestayServices;
  List<HomestayRuleModel>? homestayRules;
  List<RatingModel>? ratings;

  factory BlocHomestayModel.fromJson(Map<String, dynamic> json) =>
      BlocHomestayModel(
          name: json["name"],
          address: json["address"],
          cityProvince: json["cityProvince"],
          numberOfRating: json["numberOfRating"],
          status: json["status"],
          totalAverageRating: json["totalAverageRating"],
          homestays: List<HomestayInBlocModel>.from(
              json["homestays"].map((e) => HomestayInBlocModel.fromJson(e))),
          homestayServices: json["homestayServices"] != null
              ? List<HomestayServiceModel>.from(json["homestayServices"]
                  .map((e) => HomestayServiceModel.fromJson(e)))
              : <HomestayServiceModel>[],
          ratings: json["ratings"] != null
              ? List<RatingModel>.from(
                  json["ratings"].map((e) => RatingModel.fromJson(e)))
              : <RatingModel>[],
          homestayRules: json["homestayRules"] != null
              ? List<HomestayRuleModel>.from(json["homestayRules"]
                  .map((e) => HomestayRuleModel.fromJson(e)))
              : <HomestayRuleModel>[]);
}

class HomestayInBlocModel {
  HomestayInBlocModel(
      {this.id,
      this.name,
      this.price,
      this.availableRooms,
      this.roomCapacity,
      this.totalAverageRating,
      this.bloc,
      this.homestayImages,
      this.homestayFacilities,
      this.ratings});

  int? id;
  String? name;
  int? price;
  int? availableRooms;
  int? roomCapacity;
  double? totalAverageRating;
  BlocHomestayModel? bloc;
  List<HomestayImageModel>? homestayImages;
  List<HomestayFacilityModel>? homestayFacilities;
  List<RatingModel>? ratings;

  factory HomestayInBlocModel.fromJson(Map<String, dynamic> json) =>
      HomestayInBlocModel(
          id: json["id"],
          name: json["name"],
          availableRooms: json["availableRooms"],
          roomCapacity: json["roomCapacity"],
          price: json["price"],
          totalAverageRating: json["totalAverageRating"],
          bloc: json["blocResponse"],
          homestayImages: json["homestayImages"] != null
              ? List<HomestayImageModel>.from(json["homestayImages"]
                  .map((e) => HomestayImageModel.fromJson(e)))
              : <HomestayImageModel>[],
          homestayFacilities: json["homestayFacilities"] != null
              ? List<HomestayFacilityModel>.from(json["homestayFacilities"]
                  .map((e) => HomestayFacilityModel.fromJson(e)))
              : <HomestayFacilityModel>[],
          ratings: json["ratings"] != null
              ? List<RatingModel>.from(
                  json["ratings"].map((e) => RatingModel.fromJson(e)))
              : <RatingModel>[]);
}

class BlocHomestayListPagingModel {
  BlocHomestayListPagingModel({this.blocs, this.pageNumber});

  List<BlocHomestayModel>? blocs;
  int? pageNumber;

  factory BlocHomestayListPagingModel.fromJson(Map<String, dynamic> json) =>
      BlocHomestayListPagingModel(
          blocs: List<BlocHomestayModel>.from(
              json["blocs"].map((e) => BlocHomestayModel.fromJson(e))),
          pageNumber: json["pageNumber"]);
}
