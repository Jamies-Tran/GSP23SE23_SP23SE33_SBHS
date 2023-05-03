import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/campaign_model.dart';
import 'package:staywithme_passenger_application/model/passenger_model.dart';

class HomestayModel {
  HomestayModel(
      {this.id,
      this.name,
      this.price,
      this.address,
      this.cityProvince,
      this.createdDate,
      this.availableRooms,
      this.roomCapacity,
      this.totalAverageRating,
      this.numberOfRating,
      this.status,
      this.bloc,
      this.homestayImages,
      this.homestayFacilities,
      this.homestayServices,
      this.homestayRules,
      this.ratings,
      this.campaigns,
      this.totalBookings,
      this.landlord});

  int? id;
  String? name;
  int? price;
  String? address;
  String? cityProvince;
  String? createdDate;
  int? availableRooms;
  int? roomCapacity;
  double? totalAverageRating;
  int? numberOfRating;
  String? status;
  BlocHomestayModel? bloc;
  List<HomestayImageModel>? homestayImages;
  List<HomestayFacilityModel>? homestayFacilities;
  List<HomestayServiceModel>? homestayServices;
  List<HomestayRuleModel>? homestayRules;
  List<RatingModel>? ratings;
  List<CampaignModel>? campaigns;
  int? totalBookings;
  LandlordModel? landlord;

  factory HomestayModel.fromJson(Map<String, dynamic> json) => HomestayModel(
      id: json["id"],
      name: json["name"],
      price: json["price"],
      address: json["address"],
      cityProvince: json["cityProvince"],
      createdDate: json["createdDate"],
      availableRooms: json["availableRooms"],
      roomCapacity: json["roomCapacity"],
      totalAverageRating: json["totalAverageRating"],
      numberOfRating: json["numberOfRating"],
      status: json["status"],
      bloc: json["blocResponse"] != null
          ? BlocHomestayModel.fromJson(json["blocResponse"])
          : null,
      homestayImages: json["homestayImages"] != null
          ? List<HomestayImageModel>.from(
              json["homestayImages"].map((e) => HomestayImageModel.fromJson(e)))
          : <HomestayImageModel>[],
      homestayFacilities: json["homestayFacilities"] != null
          ? List<HomestayFacilityModel>.from(json["homestayFacilities"]
              .map((e) => HomestayFacilityModel.fromJson(e)))
          : <HomestayFacilityModel>[],
      homestayServices: json["homestayServices"] != null
          ? List<HomestayServiceModel>.from(json["homestayServices"]
              .map((e) => HomestayServiceModel.fromJson(e)))
          : <HomestayServiceModel>[],
      homestayRules: json["homestayRules"] != null
          ? List<HomestayRuleModel>.from(
              json["homestayRules"].map((e) => HomestayRuleModel.fromJson(e)))
          : <HomestayRuleModel>[],
      ratings: json["ratings"] != null
          ? List<RatingModel>.from(json["ratings"].map((e) => RatingModel.fromJson(e)))
          : <RatingModel>[],
      campaigns: json["campaignListResponse"] != null ? List<CampaignModel>.from(json["campaignListResponse"].map((e) => CampaignModel.fromJson(e))) : <CampaignModel>[],
      totalBookings: json["totalBookings"],
      landlord: LandlordModel.fromJson(json["landlord"]));

  Map<String, dynamic> toJson() => {"name": name, "price": price};
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
  HomestayServiceModel({this.id, this.name, this.price, this.status});

  int? id;
  String? name;
  int? price;
  String? status;

  factory HomestayServiceModel.fromJson(Map<String, dynamic> json) =>
      HomestayServiceModel(
          id: json["id"],
          name: json["name"],
          price: json["price"],
          status: json["status"]);

  Map<String, dynamic> toJson() => {"name": name, "price": price};
}

class RatingModel {
  RatingModel(
      {this.servicePoint,
      this.locationPoint,
      this.securityPoint,
      this.homestayName,
      this.comment,
      this.username,
      this.avatar});

  double? servicePoint;
  double? locationPoint;
  double? securityPoint;
  String? homestayName;
  String? comment;
  String? username;
  String? avatar;

  factory RatingModel.fromJson(Map<String, dynamic> json) => RatingModel(
      servicePoint: json["servicePoint"],
      locationPoint: json["locationPoint"],
      securityPoint: json["securityPoint"],
      homestayName: json["homestayName"],
      comment: json["comment"],
      avatar: json["avatar"],
      username: json["username"]);

  Map<String, dynamic> toJson() => {
        "securityPoint": securityPoint,
        "servicePoint": servicePoint,
        "locationPoint": locationPoint,
        "homestayName": homestayName,
        "comment": comment
      };
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

class HomestayRuleModel {
  HomestayRuleModel({this.id, this.description});

  int? id;
  String? description;

  factory HomestayRuleModel.fromJson(Map<String, dynamic> json) =>
      HomestayRuleModel(id: json["id"], description: json["description"]);
}
