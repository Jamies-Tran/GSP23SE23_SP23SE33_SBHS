import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/model/passenger_model.dart';

class BookingBlocHomestayModel {
  BookingBlocHomestayModel(
      {this.blocName,
      this.bookingRequestList,
      this.homestayServiceNameList,
      this.totalBookingPrice,
      this.totalServicePrice,
      this.paymentMethod});

  List<BookingBlocModel>? bookingRequestList;
  List<String>? homestayServiceNameList;
  int? totalBookingPrice;
  int? totalServicePrice;
  String? blocName;

  String? paymentMethod;

  Map<String, dynamic> toJson() => {
        "bookingRequestList":
            List.from(bookingRequestList!.map((e) => e.toJson())),
        "blocName": blocName,
        "totalBookingPrice": totalBookingPrice,
        "totalServicePrice": totalServicePrice,
        "homestayServiceNameList": homestayServiceNameList,
        "paymentMethod": paymentMethod
      };
}

class BookingBlocModel {
  BookingBlocModel(
      {this.totalBookingPrice, this.totalReservation, this.homestayName});

  int? totalReservation;
  int? totalBookingPrice;
  String? homestayName;

  Map<String, dynamic> toJson() => {
        "totalBookingPrice": totalBookingPrice,
        "totalReservation": totalReservation,
        "homestayName": homestayName
      };
}

class BookingHomestayModel {
  BookingHomestayModel(
      {this.bookingHomestayId,
      this.paymentMethod,
      this.totalBookingPrice,
      this.totalServicePrice,
      this.totalReservation,
      this.status,
      this.homestayName,
      this.homestayServiceList,
      this.homestay,
      this.rating});

  BookingHomestayIdModel? bookingHomestayId;
  String? paymentMethod;
  int? totalBookingPrice;
  int? totalServicePrice;
  int? totalReservation;
  String? status;
  String? homestayName;
  List<String>? homestayServiceList;
  HomestayModel? homestay;
  RatingModel? rating;

  factory BookingHomestayModel.fromJson(Map<String, dynamic> json) =>
      BookingHomestayModel(
          bookingHomestayId:
              BookingHomestayIdModel.fromJson(json["bookingHomestayId"]),
          paymentMethod: json["paymentMethod"],
          totalBookingPrice: json["totalBookingPrice"],
          totalReservation: json["totalReservation"],
          status: json["status"],
          homestay: HomestayModel.fromJson(json["homestay"]),
          rating: json["rating"] != null
              ? RatingModel.fromJson(json["rating"])
              : null);

  Map<String, dynamic> toJson() => {
        "paymentMethod": paymentMethod,
        "homestayServiceList": homestayServiceList,
        "totalBookingPrice": totalBookingPrice,
        "totalServicePrice": totalServicePrice,
        "totalReservation": totalReservation,
        "homestay": homestay!.toJson(),
        "homestayName": homestayName,
      };
}

class BookingHomestayIdModel {
  BookingHomestayIdModel({this.bookingId, this.homestayId});
  int? bookingId;
  int? homestayId;

  factory BookingHomestayIdModel.fromJson(Map<String, dynamic> json) =>
      BookingHomestayIdModel(
          bookingId: json["bookingId"], homestayId: json["homestayId"]);
}

class BookingDepositModel {
  BookingDepositModel(
      {this.unpaidAmount,
      this.paidAmount,
      this.depositForHomestay,
      this.status,
      this.booking});

  int? paidAmount;
  int? unpaidAmount;
  String? depositForHomestay;
  String? status;
  BookingModel? booking;

  factory BookingDepositModel.fromJson(Map<String, dynamic> json) =>
      BookingDepositModel(
          unpaidAmount: json["unpaidAmount"],
          paidAmount: json["paidAmount"],
          depositForHomestay: json["depositForHomestay"],
          status: json["status"],
          booking: BookingModel.fromJson(json["booking"]));

  Map<String, dynamic> toJson() => {
        "unpaidAmount": unpaidAmount,
        "paidAmount": paidAmount,
        "depositForHomestay": depositForHomestay,
      };
}

class DepositModel {
  DepositModel({this.id, this.bookingDeposits, this.createdDate});

  int? id;
  List<BookingDepositModel>? bookingDeposits;
  String? createdDate;

  factory DepositModel.fromJson(Map<String, dynamic> json) => DepositModel(
      id: json["id"],
      bookingDeposits: List<BookingDepositModel>.from(
          json["bookingDeposits"].map((e) => BookingDepositModel.fromJson(e))),
      createdDate: json["createdDate"]);
}

class BookingModel {
  BookingModel(
      {this.id,
      this.code,
      this.bookingFrom,
      this.bookingTo,
      this.homestayType,
      this.totalBookingPrice,
      this.totalBookingDeposit,
      this.status,
      this.bloc,
      this.inviteCode,
      this.bookingHomestays,
      this.bookingHomestayServices,
      this.rating});

