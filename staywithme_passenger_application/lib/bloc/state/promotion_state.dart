import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/promotion_model.dart';

class PromotionState {
  PromotionState(
      {this.booking,
      this.homestayType,
      this.status,
      this.paymentMethod,
      this.promotions,
      this.totalBookingPriceAfterDiscount});

  BookingModel? booking;
  String? homestayType;
  String? status;
  String? paymentMethod;
  List<PromotionModel>? promotions;
  int? totalBookingPriceAfterDiscount;

  bool isPromotionChosen(PromotionModel promotion) {
    for (PromotionModel p in promotions!) {
      if (p.code == promotion.code) {
        return true;
      }
    }
    return false;
  }

  int? totalDiscountAmount() {
    int totalDiscountAmount = totalBookingPriceAfterDiscount! > 0
        ? booking!.totalBookingPrice! - totalBookingPriceAfterDiscount!
        : 0;
    return totalDiscountAmount;
  }
}
