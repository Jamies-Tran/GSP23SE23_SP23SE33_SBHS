import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/service/authentication/firebase_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';
import 'package:http/http.dart' as http;

abstract class IBookingService {
  Future<dynamic> createBooking(String username);

  Future<dynamic> saveHomestayForBooking(
      String username, BookingHomestayModel bookingHomestayModel);

  Future<dynamic> saveBlocForBooking(
      String username, BookingBlocHomestayModel bookingBlocHomestayModel);

  Future<dynamic> submitBooking(String username, int bookingId);

  Future<dynamic> checkValidBookingDateForHomestay(
      BookingValidateModel bookingValidateModel);

  Future<dynamic> getBlocAvailableHomestayList(
      BookingValidateModel bookingValidateModel);

  Future<dynamic> getBookingHomestsayById(String username, int homestayId);
}

class BookingService extends IBookingService {
  final firebaseService = locator.get<IFirebaseService>();

  @override
  Future createBooking(String username) async {
    final client = http.Client();
    final uri = Uri.parse(createBookingUrl);
    try {
      final token = await firebaseService.getUserTokenByUsername(username);
      if (token is String) {
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
      }
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }

  @override
  Future saveHomestayForBooking(
      String username, BookingHomestayModel bookingHomestayModel) async {
    final client = http.Client();
    Uri uri = Uri.parse(saveHomestayUrl);
    try {
      final token = await firebaseService.getUserTokenByUsername(username);
      if (token is String) {
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
      }
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }

  @override
  Future saveBlocForBooking(String username,
      BookingBlocHomestayModel bookingBlocHomestayModel) async {
    final client = http.Client();
    Uri uri = Uri.parse(saveBlocUrl);
    try {
      final token = await firebaseService.getUserTokenByUsername(username);
      if (token is String) {
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
      }
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }

  @override
  Future submitBooking(String username, int bookingId) async {
    final client = http.Client();
    Uri uri = Uri.parse("$submitBookingUrl?bookingId=$bookingId");
    try {
      final token = await firebaseService.getUserTokenByUsername(username);
      if (token is String) {
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
  Future getBookingHomestsayById(String username, int homestayId) async {
    final client = http.Client();
    final uri = Uri.parse("$bookingHomestayUrl?homestayId=$homestayId");
    try {
      final token = await firebaseService.getUserTokenByUsername(username);
      if (token is String) {
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
}