  int? id;
  String? code;
  String? bookingFrom;
  String? bookingTo;
  String? homestayType;
  int? totalBookingPrice;
  int? totalBookingDeposit;
  String? status;
  BlocHomestayModel? bloc;
  BookingInviteModel? inviteCode;
  List<BookingHomestayModel>? bookingHomestays;
  List<BookingServiceModel>? bookingHomestayServices;
  RatingModel? rating;

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
      id: json["id"],
      code: json["code"],
      bookingFrom: json["bookingFrom"],
      bookingTo: json["bookingTo"],
      homestayType: json["homestayType"],
      totalBookingPrice: json["totalBookingPrice"],
      totalBookingDeposit: json["totalBookingDeposit"],
      status: json["status"],
      bloc: json["blocResponse"] != null
          ? BlocHomestayModel.fromJson(json["blocResponse"])
          : null,
      inviteCode: json["inviteCode"] != null
          ? BookingInviteModel.fromJson(json["inviteCode"])
          : null,
      bookingHomestays: List<BookingHomestayModel>.from(json["bookingHomestays"]
          .map((e) => BookingHomestayModel.fromJson(e))),
      bookingHomestayServices: List<BookingServiceModel>.from(
          json["bookingHomestayServices"]
              .map((e) => BookingServiceModel.fromJson(e))),
      rating:
          json["rating"] != null ? RatingModel.fromJson(json["rating"]) : null);

  Map<String, dynamic> toJson() => {
        "id": id,
        "bookingFrom": bookingFrom,
        "bookingTo": bookingTo,
        "totalBookingPrice": totalBookingPrice,
        "bookingHomestays": bookingHomestays!.map((e) => e.toJson()).toList(),
        "bookingHomestayServices": bookingHomestayServices != null
            ? bookingHomestayServices!.map((e) => e.toJson()).toList()
            : <BookingServiceModel>[]
      };
}

class BookingServiceModel {
  BookingServiceModel(
      {this.id,
      this.totalServicePrice,
      this.homestayService,
      this.homestayName});

  int? id;
  int? totalServicePrice;
  String? homestayName;
  HomestayServiceModel? homestayService;

  factory BookingServiceModel.fromJson(Map<String, dynamic> json) =>
      BookingServiceModel(
          totalServicePrice: json["totalServicePrice"],
          homestayService:
              HomestayServiceModel.fromJson(json["homestayService"]),
          homestayName: json["homestayName"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "totalServicePrice": totalServicePrice,
        "homestayName": homestayName,
        "homestayService": homestayService!.toJson(),
      };
}

class BookingValidateModel {
  BookingValidateModel(
      {this.bookingStart,
      this.bookingEnd,
      this.homestayName,
      this.totalReservation});

  String? bookingStart;
  String? bookingEnd;
  String? homestayName;
  int? totalReservation;

  Map<String, dynamic> toJson() => {
        "bookingStart": bookingStart,
        "bookingEnd": bookingEnd,
        "homestayName": homestayName,
        "totalReservation": totalReservation
      };
}

class BlocBookingDateValidationModel {
  BlocBookingDateValidationModel({this.homestays});

  List<HomestayModel>? homestays;

  factory BlocBookingDateValidationModel.fromJson(Map<String, dynamic> json) =>
      BlocBookingDateValidationModel(
          homestays: json["homestays"] != null
              ? List<HomestayModel>.from(
                  json["homestays"].map((e) => HomestayModel.fromJson(e)))
              : <HomestayModel>[]);
}

class BookingHistoryModel {
  BookingHistoryModel({this.bookings, this.pageNumber});

  List<BookingModel>? bookings;
  int? pageNumber;

  factory BookingHistoryModel.fromJson(Map<String, dynamic> json) =>
      BookingHistoryModel(
          bookings: json["bookings"] != null
              ? List<BookingModel>.from(
                  json["bookings"].map((e) => BookingModel.fromJson(e)))
              : <BookingModel>[],
          pageNumber: json["pageNumber"]);
}

class FilterBookingModel {
  FilterBookingModel({this.homestayType, this.status, this.isHost});

  String? homestayType;
  String? status;
  bool? isHost;

  Map<String, dynamic> toJson() =>
      {"homestayType": homestayType, "status": status, "isHost": isHost};
}

class BookingInviteModel {
  BookingInviteModel(
      {this.id, this.inviteCode, this.status, this.booking, this.passenger});

  int? id;
  String? inviteCode;
  String? status;
  BookingModel? booking;
  PassengerModel? passenger;

  factory BookingInviteModel.fromJson(Map<String, dynamic> json) =>
      BookingInviteModel(
          id: json["id"],
          inviteCode: json["inviteCode"],
          booking: json["bookingResponse"] != null
              ? BookingModel.fromJson(json["bookingResponse"])
              : null,
          passenger: json["passengerResponse"] != null
              ? PassengerModel.fromJson(json["passengerResponse"])
              : null,
          status: json["status"]);
}
