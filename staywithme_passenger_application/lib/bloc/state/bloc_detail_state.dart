import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/campaign_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

class BlocHomestayDetailState {
  BlocHomestayDetailState(
      {this.name,
      this.msg,
      this.msgFontColor,
      this.isBookingValid,
      this.blocBookingDateValidation});

  String? name;
  String? msg;
  Color? msgFontColor;
  bool? isBookingValid;
  BlocBookingDateValidationModel? blocBookingDateValidation;

  double averageRating(List<RatingModel> ratingList, String pointType) {
    double average = 0.0;

    if (ratingList.isNotEmpty) {
      for (RatingModel r in ratingList) {
        switch (pointType.toUpperCase()) {
          case "SECURITY":
            average = average + r.securityPoint!;
            break;
          case "SERVICE":
            average = average + r.servicePoint!;
            break;
          case "LOCATION":
            average = average + r.locationPoint!;
            break;
        }
      }
    }
    average = ratingList.isNotEmpty ? average / ratingList.length : 0;
    return double.parse(average.toStringAsFixed(2));
  }

  bool onCampaign(BlocHomestayModel bloc) {
    for (CampaignModel c in bloc.campaigns!) {
      if (c.status == "PROGRESSING") {
        return true;
      }
    }
    return false;
  }

  CampaignModel? campaign(BlocHomestayModel bloc) {
    for (CampaignModel c in bloc.campaigns!) {
      if (c.status == "PROGRESSING") {
        return c;
      }
    }
    return null;
  }

  int? newHomestayInBlocPrice(
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
