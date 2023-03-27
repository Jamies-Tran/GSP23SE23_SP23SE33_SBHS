import 'dart:async';

import 'package:staywithme_passenger_application/bloc/event/overview_bloc_booking_event.dart';
import 'package:staywithme_passenger_application/bloc/state/overview_bloc_booking_state.dart';
import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/screen/homestay/booking_bloc_screen.dart';

class OverviewBookingBlocHomestayBloc {
  final eventController = StreamController<OverviewBookingBlocEvent>();
  final stateController = StreamController<OverviewBookingBlocState>();

  String? _bookingStart;
  String? _bookingEnd;
  BlocHomestayModel? _bloc;
  List<BookingBlocModel>? _bookingBlocList;
  List<HomestayServiceModel>? _blocServiceList;
  int? _bookingId;
  int? _totalHomestayPrice;
  int? _totalServicePrice;
  BlocPaymentMethod? _paymentMethod;

  OverviewBookingBlocState initData(
      String bookingStart,
      String bookingEnd,
      BlocHomestayModel bloc,
      List<BookingBlocModel> bookingBlocList,
      List<HomestayServiceModel> blocServiceList,
      int bookingId,
      int totalHomestayPrice,
      int totalServicePrice) {
    _bookingStart = bookingStart;
    _bookingEnd = bookingEnd;
    _bloc = bloc;
    _bookingBlocList = bookingBlocList;
    _blocServiceList = blocServiceList;
    _bookingId = bookingId;
    _totalHomestayPrice = totalHomestayPrice;
    _totalServicePrice = totalServicePrice;
    return OverviewBookingBlocState(
        bloc: bloc,
        blocServiceList: blocServiceList,
        bookingBlocList: bookingBlocList,
        bookingEnd: bookingEnd,
        bookingId: bookingId,
        bookingStart: bookingStart,
        paymentMethod: BlocPaymentMethod.cash,
        totalHomestayPrice: totalHomestayPrice,
        totalServicePrice: totalServicePrice);
  }

  void dispose() {
    eventController.close();
    stateController.close();
  }

  OverviewBookingBlocHomestayBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(OverviewBookingBlocEvent event) {
    if (event is ChooseBlocPaymentMethodEvent) {
      _paymentMethod = event.paymentMethod;
    } else if (event is SubmitBookingBlocHomestayEvent) {}
    stateController.sink.add(OverviewBookingBlocState(
        bloc: _bloc,
        blocServiceList: _blocServiceList,
        bookingBlocList: _bookingBlocList,
        bookingStart: _bookingStart,
        bookingEnd: _bookingEnd,
        bookingId: _bookingId,
        paymentMethod: _paymentMethod,
        totalHomestayPrice: _totalHomestayPrice,
        totalServicePrice: _totalServicePrice));
  }
}
