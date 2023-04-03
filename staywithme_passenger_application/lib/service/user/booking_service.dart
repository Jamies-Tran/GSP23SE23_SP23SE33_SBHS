import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/service/share_preference/share_preference.dart';
import 'package:http/http.dart' as http;

abstract class IBookingService {
  Future<dynamic> createBooking(
      String homestayType, String bookingFrom, String bookingTo);

  Future<dynamic> saveHomestayForBooking(
      BookingHomestayModel bookingHomestayModel);

  Future<dynamic> saveBlocForBooking(
      BookingBlocHomestayModel bookingBlocHomestayModel);

  Future<dynamic> submitBooking(int bookingId);

  Future<dynamic> checkValidBookingDateForHomestay(
      BookingValidateModel bookingValidateModel);

  Future<dynamic> getBlocAvailableHomestayList(
      BookingValidateModel bookingValidateModel);

  Future<dynamic> getBookingHomestsayByHomestayId(int homestayId);

  Future<dynamic> getBookingById(int bookingId);

  Future<dynamic> updateBooking(BookingModel booking, int bookingId);

  Future<dynamic> updateBookingServices(
      List<String> serviceNameList, int bookingId, String homestayName);
}

class BookingService extends IBookingService {
  @override
  Future createBooking(
      String homestayType, String bookingFrom, String bookingTo) async {
    final client = http.Client();
    final uri = Uri.parse(
        "$createBookingUrl?homestayType=$homestayType&bookingFrom=$bookingFrom&bookingTo=$bookingTo");
    try {
      final userLoginInfo = await SharedPreferencesService.getUserLoginInfo();
      String token = userLoginInfo['accessToken']!;
      final response = await client.post(uri, headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      }).timeout(Duration(seconds: connectionTimeOut));
      if (response.statusCode == 200) {
        BookingModel bookingModel =
            BookingModel.fromJson(json.decode(response.body));
        return bookingModel;
      } else {
        ServerExceptionModel serverExceptionModel =
            ServerExceptionModel.fromJson(json.decode(response.body));
        return serverExceptionModel;
      }
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }

