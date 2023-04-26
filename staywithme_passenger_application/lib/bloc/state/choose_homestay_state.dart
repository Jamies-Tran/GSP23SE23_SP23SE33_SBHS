import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/campaign_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

class ChooseHomestayState {
  ChooseHomestayState(
      {this.bookingBlocList = const <BookingBlocModel>[], this.bloc});

  List<BookingBlocModel> bookingBlocList;
  BlocHomestayModel? bloc;

  bool isHomestaySelected(String homestayName) {
    for (BookingBlocModel bookingBlocModel in bookingBlocList) {
      if (bookingBlocModel.homestayName == homestayName) {
        return true;
      }
    }
    return false;
  }

  int totalHomestayPrice() {
    int totalPrice = 0;
    for (BookingBlocModel bookingBlocModel in bookingBlocList) {
      totalPrice = totalPrice + bookingBlocModel.totalBookingPrice!;
    }

    return totalPrice;
  }

  bool onCampaign() {
    for (CampaignModel c in bloc!.campaigns!) {
      if (c.status == "PROGRESSING") {
        return true;
      }
    }
    return false;
  }

  int? newHomestayInBlocPrice(HomestayModel homestay) {
    int currentHomestayInBlocPrice = homestay.price!;
    for (CampaignModel c in bloc!.campaigns!) {
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
