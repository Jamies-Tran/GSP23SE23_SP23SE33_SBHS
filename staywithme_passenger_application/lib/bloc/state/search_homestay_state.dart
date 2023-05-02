import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/campaign_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/model/search_filter_model.dart';

class SearchHomestayState {
  SearchHomestayState(
      {this.homestayType,
      this.searchString,
      this.filterOptionModel,
      this.sortBy});

  String? homestayType;
  String? searchString;
  String? sortBy;
  FilterOptionModel? filterOptionModel;

  List<String> sortByList = [
    "Rating",
    "Name",
    "Price",
    "Capacity",
    "Created Date",
    "Bookings"
  ];

  SearchFilterModel searchFilter() => SearchFilterModel(
      homestayType: homestayType,
      searchString: searchString,
      filterOption: filterOptionModel);

  bool onCampaign({HomestayModel? homestay, BlocHomestayModel? bloc}) {
    if (homestay != null) {
      for (CampaignModel c in homestay.campaigns!) {
        if (c.status == "PROGRESSING") {
          return true;
        }
      }
    }
    if (bloc != null) {
      for (CampaignModel c in bloc.campaigns!) {
        if (c.status == "PROGRESSING") {
          return true;
        }
      }
    }
    return false;
  }

  CampaignModel? campaign({HomestayModel? homestay, BlocHomestayModel? bloc}) {
    if (homestay != null) {
      for (CampaignModel c in homestay.campaigns!) {
        if (c.status == "PROGRESSING") {
          return c;
        }
      }
    }
    if (bloc != null) {
      for (CampaignModel c in bloc.campaigns!) {
        if (c.status == "PROGRESSING") {
          return c;
        }
      }
    }
    return null;
  }

  int? newHomestayPrice(HomestayModel homestay) {
    int currentPrice = homestay.price!;
    for (CampaignModel c in homestay.campaigns!) {
      if (c.status == "PROGRESSING") {
        int discountAmount = currentPrice * c.discountPercentage! ~/ 100;
        currentPrice = currentPrice - discountAmount;
      }
    }
    return currentPrice;
  }

  int? newBlocHomestayPrice(
      BlocHomestayModel bloc, HomestayModel homestayInBloc) {
    int currentHomestayInBlocPrice = homestayInBloc.price!;
    for (CampaignModel c in bloc.campaigns!) {
      if (c.status == "PROGRESSING") {
        int discountAmount =
            currentHomestayInBlocPrice * c.discountPercentage! ~/ 100;
        currentHomestayInBlocPrice =
            currentHomestayInBlocPrice - discountAmount;
      }
    }
    return currentHomestayInBlocPrice;
  }
}
