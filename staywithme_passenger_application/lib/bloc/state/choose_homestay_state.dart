import 'package:staywithme_passenger_application/model/booking_model.dart';

class ChooseHomestayState {
  ChooseHomestayState({this.bookingBlocList = const <BookingBlocModel>[]});

  List<BookingBlocModel> bookingBlocList;

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
}
