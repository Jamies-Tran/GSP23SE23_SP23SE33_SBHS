import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

abstract class RatingHomestayEvent {}

class RatingSecurityForHomestayEvent extends RatingHomestayEvent {
  RatingSecurityForHomestayEvent({this.securityPoint});

  double? securityPoint;
}

class RatingServiceForHomestayEvent extends RatingHomestayEvent {
  RatingServiceForHomestayEvent({this.servicePoint});

  double? servicePoint;
}

class RatingLocationForHomestayEvent extends RatingHomestayEvent {
  RatingLocationForHomestayEvent({this.locationPoint});

  double? locationPoint;
}

class CommentForHomestayEvent extends RatingHomestayEvent {
  CommentForHomestayEvent({this.comment});

  String? comment;
}

class SubmitRatingHomestayEvent extends RatingHomestayEvent {
  SubmitRatingHomestayEvent({this.rating, this.context});

  BuildContext? context;
  RatingModel? rating;
}

class BackToBookingScreen extends RatingHomestayEvent {
  BackToBookingScreen({this.context});

  BuildContext? context;
}
