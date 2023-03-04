import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:staywithme_passenger_application/model/search_filter_model.dart';

abstract class FilterTransactionEvent {}

class FinishGetFilterAdditionalHomestayEvent extends FilterTransactionEvent {
  FinishGetFilterAdditionalHomestayEvent(
      {this.position, this.filterAddtionalInformation, this.context});

  Position? position;
  FilterAddtionalInformationModel? filterAddtionalInformation;
  BuildContext? context;
}
