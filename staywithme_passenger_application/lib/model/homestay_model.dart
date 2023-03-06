import 'package:staywithme_passenger_application/model/bloc_model.dart';

class HomestayModel {
  HomestayModel(
      {this.name,
      this.price,
      this.address,
      this.cityProvince,
      this.availableRooms,
      this.totalAverageRating,
      this.numberOfRating,
      this.status,
      this.homestayImages,
      this.homestayFacilities,
      this.homestayServices,
      this.ratings});

  String? name;
  int? price;
  String? address;
  String? cityProvince;
  int? availableRooms;
  double? totalAverageRating;
  int? numberOfRating;
  String? status;
  List<HomestayImageModel>? homestayImages;
  List<HomestayFacilityModel>? homestayFacilities;
  List<HomestayServiceModel>? homestayServices;
  List<RatingModel>? ratings;

  factory HomestayModel.fromJson(Map<String, dynamic> json) => HomestayModel(
      name: json["name"],
      price: json["price"],
      address: json["address"],
      cityProvince: json["cityProvince"],
      availableRooms: json["availableRooms"],
      totalAverageRating: json["totalAverageRating"],
      numberOfRating: json["numberOfRating"],
      status: json["status"],
      homestayImages: json["homestayImages"] != null
          ? List<HomestayImageModel>.from(
              json["homestayImages"].map((e) => HomestayImageModel.fromJson(e)))
          : <HomestayImageModel>[],
      homestayFacilities: json["HomestayFacilityModel"] != null
          ? List<HomestayFacilityModel>.from(json["HomestayFacilityModel"]
              .map((e) => HomestayFacilityModel.fromJson(e)))
          : <HomestayFacilityModel>[],
      homestayServices: json["homestayServices"] != null
          ? List<HomestayServiceModel>.from(json["homestayServices"]
              .map((e) => HomestayServiceModel.fromJson(e)))
          : <HomestayServiceModel>[],
      ratings: json["ratings"] != null
          ? List<RatingModel>.from(
              json["ratings"].map((e) => RatingModel.fromJson(e)))
          : <RatingModel>[]);
}

class HomestayImageModel {
  HomestayImageModel({this.imageUrl});

  String? imageUrl;

  factory HomestayImageModel.fromJson(Map<String, dynamic> json) =>
      HomestayImageModel(imageUrl: json["imageUrl"]);
}

class HomestayFacilityModel {
  HomestayFacilityModel({this.name, this.quantity});

  String? name;
  int? quantity;

  factory HomestayFacilityModel.fromJson(Map<String, dynamic> json) =>
      HomestayFacilityModel(name: json["name"], quantity: json["quantity"]);
}

class HomestayServiceModel {
  HomestayServiceModel({this.name, this.price, this.status});

  String? name;
  int? price;
  String? status;

  factory HomestayServiceModel.fromJson(Map<String, dynamic> json) =>
      HomestayServiceModel(
          name: json["name"], price: json["price"], status: json["status"]);
}

class RatingModel {
  RatingModel(
      {this.servicePoint,
      this.locationPoint,
      this.securityPoint,
      this.comment});

  double? servicePoint;
  double? locationPoint;
  double? securityPoint;
  String? comment;

  factory RatingModel.fromJson(Map<String, dynamic> json) => RatingModel(
      servicePoint: json["servicePoint"],
      locationPoint: json["locationPoint"],
      securityPoint: json["securityPoint"],
      comment: json["comment"]);
}

class HomestayListPagingModel {
  HomestayListPagingModel({this.homestays, this.pageNumber, this.blocs});

  List<HomestayModel>? homestays;
  List<BlocHomestayModel>? blocs;
  int? pageNumber;

  factory HomestayListPagingModel.fromJson(Map<String, dynamic> json) =>
      HomestayListPagingModel(
          homestays: List<HomestayModel>.from(
              json["homestays"].map((e) => HomestayModel.fromJson(e))),
          blocs: List<BlocHomestayModel>.from(
              json["blocs"].map((e) => BlocHomestayModel.fromJson(e))),
          pageNumber: json["pageNumber"]);
}
