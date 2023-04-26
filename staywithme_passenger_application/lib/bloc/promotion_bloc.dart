import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/promotion_event.dart';
import 'package:staywithme_passenger_application/bloc/state/promotion_state.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/promotion_model.dart';
import 'package:staywithme_passenger_application/screen/homestay/process_booking_screen.dart';

class PromotionBloc {
  final eventController = StreamController<PromotionEvent>();
  final stateController = StreamController<PromotionState>();

  BookingModel? _booking;
  final List<PromotionModel> _promotions = <PromotionModel>[];
  String? _homestayType;
  String? _status;
  String? _paymentMethod;
  int? _totalBookingPriceAfterDiscount;

  PromotionState initData(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    _booking = contextArguments["booking"];
    _homestayType = contextArguments["homestayType"];
    _paymentMethod = contextArguments["paymentMethod"];
    _status = "NEW";
    _totalBookingPriceAfterDiscount = 0;
    return PromotionState(
        booking: contextArguments["booking"],
        homestayType: contextArguments["homestayType"],
        status: "NEW",
        paymentMethod: contextArguments["paymentMethod"],
        promotions: <PromotionModel>[],
        totalBookingPriceAfterDiscount: 0);
  }

  void dispose() {
    eventController.close();
    stateController.close();
  }

  PromotionBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  Future<void> eventHandler(PromotionEvent event) async {
    if (event is ChoosePromotionEvent) {
      PromotionModel? removePromotion;
      for (PromotionModel p in _promotions) {
        if (p.id == event.promotion!.id) {
          removePromotion = p;
        }
      }
      if (removePromotion != null) {
        int discountAmount = _booking!.totalBookingPrice! *
            removePromotion.discountAmount! ~/
            100;
        _totalBookingPriceAfterDiscount =
            _totalBookingPriceAfterDiscount! + discountAmount;
        _promotions.remove(removePromotion);
      } else {
        _promotions.add(event.promotion!);
        int discountAmount = 0;
        for (PromotionModel p in _promotions) {
          discountAmount = discountAmount +
              _booking!.totalBookingPrice! * p.discountAmount! ~/ 100;
        }
        _totalBookingPriceAfterDiscount =
            _booking!.totalBookingPrice! - discountAmount;
      }
    } else if (event is ConfirmBookingEvent) {
      Navigator.pushReplacementNamed(
          event.context!, ProcessBookingScreen.processBookingScreenRoute,
          arguments: {
            "bookingId": _booking!.id,
            "homestayType": _homestayType,
            "paymentMethod": _paymentMethod
          });
    }
    stateController.sink.add(PromotionState(
        booking: _booking,
        homestayType: _homestayType,
        promotions: _promotions,
        status: _status,
        totalBookingPriceAfterDiscount: _totalBookingPriceAfterDiscount,
        paymentMethod: _paymentMethod));
  }
}
