import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:staywithme_passenger_application/bloc/add_balance_bloc.dart';
import 'package:staywithme_passenger_application/bloc/event/add_balance_event.dart';
import 'package:staywithme_passenger_application/bloc/state/add_balance_state.dart';
import 'package:staywithme_passenger_application/model/payment_model.dart';
import 'package:staywithme_passenger_application/service/user/payment_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class AddBalanceScreen extends StatefulWidget {
  const AddBalanceScreen({super.key});
  static const String addBalanceScreenRoute = "/add-balance";

  @override
  State<AddBalanceScreen> createState() => _AddBalanceScreenState();
}

class _AddBalanceScreenState extends State<AddBalanceScreen> {
  final addBalanceBloc = AddBalanceBloc();
  final formKey = GlobalKey<FormState>();
  final _paymentService = locator.get<IPaymentService>();

  @override
  void dispose() {
    addBalanceBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    final username = contextArguments["username"];
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.orange, Colors.white])),
        child: Center(
          child: Container(
            height: 350,
            width: MediaQuery.of(context).size.width / 1.2,
            decoration: BoxDecoration(boxShadow: const [
              BoxShadow(blurRadius: 1.0, blurStyle: BlurStyle.normal)
            ], borderRadius: BorderRadius.circular(20), color: Colors.white),
            child: StreamBuilder<AddBalanceState>(
              stream: addBalanceBloc.stateController.stream,
              initialData: addBalanceBloc.initData(),
              builder: (context, snapshot) => Form(
                key: formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Add balance",
                        style: TextStyle(
                            fontFamily: "Lobster",
                            fontSize: 30,
                            color: Colors.black45),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        width: 250,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              label: Text(
                                "Amount",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.attach_money,
                                color: Colors.greenAccent,
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black45, width: 2.5)),
                              errorStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent)),
                          onChanged: (value) =>
                              addBalanceBloc.eventController.sink.add(
                                  InputBalanceEvent(balance: int.parse(value))),
                          validator: (value) =>
                              snapshot.data!.validateBalance(),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              maximumSize: const Size(125, 50),
                              minimumSize: const Size(125, 50),
                              backgroundColor: Colors.orange),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                      content: Container(
                                          height: 100,
                                          width: 100,
                                          child: Center(
                                            child: FutureBuilder(
                                                future: _paymentService
                                                    .requestPayment(
                                                        username!,
                                                        snapshot
                                                            .data!.balance!),
                                                builder:
                                                    (context, futureSnapshot) {
                                                  final data =
                                                      futureSnapshot.data;
                                                  switch (futureSnapshot
                                                      .connectionState) {
                                                    case ConnectionState
                                                        .waiting:
                                                      return Column(
                                                        children: const [
                                                          SpinKitChasingDots(
                                                            color:
                                                                Colors.orange,
                                                          ),
                                                          Text(
                                                              "Navigating to momo...")
                                                        ],
                                                      );
                                                    case ConnectionState.done:
                                                      if (data
                                                          is PaymentModel) {
                                                        addBalanceBloc
                                                            .eventController
                                                            .sink
                                                            .add(NavigatingToMomoEvent(
                                                                payUrl: data
                                                                    .payUrl));
                                                      }

                                                      break;
                                                    default:
                                                      break;
                                                  }
                                                  return const SizedBox();
                                                }),
                                          ))));
                            }
                          },
                          child: const Text("Submit")),
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Cancle",
                            style: TextStyle(color: Colors.red),
                          ))
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
