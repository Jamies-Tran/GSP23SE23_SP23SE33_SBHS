import 'package:flutter/widgets.dart';
import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/screen/booking/booking_list_screen.dart';

abstract class BookingListEvent {}

class UpdateBookingDateEvent extends BookingListEvent {
  UpdateBookingDateEvent(
      {this.context,
      this.bookingStart,
      this.bookingEnd,
      this.booking,
      this.bookingId});

  BuildContext? context;
  String? bookingStart;
  String? bookingEnd;
  BookingModel? booking;
  int? bookingId;
}

class ChooseBookingHomestayEvent extends BookingListEvent {
  ChooseBookingHomestayEvent({this.bookingHomestay});

  BookingHomestayModel? bookingHomestay;
}

class ChooseViewHomestayListEvent extends BookingListEvent {
  ChooseViewHomestayListEvent();
}

class ChooseViewServiceListEvent extends BookingListEvent {
  ChooseViewServiceListEvent();
}

class ChooseNewHomestayServiceEvent extends BookingListEvent {
  ChooseNewHomestayServiceEvent({this.homestayService});

  HomestayServiceModel? homestayService;
}

class UpdateHomestayServiceEvent extends BookingListEvent {
  UpdateHomestayServiceEvent(
      {this.context,
      this.serviceNameList,
      this.bookingId,
      this.homestayName,
      this.homestayType});

  BuildContext? context;
  List<String>? serviceNameList;
  int? bookingId;
  String? homestayName;
  String? homestayType;
}

class CancelUpdateServiceEvent extends BookingListEvent {
  CancelUpdateServiceEvent({this.context});

  BuildContext? context;
}

class BrowseMoreHomestayEvent extends BookingListEvent {
  BrowseMoreHomestayEvent(
      {this.context, this.similarWithAnotherHomestay, this.homestay});

  BuildContext? context;
  bool? similarWithAnotherHomestay;
  HomestayModel? homestay;
}

class ForwardHomestayEvent extends BookingListEvent {
  ForwardHomestayEvent();
}

class BackwardHomestayEvent extends BookingListEvent {
  BackwardHomestayEvent();
}

class DeleteBookingHomestayEvent extends BookingListEvent {
  DeleteBookingHomestayEvent({this.homestayId, this.context});

  BuildContext? context;

  int? homestayId;
}

class ViewHomestayDetailScreenEvent extends BookingListEvent {
  ViewHomestayDetailScreenEvent({this.context, this.homestayName});

  BuildContext? context;
  String? homestayName;
}

class SubmitBookingEvent extends BookingListEvent {
  SubmitBookingEvent({this.context});

  BuildContext? context;
}

class ChooseHomestayListInBlocEvent extends BookingListEvent {
  ChooseHomestayListInBlocEvent(
      {this.context, this.booking, this.bloc, this.blocBookingValidation});

  BuildContext? context;
  BookingModel? booking;
  BlocHomestayModel? bloc;
  BlocBookingDateValidationModel? blocBookingValidation;
}

class ChoosePaymentMethodEvent extends BookingListEvent {
  ChoosePaymentMethodEvent({this.paymentMethod});

  BlocPaymentMethod? paymentMethod;
}
