import 'dart:async';

import 'package:staywithme_passenger_application/bloc/event/add_balance_event.dart';
import 'package:staywithme_passenger_application/bloc/state/add_balance_state.dart';
import 'package:staywithme_passenger_application/service/user/payment_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';
import 'package:url_launcher/url_launcher.dart';

class AddBalanceBloc {
  final eventController = StreamController<AddBalanceEvent>();
  final stateController = StreamController<AddBalanceState>();
  final _paymentService = locator.get<IPaymentService>();

  int? _balance;

  AddBalanceState initData() => AddBalanceState(balance: null);

  void dispose() {
    eventController.close();
    stateController.close();
  }

  AddBalanceBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(AddBalanceEvent event) {
    if (event is InputBalanceEvent) {
      _balance = event.balance;
    } else if (event is NavigatingToMomoEvent) {
      Uri uri = Uri.parse(event.payUrl!);
      launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    stateController.sink.add(AddBalanceState(balance: _balance));
  }
}
