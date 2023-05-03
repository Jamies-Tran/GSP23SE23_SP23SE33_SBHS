import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/model/campaign_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

class HomestayDetailState {
  HomestayDetailState(
      {this.msg, this.msgFontColor, this.isBookingValid, this.imgIndex});

  String? msg;
  bool? isBookingValid;
  Color? msgFontColor;
  int? imgIndex;

  HomestayImageModel currentHomestayImage(
      List<HomestayImageModel> homestayImages) {
    return homestayImages[imgIndex!];
  }

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

  bool onCampaign(HomestayModel homestay) {
    for (CampaignModel c in homestay.campaigns!) {
      if (c.status == "PROGRESSING") {
        return true;
      }
    }
    return false;
  }

  CampaignModel? campaign(HomestayModel homestay) {
    for (CampaignModel c in homestay.campaigns!) {
      if (c.status == "PROGRESSING") {
        return c;
      }
    }
    return null;
  }

  int? newPrice(HomestayModel homestay) {
    int currentPrice = homestay.price!;
    for (CampaignModel c in homestay.campaigns!) {
      if (c.status == "PROGRESSING") {
        int discountAmount = currentPrice * c.discountPercentage! ~/ 100;
        currentPrice = currentPrice - discountAmount;
      }
    }
    return currentPrice;
  }
}
