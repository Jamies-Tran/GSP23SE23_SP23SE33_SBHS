import 'package:staywithme_passenger_application/model/homestay_model.dart';

class BookingBlocHomestayModel {
  BookingBlocHomestayModel(
      {this.bookingRequestList,
      this.homestayServiceNameList,
      this.bookingFrom,
      this.bookingTo,
      this.paymentMethod});

  List<BookingBlocModel>? bookingRequestList;
  List<String>? homestayServiceNameList;
  String? bookingFrom;
  String? bookingTo;
  String? paymentMethod;

  Map<String, dynamic> toJson() => {
        "bookingRequestList":
            List.from(bookingRequestList!.map((e) => e.toJson())),
        "homestayServiceNameList": homestayServiceNameList,
        "bookingFrom": bookingFrom,
        "bookingTo": bookingTo,
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
      {this.id,
      this.bookingFrom,
      this.bookingTo,
      this.paymentMethod,
      this.totalBookingPrice,
      this.totalServicePrice,
      this.totalReservation,
      this.homestayType,
      this.homestayName,
      this.homestayServiceList,
      this.homestay,
      this.bookingDeposit});

  int? id;
  String? bookingFrom;
  String? bookingTo;
  String? paymentMethod;
  int? totalBookingPrice;
  int? totalServicePrice;
  int? price;
  int? totalReservation;
  String? homestayName;
  String? homestayType;
  List<String>? homestayServiceList;
  HomestayModel? homestay;
  BookingDepositModel? bookingDeposit;

  factory BookingHomestayModel.fromJson(Map<String, dynamic> json) =>
      BookingHomestayModel(
          id: json["id"],
          bookingFrom: json["bookingFrom"],
          bookingTo: json["bookingTo"],
          paymentMethod: json["paymentMethod"],
          totalBookingPrice: json["totalBookingPrice"],
          totalReservation: json["totalReservation"],
          homestay: HomestayModel.fromJson(json["homestay"]),
          bookingDeposit: json["bookingDeposit"] != null
              ? BookingDepositModel.fromJson(json["bookingDeposit"])
              : null);

  Map<String, dynamic> toJson() => {
        "bookingFrom": bookingFrom,
        "bookingTo": bookingTo,
        "paymentMethod": paymentMethod,
        "homestayServiceList": homestayServiceList,
        "totalBookingPrice": totalBookingPrice,
        "totalServicePrice": totalServicePrice,
        "totalReservation": totalReservation,
        "homestayName": homestayName
      };
}

class BookingDepositModel {
  BookingDepositModel(
      {this.id, this.unpaidAmount, this.paidAmount, this.depositForHomestay});

  int? id;
  int? paidAmount;
  int? unpaidAmount;
  String? depositForHomestay;

  factory BookingDepositModel.fromJson(Map<String, dynamic> json) =>
      BookingDepositModel(
          id: json["id"],
          unpaidAmount: json["unpaidAmount"],
          paidAmount: json["paidAmount"],
          depositForHomestay: json["depositForHomestay"]);

  Map<String, dynamic> toJson() => {
        "unpaidAmount": unpaidAmount,
        "paidAmount": paidAmount,
        "depositForHomestay": depositForHomestay
      };
}

class DepositModel {
  DepositModel({this.id, this.bookingDeposits});

  int? id;
  List<BookingDepositModel>? bookingDeposits;

  factory DepositModel.fromJson(Map<String, dynamic> json) => DepositModel(
      id: json["id"],
      bookingDeposits: List<BookingDepositModel>.from(
          json["bookingDeposits"].map((e) => BookingDepositModel.fromJson(e))));
}

class BookingModel {
  BookingModel(
      {this.id,
      this.totalBookingPrice,
      this.totalBookingDeposit,
      this.status,
      this.bookingHomestays,
      this.bookingHomestayServices,
      this.bookingDeposits});

  int? id;
  int? totalBookingPrice;
  int? totalBookingDeposit;
  String? status;
  List<BookingHomestayModel>? bookingHomestays;
  List<BookingServiceModel>? bookingHomestayServices;
  List<BookingDepositModel>? bookingDeposits;

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
      id: json["id"],
      totalBookingPrice: json["totalBookingPrice"],
      totalBookingDeposit: json["totalBookingDeposit"],
      status: json["status"],
      bookingHomestays: List<BookingHomestayModel>.from(json["bookingHomestays"]
          .map((e) => BookingHomestayModel.fromJson(e))),
      bookingHomestayServices: List<BookingServiceModel>.from(
          json["bookingHomestayServices"]
              .map((e) => BookingServiceModel.fromJson(e))),
      bookingDeposits: List<BookingDepositModel>.from(
          json["bookingDeposits"].map((e) => BookingDepositModel.fromJson(e))));
}

class BookingServiceModel {
  BookingServiceModel(
      {this.totalServicePrice, this.homestayService, this.homestayName});

  int? totalServicePrice;
  String? homestayName;
  HomestayServiceModel? homestayService;

  factory BookingServiceModel.fromJson(Map<String, dynamic> json) =>
      BookingServiceModel(
          totalServicePrice: json["totalServicePrice"],
          homestayService: json["homestayService"],
          homestayName: json["homestayName"]);
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
