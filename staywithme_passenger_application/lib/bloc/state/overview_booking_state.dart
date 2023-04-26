import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/campaign_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

class OverviewBookingState {
  OverviewBookingState(
      {this.homestay,
      this.bookingStart,
      this.bookingEnd,
      this.totalReservation,
      this.homestayServiceList = const <HomestayServiceModel>[],
      this.totalServicePrice,
      this.paymentMethod});

  HomestayModel? homestay;
  String? bookingStart;
  String? bookingEnd;
  int? totalReservation;
  List<HomestayServiceModel>? homestayServiceList;
  int? totalServicePrice;
  PaymentMethod? paymentMethod;

  int totalBookingPrice() {
    DateTime bookingStartDate = DateTime.parse(bookingStart!);
    DateTime bookingEndDate = DateTime.parse(bookingEnd!);
    int duration = bookingEndDate.difference(bookingStartDate).inDays;
    int currentHomestayPrice = homestay!.price!;
    for (CampaignModel c in homestay!.campaigns!) {
      if (c.status == "PROGRESSING") {
        int discountAmount =
            currentHomestayPrice * c.discountPercentage! ~/ 100;
        currentHomestayPrice = currentHomestayPrice - discountAmount;
      }
    }
    int totalBookingPrice = currentHomestayPrice * duration;
    return totalBookingPrice;
  }

  BookingHomestayModel bookingHomestayModel() {
    String paymentMethodString = "";
    switch (paymentMethod) {
      case PaymentMethod.cash:
        paymentMethodString = "CASH";
        break;
      case PaymentMethod.swm_wallet:
        paymentMethodString = "SWM_WALLET";
        break;
      default:
        break;
    }
    return BookingHomestayModel(
        homestayServiceList: homestayServiceList!.map((e) => e.name!).toList(),
        totalBookingPrice: totalBookingPrice(),
        totalServicePrice: totalServicePrice,
        totalReservation: totalReservation,
        paymentMethod: paymentMethodString,
        homestay: homestay,
        homestayName: homestay!.name);
  }
}
