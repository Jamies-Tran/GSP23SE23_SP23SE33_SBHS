import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/rating_homestay_event.dart';
import 'package:staywithme_passenger_application/bloc/state/rating_homestay_state.dart';

import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/screen/booking/booking_list_screen.dart';
import 'package:staywithme_passenger_application/screen/main_screen.dart';
import 'package:staywithme_passenger_application/screen/rating/rating_screen.dart';
import 'package:staywithme_passenger_application/service/user/rating_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class RatingHomestayBloc {
  final eventController = StreamController<RatingHomestayEvent>();
  final stateController = StreamController<RatingHomestayState>();

  final _ratingService = locator.get<IRatingService>();

  BookingHomestayModel? _bookingHomestay;
  BlocBookingDateValidationModel? _blocBookingValidation;
  double? _securityPoint = 5.0;
  double? _servicePoint = 5.0;
  double? _locationPoint = 5.0;
  String? _comment;
  bool? _isRatingFinished = false;
  BookingModel? _booking;
  String? _homestayType;
  bool? _viewDetail;

  RatingHomestayState initData(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    _bookingHomestay = contextArguments["bookingHomestay"];
    _booking = contextArguments["booking"];
    _homestayType = contextArguments["homestayType"];
    _viewDetail = contextArguments["viewDetail"];
    _blocBookingValidation = contextArguments["blocBookingValidation"];
    return RatingHomestayState(
        bookingHomestay: contextArguments["bookingHomestay"],
        securityPoint: 5.0,
        servicePoint: 5.0,
        locationPoint: 5.0,
        comment: null,
        isRatingFinished: contextArguments["isRatingFinished"] ?? false,
        booking: contextArguments["booking"],
        homestayType: contextArguments["homestayType"],
        viewDetail: contextArguments["viewDetail"],
        blocBookingValidation: contextArguments["blocBookingValidation"]);
  }

  void dispose() {
    eventController.close();
    stateController.close();
  }

  RatingHomestayBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  Future<void> eventHandler(RatingHomestayEvent event) async {
    if (event is RatingSecurityForHomestayEvent) {
      _securityPoint = event.securityPoint;
    } else if (event is RatingServiceForHomestayEvent) {
      _servicePoint = event.servicePoint;
    } else if (event is RatingLocationForHomestayEvent) {
      _locationPoint = event.locationPoint;
    } else if (event is CommentForHomestayEvent) {
      _comment = event.comment;
    } else if (event is SubmitRatingHomestayEvent) {
      final ratingData = _homestayType == "homestay"
          ? await _ratingService.ratingHomestay(event.rating!)
          : await _ratingService.ratingBloc(event.rating!);
      _isRatingFinished = true;
      if (ratingData is RatingModel) {
        if (_homestayType == "homestay") {
          Navigator.pushReplacementNamed(
              event.context!, RatingHomestayScreen.ratingHomestayScreenRoute,
              arguments: {
                "isRatingFinished": _isRatingFinished,
                "bookingHomestay": _bookingHomestay,
                "booking": _booking,
                "homestayType": _homestayType,
                "viewDetail": _viewDetail
              });
        } else {
          Navigator.pushReplacementNamed(
              event.context!, RatingHomestayScreen.ratingHomestayScreenRoute,
              arguments: {
                "isRatingFinished": _isRatingFinished,
                "blocBookingValidation": _blocBookingValidation,
                "booking": _booking,
                "homestayType": _homestayType,
                "viewDetail": _viewDetail
              });
        }
      } else if (ratingData is ServerExceptionModel) {
        showDialog(
            context: event.context!,
            builder: (context) => AlertDialog(
                  title: const Center(child: Text("Error")),
                  content: SizedBox(
                      height: 100,
                      width: 100,
                      child: Text(ratingData.message!)),
                ));
      } else if (ratingData is SocketMessage ||
          ratingData is TimeoutException) {
        showDialog(
            context: event.context!,
            builder: (context) => const AlertDialog(
                  title: Center(child: Text("Error")),
                  content: SizedBox(
                      height: 100,
                      width: 100,
                      child: Text("Can't connect to server")),
                ));
      }
    } else if (event is BackToBookingScreen) {
      if (_homestayType == "homestay") {
        Navigator.pushReplacementNamed(
            event.context!, BookingLoadingScreen.bookingLoadingScreen,
            arguments: {
              "bookingId": _booking!.id,
              "homestayType": _homestayType,
              "viewDetail": _viewDetail
            });
      } else {
        Navigator.pushReplacementNamed(
            event.context!, BookingLoadingScreen.bookingLoadingScreen,
            arguments: {
              "bookingId": _booking!.id,
              "homestayType": _homestayType,
              "blocBookingValidation": _blocBookingValidation,
              "viewDetail": _viewDetail
            });
      }
    }

    stateController.sink.add(RatingHomestayState(
        bookingHomestay: _bookingHomestay,
        securityPoint: _securityPoint,
        servicePoint: _servicePoint,
        locationPoint: _locationPoint,
        comment: _comment,
        isRatingFinished: _isRatingFinished,
        booking: _booking,
        homestayType: _homestayType,
        viewDetail: _viewDetail,
        blocBookingValidation: _blocBookingValidation));
  }
}
