import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:staywithme_passenger_application/bloc/event/payment_history_event.dart';
import 'package:staywithme_passenger_application/bloc/payment_history_bloc.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/payment_model.dart';
import 'package:staywithme_passenger_application/service/user/payment_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});
  static const String paymentHistoryScreenRoute = "/payment-history";

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  final _paymentService = locator.get<IPaymentService>();
  final paymentHistoryBloc = PaymentHistoryBloc();

  @override
  Widget build(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    final username = contextArguments["username"];
    final page =
        contextArguments["page"] != null ? contextArguments["page"] as int : 0;
    final isNextPage = contextArguments["isNextPage"] != null
        ? contextArguments["isNextPage"] as bool
        : false;
    final isPreviousPage = contextArguments["isPreviousPage"] != null
        ? contextArguments["isPreviousPage"] as bool
        : false;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.orange, Colors.white])),
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 350,
              width: MediaQuery.of(context).size.width - 10,
              decoration: BoxDecoration(boxShadow: const [
                BoxShadow(blurRadius: 1.0, blurStyle: BlurStyle.normal)
              ], borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Container(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: Column(children: [
                  FutureBuilder(
                    future: _paymentService.getPaymentHistories(
                        username, page, 1, isNextPage, isPreviousPage),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                              child: SpinKitCircle(color: Colors.orange));
                        case ConnectionState.done:
                          final snapshotData = snapshot.data;
                          if (snapshotData is PaymentHistoryPagingModel) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () => paymentHistoryBloc
                                            .eventController.sink
                                            .add(PreviousPageEvent(
                                                username: username,
                                                context: context,
                                                pageNumber:
                                                    snapshotData.pageNumber)),
                                        icon: const Icon(
                                          Icons.arrow_back_ios,
                                          color: secondaryColor,
                                        )),
                                    Text(
                                      "Page ${snapshotData.pageNumber! + 1}",
                                      style: const TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0),
                                    ),
                                    IconButton(
                                        onPressed: () => paymentHistoryBloc
                                            .eventController.sink
                                            .add(NextPageEvent(
                                                username: username,
                                                context: context,
                                                pageNumber:
                                                    snapshotData.pageNumber)),
                                        icon: const Icon(
                                          Icons.arrow_forward_ios,
                                          color: secondaryColor,
                                        )),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  height: 17,
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "amount",
                                          style: TextStyle(
                                              fontFamily: "Lobster",
                                              fontSize: 15,
                                              color: Colors.orange,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.0),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "currency",
                                          style: TextStyle(
                                              fontFamily: "Lobster",
                                              fontSize: 15,
                                              color: Colors.orange,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.0),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "method",
                                          style: TextStyle(
                                              fontFamily: "Lobster",
                                              fontSize: 15,
                                              color: Colors.orange,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.0),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "date",
                                          style: TextStyle(
                                              fontFamily: "Lobster",
                                              fontSize: 15,
                                              color: Colors.orange,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 100,
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  child: ListView.builder(
                                    itemCount: snapshotData
                                        .paymentHistoriesModel!.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(currencyFormat.format(
                                                snapshotData
                                                    .paymentHistoriesModel![
                                                        index]
                                                    .amount)),
                                          ),
                                          const Expanded(
                                            flex: 2,
                                            child: Text(
                                              "VND",
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                                "${snapshotData.paymentHistoriesModel![index].paymentMethod}"),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                                "${snapshotData.paymentHistoriesModel![index].createdDate}"),
                                          ),
                                        ]),
                                  ),
                                ),
                              ],
                            );
                          }
                          break;
                        default:
                          break;
                      }
                      return const SizedBox();
                    },
                  ),
                ]),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    maximumSize: const Size(100, 50),
                    minimumSize: const Size(100, 50)),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Back",
                  style: TextStyle(fontFamily: "Lobster"),
                ))
          ],
        )),
      ),
    );
  }
}
