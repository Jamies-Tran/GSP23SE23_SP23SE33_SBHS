import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/screen/booking/booking_bloc_screen.dart';

class OverviewBookingBlocState {
  OverviewBookingBlocState(
      {this.bookingStart,
      this.bookingEnd,
      this.bookingBlocList,
      this.blocServiceList,
      this.bloc,
      this.bookingId,
      this.totalHomestayPrice,
      this.totalServicePrice,
      this.paymentMethod});

  String? bookingStart;
  String? bookingEnd;
  List<BookingBlocModel>? bookingBlocList;
  List<HomestayServiceModel>? blocServiceList;
  BlocHomestayModel? bloc;
  int? bookingId;
  int? totalHomestayPrice;
  int? totalServicePrice;
  BlocPaymentMethod? paymentMethod;

  int? totalBookingPrice() {
    DateTime bookingStartDate = DateTime.parse(bookingStart!);
    DateTime bookingEndDate = DateTime.parse(bookingEnd!);
    int duration = bookingEndDate.difference(bookingStartDate).inDays;
    int totalBookingPrice = totalHomestayPrice! * duration;
    return totalBookingPrice;
  }

  BookingBlocHomestayModel bookingBlocHomestayModel() {
    String paymentMethodString = "";
    switch (paymentMethod) {
      case BlocPaymentMethod.swm_wallet:
        paymentMethodString = "SWM_WALLET";
        break;
      case BlocPaymentMethod.cash:
        paymentMethodString = "CASH";
        break;
      default:
        break;
    }
    BookingBlocHomestayModel bookingBlocHomestay = BookingBlocHomestayModel(
        blocName: bloc!.name,
        totalBookingPrice: totalBookingPrice(),
        totalServicePrice: totalServicePrice,
        bookingRequestList: bookingBlocList,
        homestayServiceNameList: blocServiceList!.map((e) => e.name!).toList(),
        paymentMethod: paymentMethodString);
    return bookingBlocHomestay;
  }
}
