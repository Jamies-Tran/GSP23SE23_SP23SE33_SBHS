import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/campaign_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/model/passenger_model.dart';

class BlocHomestayModel {
  BlocHomestayModel(
      {this.name,
      this.address,
      this.cityProvince,
      this.createdDate,
      this.status,
      this.totalAverageRating,
      this.numberOfRating,
      this.homestays,
      this.bookings,
      this.homestayServices,
      this.homestayRules,
      this.ratings,
      this.campaigns,
      this.totalBookings,
      this.landlord});

  String? name;
  String? address;
  String? cityProvince;

  String? createdDate;
  String? status;
  double? totalAverageRating;
  int? numberOfRating;
  List<HomestayModel>? homestays;
  List<BookingModel>? bookings;
  List<HomestayServiceModel>? homestayServices;
  List<HomestayRuleModel>? homestayRules;
  List<RatingModel>? ratings;
  List<CampaignModel>? campaigns;
  int? totalBookings;
  LandlordModel? landlord;

  factory BlocHomestayModel.fromJson(Map<String, dynamic> json) => BlocHomestayModel(
      name: json["name"],
      address: json["address"],
      cityProvince: json["cityProvince"],
      createdDate: json["createdDate"],
      numberOfRating: json["numberOfRating"],
      status: json["status"],
      totalAverageRating: json["totalAverageRating"],
      homestays: List<HomestayModel>.from(
          json["homestays"].map((e) => HomestayModel.fromJson(e))),
      bookings: json["blocs"] != null
          ? List<BookingModel>.from(
              json["blocs"].map((e) => BookingModel.fromJson(e)))
          : <BookingModel>[],
      homestayServices: json["homestayServices"] != null
          ? List<HomestayServiceModel>.from(json["homestayServices"]
              .map((e) => HomestayServiceModel.fromJson(e)))
          : <HomestayServiceModel>[],
      ratings: json["ratings"] != null
          ? List<RatingModel>.from(
              json["ratings"].map((e) => RatingModel.fromJson(e)))
          : <RatingModel>[],
      homestayRules: json["homestayRules"] != null
          ? List<HomestayRuleModel>.from(
              json["homestayRules"].map((e) => HomestayRuleModel.fromJson(e)))
          : <HomestayRuleModel>[],
      campaigns: json["campaignListResponse"] != null
          ? List<CampaignModel>.from(
              json["campaignListResponse"].map((e) => CampaignModel.fromJson(e)))
          : <CampaignModel>[],
      totalBookings: json["totalBookings"],
      landlord: LandlordModel.fromJson(json["landlord"]));
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
