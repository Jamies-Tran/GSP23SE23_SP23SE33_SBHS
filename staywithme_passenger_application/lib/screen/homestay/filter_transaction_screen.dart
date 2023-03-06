import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:staywithme_passenger_application/bloc/event/filter_transaction_event.dart';
import 'package:staywithme_passenger_application/bloc/filter_transaction_bloc.dart';
import 'package:staywithme_passenger_application/model/search_filter_model.dart';
import 'package:staywithme_passenger_application/service/homestay/homestay_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class FilterTransactionScreen extends StatefulWidget {
  const FilterTransactionScreen({super.key});
  static const String filterTransactionScreenRoute = "/filter-transaction";

  @override
  State<FilterTransactionScreen> createState() =>
      _FilterTransactionScreenState();
}

class _FilterTransactionScreenState extends State<FilterTransactionScreen> {
  final homestayService = locator.get<IHomestayService>();
  final filterTransactionBloc = FilterTransactionBloc();

  @override
  void dispose() {
    filterTransactionBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map?;
    Position? position =
        contextArguments != null ? contextArguments["position"] : null;
    String homestayType = contextArguments?["homestayType"];

    return Scaffold(
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder(
          future: homestayService
              .getHomestayFilterAdditionalInformation(homestayType),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const SizedBox();
              case ConnectionState.done:
                final data = snapshot.data as FilterAddtionalInformationModel?;
                filterTransactionBloc.eventController.sink.add(
                    FinishGetFilterAdditionalHomestayEvent(
                        context: context,
                        filterAddtionalInformation: data,
                        position: position,
                        homestayType: homestayType));
                break;
              default:
                break;
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