  @override
  Future saveHomestayForBooking(
      BookingHomestayModel bookingHomestayModel) async {
    final client = http.Client();
    Uri uri = Uri.parse(saveHomestayUrl);
    try {
      final userLoginInfo = await SharedPreferencesService.getUserLoginInfo();
      String token = userLoginInfo['accessToken']!;
      final response = await client
          .post(uri,
              headers: {
                "content-type": "application/json",
                "Authorization": "Bearer $token"
              },
              body: json.encode(bookingHomestayModel.toJson()))
          .timeout(Duration(seconds: connectionTimeOut));
      if (response.statusCode == 200) {
        BookingHomestayModel bookingHomestayModel =
            BookingHomestayModel.fromJson(json.decode(response.body));
        return bookingHomestayModel;
      } else {
        ServerExceptionModel serverExceptionModel =
            ServerExceptionModel.fromJson(json.decode(response.body));
        return serverExceptionModel;
      }
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }

  @override
  Future saveBlocForBooking(
      BookingBlocHomestayModel bookingBlocHomestayModel) async {
    final client = http.Client();
    Uri uri = Uri.parse(saveBlocUrl);
    try {
      final userLoginInfo = await SharedPreferencesService.getUserLoginInfo();
      String token = userLoginInfo['accessToken']!;
      final response = await client
          .post(uri,
              headers: {
                "content-type": "application/json",
                "Authorization": "Bearer $token"
              },
              body: json.encode(bookingBlocHomestayModel.toJson()))
          .timeout(Duration(seconds: connectionTimeOut));
      if (response.statusCode == 200) {
        List<BookingHomestayModel> bookingHomestayList =
            List<BookingHomestayModel>.from(json
                .decode(response.body)
                .map((e) => BookingHomestayModel.fromJson(e)));
        return bookingHomestayList;
      } else {
        ServerExceptionModel serverExceptionModel =
            ServerExceptionModel.fromJson(json.decode(response.body));
        return serverExceptionModel;
      }
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }

  @override
  Future submitBooking(int bookingId) async {
    final client = http.Client();
    Uri uri = Uri.parse("$submitBookingUrl?bookingId=$bookingId");
    try {
      final userLoginInfo = await SharedPreferencesService.getUserLoginInfo();
      String token = userLoginInfo['accessToken']!;
      final response = await client.put(uri, headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      }).timeout(Duration(seconds: connectionTimeOut));
      if (response.statusCode == 200) {
        BookingModel bookingModel =
            BookingModel.fromJson(json.decode(response.body));
        return bookingModel;
      } else {
        ServerExceptionModel serverExceptionModel =
            ServerExceptionModel.fromJson(json.decode(response.body));
        return serverExceptionModel;
      }
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }

  @override
  Future checkValidBookingDateForHomestay(
      BookingValidateModel bookingValidateModel) async {
    final client = http.Client();
    final uri = Uri.parse(homestayBookingDateValidationUrl);
    try {
      final response = await client
          .post(uri,
              headers: {"content-type": "application/json"},
              body: json.encode(bookingValidateModel.toJson()))
          .timeout(Duration(seconds: connectionTimeOut));
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 409) {
        return false;
      } else {
        ServerExceptionModel serverExceptionModel =
            ServerExceptionModel.fromJson(json.decode(response.body));
        return serverExceptionModel;
      }
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }

  @override
  Future getBookingHomestsayByHomestayId(int homestayId) async {
    final client = http.Client();
    final uri = Uri.parse("$bookingHomestayUrl?homestayId=$homestayId");
    try {
      final userLoginInfo = await SharedPreferencesService.getUserLoginInfo();
      String token = userLoginInfo['accessToken']!;
      final response = await client.get(uri, headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      }).timeout(Duration(seconds: connectionTimeOut));
      if (response.statusCode == 200) {
        BookingHomestayModel? bookingHomestayModel =
            BookingHomestayModel.fromJson(json.decode(response.body));
        return bookingHomestayModel;
      } else {
        ServerExceptionModel serverExceptionModel =
            ServerExceptionModel.fromJson(json.decode(response.body));
        return serverExceptionModel;
      }
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }

  @override
  Future getBlocAvailableHomestayList(
      BookingValidateModel bookingValidateModel) async {
    final client = http.Client();
    final uri = Uri.parse(blocAvailableHomestaysUrl);
    try {
      final response = await client.post(uri,
          headers: {"content-type": "application/json"},
          body: json.encode(bookingValidateModel.toJson()));
      if (response.statusCode == 200) {
        BlocBookingDateValidationModel blocBookingValidation =
            BlocBookingDateValidationModel.fromJson(json.decode(response.body));
        return blocBookingValidation;
      } else {
        ServerExceptionModel serverExceptionModel =
            ServerExceptionModel.fromJson(json.decode(response.body));
        return serverExceptionModel;
      }
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }

  @override
  Future getBookingById(int bookingId) async {
    final client = http.Client();
    final uri = Uri.parse("$bookingUrl?bookingId=$bookingId");
    try {
      final userLoginInfo = await SharedPreferencesService.getUserLoginInfo();
      String accessToken = userLoginInfo["accessToken"]!;
      final response = await client.get(uri, headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $accessToken"
      }).timeout(Duration(seconds: connectionTimeOut));
      if (response.statusCode == 200) {
        BookingModel booking =
            BookingModel.fromJson(json.decode(response.body));
        return booking;
      } else {
        ServerExceptionModel serverExceptionModel =
            ServerExceptionModel.fromJson(json.decode(response.body));
        return serverExceptionModel;
      }
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }

  @override
  Future updateBooking(BookingModel booking, int bookingId) async {
    final client = http.Client();
    final uri = Uri.parse("$bookingUrl?bookingId=$bookingId");
    try {
      final userLoginInfo = await SharedPreferencesService.getUserLoginInfo();
      final accessToken = userLoginInfo["accessToken"];
      final response = await client.put(uri,
          headers: {
            "content-type": "application/json",
            "Authorization": "Bearer $accessToken"
          },
          body: json.encode(booking.toJson()));

      if (response.statusCode == 200) {
        BookingModel bookingModel =
            BookingModel.fromJson(json.decode(response.body));
        return bookingModel;
      } else {
        ServerExceptionModel serverExceptionModel =
            ServerExceptionModel.fromJson(json.decode(response.body));
        return serverExceptionModel;
      }
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }

  @override
  Future updateBookingServices(
      List<String> serviceNameList, int bookingId, String homestayName) async {
    final client = http.Client();
    final uri = Uri.parse(
        "$bookingUpdateServiceUrl?bookingId=$bookingId&homestayName=$homestayName");
    try {
      final userLoginInfo = await SharedPreferencesService.getUserLoginInfo();
      final accessToken = userLoginInfo["accessToken"];
      final response = await client
          .put(uri,
              headers: {
                "content-type": "application/json",
                "Authorization": "Bearer $accessToken"
              },
              body: json.encode(serviceNameList))
          .timeout(Duration(seconds: connectionTimeOut));
      if (response.statusCode == 200) {
        BookingModel bookingModel =
            BookingModel.fromJson(json.decode(response.body));
        return bookingModel;
      } else {
        ServerExceptionModel serverExceptionModel =
            ServerExceptionModel.fromJson(json.decode(response.body));
        return serverExceptionModel;
      }
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }
}
