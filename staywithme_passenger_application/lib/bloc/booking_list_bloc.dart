import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:staywithme_passenger_application/bloc/event/booking_list_event.dart';

import 'package:staywithme_passenger_application/bloc/state/booking_list_state.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/model/search_filter_model.dart';
import 'package:staywithme_passenger_application/screen/booking/booking_history_screen.dart';
import 'package:staywithme_passenger_application/screen/booking/booking_list_screen.dart';
import 'package:staywithme_passenger_application/screen/booking/promotion_screen.dart';
import 'package:staywithme_passenger_application/screen/homestay/filter_screen.dart';
import 'package:staywithme_passenger_application/screen/homestay/homestay_detail_screen.dart';
import 'package:staywithme_passenger_application/screen/homestay/search_homestay_screen.dart';
import 'package:staywithme_passenger_application/screen/rating/rating_screen.dart';

import 'package:staywithme_passenger_application/service/user/booking_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class BookingListBloc {
  final eventController = StreamController<BookingListEvent>();
  final stateController = StreamController<BookingListState>();

  final bookingService = locator.get<IBookingService>();
  final _bookingHomestayChosenList = <BookingHomestayModel>[];
  BookingModel? _booking;
  String? _homestayType;
  bool? _isBookingHomestay;
  bool? _activeUpdateService = false;
  int? _bookingHomestayIndex = 0;
  bool? _viewDetail = false;
  BlocBookingDateValidationModel? _blocBookingValidation;
  PaymentMethod? _paymentMethod;
  final List<HomestayServiceModel> _serviceList = <HomestayServiceModel>[];
  bool _isCopied = false;
  bool _isHost = true;

  BookingListState initData(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    _booking = contextArguments["booking"];
    _homestayType = contextArguments["homestayType"];
    _blocBookingValidation = contextArguments["blocBookingValidation"];
    _paymentMethod = PaymentMethod.swm_wallet;
    _viewDetail = contextArguments["viewDetail"] ?? false;
    _isBookingHomestay = contextArguments["isBookingHomestay"] ?? true;
    _isHost = contextArguments["isHost"] ?? true;
    return BookingListState(
        booking: contextArguments["booking"],
        homestayType: contextArguments["homestayType"],
        bookingHomestayChosenList: <BookingHomestayModel>[],
        isBookingHomestay: contextArguments["isBookingHomestay"] ?? true,
        bookingHomestayIndex: contextArguments["bookingHomestayIndex"] ?? 0,
        serviceList: _serviceList,
        blocBookingValidation: contextArguments["blocBookingValidation"],
        activeUpdateService: false,
        paymentMethod: PaymentMethod.swm_wallet,
        viewDetail: contextArguments["viewDetail"] ?? false,
        isCopied: false,
        isHost: contextArguments["isHost"] ?? true);
  }

  void dispose() {
    eventController.close();
    stateController.close();
  }

  BookingListBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  Future<void> eventHandler(BookingListEvent event) async {
    if (event is UpdateBookingDateEvent) {
      BookingModel booking = event.booking!;
      booking.bookingFrom = event.bookingStart;
      booking.bookingTo = event.bookingEnd;
      await bookingService.updateBooking(booking, event.bookingId!);
      Navigator.pushNamed(
          event.context!, BookingLoadingScreen.bookingLoadingScreen,
          arguments: {
            "bookingId": event.bookingId,
            "homestayType": _homestayType,
            "blocBookingValidation": _blocBookingValidation
          });
    } else if (event is ChooseBookingHomestayEvent) {
      BookingHomestayModel? removeBookingHomestay;
      for (BookingHomestayModel b in _bookingHomestayChosenList) {
        if (b.bookingHomestayId!.bookingId ==
            event.bookingHomestay!.bookingHomestayId!.bookingId) {
          if (b.bookingHomestayId!.homestayId ==
              event.bookingHomestay!.bookingHomestayId!.homestayId) {
            removeBookingHomestay = b;
          }
        }
      }
      if (removeBookingHomestay != null) {
        _bookingHomestayChosenList.remove(removeBookingHomestay);
      } else {
        _bookingHomestayChosenList.add(event.bookingHomestay!);
      }
    } else if (event is ChooseViewHomestayListEvent) {
      _isBookingHomestay = true;
    } else if (event is ChooseViewServiceListEvent) {
      for (BookingServiceModel s in _booking!.bookingHomestayServices!) {
        _serviceList.add(s.homestayService!);
      }
      _isBookingHomestay = false;
    } else if (event is ChooseNewHomestayServiceEvent) {
      HomestayServiceModel? removeService;
      for (HomestayServiceModel s in _serviceList) {
        if (s.id == event.homestayService!.id) {
          removeService = s;
        }
      }
      if (removeService != null) {
        _serviceList.remove(removeService);
      } else {
        _serviceList.add(event.homestayService!);
      }
      _activeUpdateService = true;
    } else if (event is UpdateHomestayServiceEvent) {
      String homestayName = _homestayType == "homestay"
          ? event.homestayName!
          : _booking!.bloc!.name!;

      final bookingData = await bookingService.updateBookingServices(
          event.serviceIdList!, event.bookingId!, homestayName);

      if (bookingData is BookingModel) {
        Navigator.pushReplacementNamed(
            event.context!, BookingLoadingScreen.bookingLoadingScreen,
            arguments: {
              "bookingId": _booking!.id!,
              "homestayType": _homestayType,
              "blocBookingValidation": _blocBookingValidation
            });
      } else if (bookingData is ServerExceptionModel) {
        showDialog(
          context: event.context!,
          builder: (context) => AlertDialog(
              title: const Center(child: Text("Error")),
              content: SizedBox(
                height: 100,
                width: 50,
                child: Center(child: Text(bookingData.message!)),
              )),
        );
      } else if (bookingData is TimeoutException ||
          bookingData is SocketException) {
        showDialog(
          context: event.context!,
          builder: (context) => const AlertDialog(
              title: Center(child: Text("Error")),
              content: SizedBox(
                height: 100,
                width: 50,
                child: Center(child: Text("Can't connect to server")),
              )),
        );
      }
    } else if (event is CancelUpdateServiceEvent) {
      _activeUpdateService = false;
      _serviceList.clear();
      Navigator.pushNamed(
          event.context!, BookingLoadingScreen.bookingLoadingScreen,
          arguments: {
            "bookingId": _booking!.id,
            "homestayType": _homestayType,
            "isBookingHomestay": _isBookingHomestay,
            "bookingHomestayIndex": _bookingHomestayIndex,
            "blocBookingValidation": _blocBookingValidation
          });
    } else if (event is BrowseMoreHomestayEvent) {
      FilterOptionModel filterOption;
      if (event.similarWithAnotherHomestay!) {
        filterOption = FilterOptionModel(
            filterByBookingDateRange: FilterByBookingDate(
                start: _booking!.bookingFrom,
                end: _booking!.bookingTo,
                totalReservation: event.homestay!.availableRooms),
            filterByAddress: FilterByAddress(
                address: utf8.decode(event.homestay!.address!.runes.toList()),
                distance: 5000,
                isGeometry: true),
            filterByRatingRange: FilterByRatingRange(
                highest: event.homestay!.totalAverageRating,
                lowest: event.homestay!.totalAverageRating));
      } else {
        filterOption = FilterOptionModel(
          filterByBookingDateRange: FilterByBookingDate(
              start: _booking!.bookingFrom,
              end: _booking!.bookingTo,
              totalReservation: 5),
        );
      }
      Navigator.pushReplacementNamed(event.context!,
          SelectNextHomestayScreen.selectNextHomestayScreenRoute,
          arguments: {
            "filterOption": filterOption,
            "bookingId": _booking!.id,
            "bookingStart": _booking!.bookingFrom,
            "bookingEnd": _booking!.bookingTo,
            "homestayType": _homestayType,
            "blocBookingValidation": _blocBookingValidation,
            "brownseHomestayFlag": true
          });
    } else if (event is ForwardHomestayEvent) {
      if (_bookingHomestayIndex! < _booking!.bookingHomestays!.length - 1) {
        _bookingHomestayIndex = _bookingHomestayIndex! + 1;
      }
    } else if (event is BackwardHomestayEvent) {
      if (_bookingHomestayIndex! > 0) {
        _bookingHomestayIndex = _bookingHomestayIndex! - 1;
      }
    } else if (event is DeleteBookingHomestayEvent) {
      final deleteBookingHomestayData = await bookingService
          .deleteBookingHomestay(_booking!.id!, event.homestayId!);
      if (deleteBookingHomestayData is String) {
        Navigator.pushReplacementNamed(
            event.context!, BookingLoadingScreen.bookingLoadingScreen,
            arguments: {
              "bookingId": _booking!.id,
              "homestayType": _homestayType,
              "blocBookingValidation": _blocBookingValidation
            });
      } else if (deleteBookingHomestayData is ServerExceptionModel) {
        showDialog(
          context: event.context!,
          builder: (context) => AlertDialog(
            title: const Center(
              child: Text("Error"),
            ),
            content: SizedBox(
              height: 100,
              child: Text(deleteBookingHomestayData.message!),
            ),
          ),
        );
      } else if (deleteBookingHomestayData is SocketException ||
          deleteBookingHomestayData is TimeoutException) {
        showDialog(
          context: event.context!,
          builder: (context) => const AlertDialog(
            title: Center(
              child: Text("Error"),
            ),
            content: SizedBox(
              height: 100,
              child: Text("Can't connect to server"),
            ),
          ),
        );
      }
    } else if (event is ViewHomestayDetailScreenEvent) {
      Navigator.pushNamed(
          event.context!, HomestayDetailScreen.homestayDetailScreenRoute,
          arguments: {
            "homestayName": event.homestayName,
            "isHomestayInBloc": _booking!.homestayType == "BLOC",
            "bookingViewHomestayDetailFlag": true,
            "viewDetail": _viewDetail,
          });
    } else if (event is SubmitBookingEvent) {
      String paymentMethod = "";
      switch (_paymentMethod) {
        case PaymentMethod.cash:
          paymentMethod = "CASH";
          break;
        case PaymentMethod.swm_wallet:
          paymentMethod = "SWM_WALLET";
          break;
        case null:
          break;
      }

      Navigator.pushReplacementNamed(
          event.context!, PromotionScreen.promotionScreenRoute,
          arguments: {
            "booking": _booking,
            "homestayType": _homestayType,
            "paymentMethod": paymentMethod
          });
    } else if (event is ChooseHomestayListInBlocEvent) {
      Navigator.pushNamed(event.context!,
          ShowBlocHomestayListScreen.showBlocHomestayListScreenRoute,
          arguments: {
            "bloc": event.bloc,
            "blocBookingValidation": event.blocBookingValidation,
            "booking": event.booking,
            "paymentMethod": _paymentMethod.toString()
          });
    } else if (event is ChoosePaymentMethodEvent) {
      _paymentMethod = event.paymentMethod!;
    } else if (event is UpdatePaymentMethodEvent) {
      String paymentMethod = "";
      switch (event.paymentMethod) {
        case PaymentMethod.swm_wallet:
          paymentMethod = "SWM_WALLET";
          break;
        case PaymentMethod.cash:
          paymentMethod = "CASH";
          break;
        default:
          break;
      }
      final updatePaymentData = await bookingService.updatePaymentMethod(
          _booking!.id!, event.homestayId!, paymentMethod);
      if (updatePaymentData is BookingHomestayModel) {
        Navigator.pushReplacementNamed(
            event.context!, BookingLoadingScreen.bookingLoadingScreen,
            arguments: {
              "bookingId": _booking!.id,
              "homestayType": _homestayType
            });
      } else if (updatePaymentData is ServerExceptionModel) {
        showDialog(
          context: event.context!,
          builder: (context) => AlertDialog(
            title: const Center(
              child: Text("Error"),
            ),
            content: SizedBox(
              height: 100,
              child: Text(updatePaymentData.message!),
            ),
          ),
        );
      } else if (updatePaymentData is SocketException ||
          updatePaymentData is TimeoutException) {
        showDialog(
          context: event.context!,
          builder: (context) => const AlertDialog(
            title: Center(
              child: Text("Error"),
            ),
            content: SizedBox(
              height: 100,
              child: Text("Can't connect to server"),
            ),
          ),
        );
      }
    } else if (event is CopyInviteCodeEvent) {
      await Clipboard.setData(ClipboardData(text: event.inviteCode));
      _isCopied = true;
    } else if (event is BackwardBookingHistoryEvent) {
      Navigator.pushReplacementNamed(
          event.context!, BookingHistoryScreen.bookingHistoryScreenRoute);
    } else if (event is FowardRatingForHomestayScreenEvent) {
      Navigator.pushNamed(
          event.context!, RatingHomestayScreen.ratingHomestayScreenRoute,
          arguments: {
            "bookingHomestay": event.bookingHomestay,
            "homestayType": HomestayType.homestay.name,
            "viewDetail": _viewDetail
          });
    } else if (event is FowardRatingForBlockScreenEvent) {
      Navigator.pushNamed(
          event.context!, RatingHomestayScreen.ratingHomestayScreenRoute,
          arguments: {
            "booking": _booking,
            "homestayType": HomestayType.bloc.name,
            "viewDetail": _viewDetail,
            "blocBookingValidation": _blocBookingValidation
          });
    }

    stateController.sink.add(BookingListState(
        bookingHomestayChosenList: _bookingHomestayChosenList,
        booking: _booking,
        homestayType: _homestayType,
        isBookingHomestay: _isBookingHomestay,
        bookingHomestayIndex: _bookingHomestayIndex,
        serviceList: _serviceList,
        blocBookingValidation: _blocBookingValidation,
        activeUpdateService: _activeUpdateService,
        paymentMethod: _paymentMethod,
        viewDetail: _viewDetail,
        isCopied: _isCopied,
        isHost: _isHost));
  }
}
