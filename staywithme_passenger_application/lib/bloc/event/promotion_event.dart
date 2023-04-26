import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/model/promotion_model.dart';

abstract class PromotionEvent {}

class ChoosePromotionEvent extends PromotionEvent {
  ChoosePromotionEvent({this.promotion});

  PromotionModel? promotion;
}

class ConfirmBookingEvent extends PromotionEvent {
  ConfirmBookingEvent({this.context});

  BuildContext? context;
}
