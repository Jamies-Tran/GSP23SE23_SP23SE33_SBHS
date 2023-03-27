import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

class BookingBlocHomestayState {
  BookingBlocHomestayState(
      {this.bloc,
      this.bookingId,
      this.bookingEnd,
      this.bookingStart,
      this.selectedIndex,
      this.blocBookingDateValidation,
      this.bookingBlocList,
      this.blocServiceList,
      this.totalHomestayPrice,
      this.totalServicePrice});

  BlocHomestayModel? bloc;
  int? bookingId;
  String? bookingStart;
  String? bookingEnd;
  int? selectedIndex;
  BlocBookingDateValidationModel? blocBookingDateValidation;
  List<BookingBlocModel>? bookingBlocList;
  List<HomestayServiceModel>? blocServiceList;
  int? totalHomestayPrice;
  int? totalServicePrice;
}
