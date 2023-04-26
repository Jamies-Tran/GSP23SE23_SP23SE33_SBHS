import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

class CampaignModel {
  CampaignModel(
      {this.id,
      this.name,
      this.description,
      this.thumbnailUrl,
      this.startDate,
      this.endDate,
      this.status,
      this.discountPercentage,
      this.homestays,
      this.blocs});

  int? id;
  String? name;
  String? description;
  String? thumbnailUrl;
  String? startDate;
  String? endDate;
  String? status;
  int? discountPercentage;
  List<HomestayModel>? homestays;
  List<BlocHomestayModel>? blocs;

  factory CampaignModel.fromJson(Map<String, dynamic> json) => CampaignModel(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      thumbnailUrl: json["thumbnailUrl"],
      startDate: json["startDate"],
      endDate: json["endDate"],
      status: json["status"],
      discountPercentage: json["discountPercent"],
      homestays: json["homestays"] != null
          ? List<HomestayModel>.from(
              json["homestays"].map((e) => HomestayModel.fromJson(e)))
          : <HomestayModel>[],
      blocs: json["blocs"] != null
          ? List<BlocHomestayModel>.from(
              json["blocs"].map((e) => BlocHomestayModel.fromJson(e)))
          : <BlocHomestayModel>[]);
}

class CampaignListPagingModel {
  CampaignListPagingModel({this.campaigns, this.pageNumber});

  List<CampaignModel>? campaigns;
  int? pageNumber;

  factory CampaignListPagingModel.fromJson(Map<String, dynamic> json) =>
      CampaignListPagingModel(
          campaigns: json["campaignList"] != null
              ? List<CampaignModel>.from(
                  json["campaignList"].map((e) => CampaignModel.fromJson(e)))
              : <CampaignModel>[],
          pageNumber: json["pageNumber"]);
}
