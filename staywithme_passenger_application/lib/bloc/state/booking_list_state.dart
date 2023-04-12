import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/screen/booking/booking_list_screen.dart';

class BookingListState {
  BookingListState({
    this.booking,
    this.homestayType,
    this.isBookingHomestay,
    this.activeUpdateService,
    this.bookingHomestayChosenList,
    this.bookingHomestayIndex,
    this.blocBookingValidation,
    this.serviceList = const <HomestayServiceModel>[],
    this.paymentMethod,
    this.viewDetail,
    this.isCopied,
  });

  BookingModel? booking;
  String? homestayType;
  List<BookingHomestayModel>? bookingHomestayChosenList;
  bool? isBookingHomestay;
  bool? activeUpdateService;
  int? bookingHomestayIndex;
  List<HomestayServiceModel>? serviceList;
  BlocBookingDateValidationModel? blocBookingValidation;
  BlocPaymentMethod? paymentMethod;
  bool? viewDetail;
  bool? isCopied;

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

  bool isServiceBooked(int serviceId) {
    for (BookingServiceModel s in booking!.bookingHomestayServices!) {
      if (s.homestayService!.id == serviceId) {
        return true;
      }
    }
    return false;
  }

  bool isServiceSelected(int serviceId) {
    for (HomestayServiceModel s in serviceList!) {
      if (s.id == serviceId) {
        return true;
      }
    }
    return false;
  }

  int totalChosenHomestayServicePrice() {
    int totalServicePrice = 0;
    for (HomestayServiceModel e in serviceList!) {
      totalServicePrice = totalServicePrice + e.price!;
    }
    return totalServicePrice;
  }

  TextEditingController bookingInviteCodeTxtController() {
    TextEditingController txtController = TextEditingController();
    if (booking!.inviteCode != null) {
      txtController.text = booking!.inviteCode!.inviteCode!;
    }

    return txtController;
  }

  bool? isCheckInDate() {
    List<String> bookingStartString = booking!.bookingFrom!.split("-");
    DateTime now = DateTime.now();
    List<String> nowString = dateFormat.format(now).split("-");
    now = DateTime(int.parse(nowString.elementAt(0)),
        int.parse(nowString.elementAt(1)), int.parse(nowString.elementAt(2)));
    DateTime bookingFromDate = DateTime(
        int.parse(bookingStartString.elementAt(0)),
        int.parse(bookingStartString.elementAt(1)),
        int.parse(bookingStartString.elementAt(2)));
    return now.isAtSameMomentAs(bookingFromDate);
  }

  bool? isCheckoutDate() {
    List<String> bookingStartString = booking!.bookingTo!.split("-");
    DateTime now = DateTime.now();
    List<String> nowString = dateFormat.format(now).split("-");
    now = DateTime(int.parse(nowString.elementAt(0)),
        int.parse(nowString.elementAt(1)), int.parse(nowString.elementAt(2)));
    DateTime bookingFromDate = DateTime(
        int.parse(bookingStartString.elementAt(0)),
        int.parse(bookingStartString.elementAt(1)),
        int.parse(bookingStartString.elementAt(2)));
    return now.isAtSameMomentAs(bookingFromDate);
  }
}
