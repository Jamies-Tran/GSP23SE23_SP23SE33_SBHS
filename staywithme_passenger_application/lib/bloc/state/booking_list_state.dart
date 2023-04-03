import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

class BookingListState {
  BookingListState(
      {this.booking,
      this.homestayType,
      this.isBookingHomestay,
      this.activeUpdateService,
      this.bookingHomestayChosenList,
      this.bookingHomestayIndex,
      this.serviceNameList = const <String>[]});

  BookingModel? booking;
  String? homestayType;
  List<BookingHomestayModel>? bookingHomestayChosenList;
  bool? isBookingHomestay;
  bool? activeUpdateService;
  int? bookingHomestayIndex;
  List<String>? serviceNameList;

  int totalBookingServicePrice(String homestayName) {
    List<BookingServiceModel> bookingServiceList = booking!
        .bookingHomestayServices!
        .where((element) => element.homestayName == homestayName)
        .toList();
    int totalPrice = 0;
    for (BookingServiceModel b in bookingServiceList) {
      totalPrice = totalPrice + b.totalServicePrice!;
    }
    return totalPrice;
  }

  HomestayModel? selectedHomestay() {
    HomestayModel homestay =
        booking!.bookingHomestays![bookingHomestayIndex!].homestay!;
    return homestay;
  }

  bool isBookingHomestayChosen(BookingHomestayModel bookingHomestay) {
    for (BookingHomestayModel b in bookingHomestayChosenList!) {
      if (bookingHomestay.bookingHomestayId!.bookingId ==
              b.bookingHomestayId!.bookingId &&
          bookingHomestay.bookingHomestayId!.homestayId ==
              b.bookingHomestayId!.homestayId) {
        return true;
      }
    }
    return false;
  }

  bool isServiceBooked(String serviceName) {
    for (String s in serviceNameList!) {
      if (s == serviceName) {
        return true;
      }
    }
    return false;
  }

  int totalChosenHomestayServicePrice() {
    int totalServicePrice = 0;
    for (BookingHomestayModel b in booking!.bookingHomestays!) {
      for (HomestayServiceModel s in b.homestay!.homestayServices!) {
        for (String e in serviceNameList!) {
          if (s.name! == e) {
            totalServicePrice = totalServicePrice + s.price!;
          }
        }
      }
    }
    return totalServicePrice;
  }
}
