import 'package:flutter/widgets.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

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
  ChooseNewHomestayServiceEvent({this.homestayService, this.isServiceBooked});

  HomestayServiceModel? homestayService;
  bool? isServiceBooked;
}

class UpdateHomestayServiceEvent extends BookingListEvent {
  UpdateHomestayServiceEvent(
      {this.context,
      this.serviceIdList,
      this.bookingId,
      this.homestayName,
      this.homestayType});

  BuildContext? context;
  List<int>? serviceIdList;
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

  PaymentMethod? paymentMethod;
}

class CopyInviteCodeEvent extends BookingListEvent {
  CopyInviteCodeEvent({this.inviteCode});

  String? inviteCode;
}

class CheckInForHomestayEvent extends BookingListEvent {
  CheckInForHomestayEvent({this.context, this.homestayId});

  BuildContext? context;
  int? homestayId;
}

class CheckOutForHomestayEvent extends BookingListEvent {
  CheckOutForHomestayEvent({this.context, this.homestayId});

  BuildContext? context;
  int? homestayId;
}

class CheckInForBlocEvent extends BookingListEvent {
  CheckInForBlocEvent({this.context});

  BuildContext? context;
}

class CheckOutForBlocEvent extends BookingListEvent {
  CheckOutForBlocEvent({this.context, this.bookingHomestay});

  BuildContext? context;
  BookingHomestayModel? bookingHomestay;
}

class UpdatePaymentMethodEvent extends BookingListEvent {
  UpdatePaymentMethodEvent({this.context, this.homestayId, this.paymentMethod});

  BuildContext? context;
  int? homestayId;
  PaymentMethod? paymentMethod;
}
