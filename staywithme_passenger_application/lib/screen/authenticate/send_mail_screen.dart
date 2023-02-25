import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:staywithme_passenger_application/bloc/event/send_mail_event.dart';
import 'package:staywithme_passenger_application/bloc/send_mail_bloc.dart';
import 'package:staywithme_passenger_application/bloc/state/send_mail_state.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/service/authentication/auth_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class SendMailScreen extends StatefulWidget {
  const SendMailScreen({super.key});
  static const String sendMailsCreenRoute = "/send-mail";

  @override
  State<SendMailScreen> createState() => _SendMailScreenState();
}

class _SendMailScreenState extends State<SendMailScreen> {
  final sendMailBloc = SendMailBloc();
  final formKey = GlobalKey<FormState>();
  final authService = locator.get<IAuthenticateService>();
  final emailTextEditingController = TextEditingController();

  @override
  void dispose() {
    sendMailBloc.dispose();
    emailTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map?;
    final isExcOccured =
        contextArguments != null ? contextArguments["isExcOccured"] : false;
    final msg = contextArguments != null ? contextArguments["msg"] : null;

    return StreamBuilder<SendMailState>(
        stream: sendMailBloc.stateController.stream,
        initialData: sendMailBloc.initData(),
        builder: (context, snapshot) {
          return Scaffold(
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.orange, Colors.white])),
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(seconds: 3),
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: child,
                ),
                child: Center(
                  child: Container(
                    height: 500,
                    width: 300,
                    padding: const EdgeInsets.all(20),
                    color: Colors.white,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Enter your email",
                            style: TextStyle(
                                fontFamily: "Lobster",
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: emailTextEditingController,
                                    decoration: const InputDecoration(
                                        hintText: "Enter here",
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: primaryColor,
                                                width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: primaryColor),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        errorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        hintStyle:
                                            TextStyle(color: Colors.black45)),
                                    onChanged: (value) => sendMailBloc
                                        .eventController.sink
                                        .add(InputMailEvent(mail: value)),
                                    validator: (value) =>
                                        snapshot.data!.validateMail(),
                                  ),
                                  SizedBox(
                                    height: isExcOccured ? 20 : 10,
                                  ),
                                  isExcOccured
                                      ? Text(
                                          msg,
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : const SizedBox(),
                                  TweenAnimationBuilder(
                                    tween: Tween<double>(begin: 0, end: 1),
                                    duration: const Duration(seconds: 4),
                                    builder: (context, value, child) =>
                                        Opacity(opacity: value, child: child),
                                    child: TweenAnimationBuilder(
                                      tween: Tween<double>(begin: 50, end: 0),
                                      duration: const Duration(seconds: 4),
                                      builder: (context, value, child) =>
                                          Container(
                                        margin: EdgeInsets.only(top: value),
                                        child: child,
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryColor,
                                            maximumSize: const Size(250, 50),
                                            minimumSize: const Size(250, 50)),
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            showDialog(
                                              context: context,
                                              builder: (context) => Dialog(
                                                  backgroundColor:
                                                      Colors.orangeAccent,
                                                  child: Container(
                                                    height: 70,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 25,
                                                            bottom: 25),
                                                    child: FutureBuilder(
                                                      future: authService
                                                          .sendOtpByEmail(
                                                              snapshot
                                                                  .data!.mail!),
                                                      builder:
                                                          (context, snapshot) {
                                                        switch (snapshot
                                                            .connectionState) {
                                                          case ConnectionState
                                                              .waiting:
                                                            return Column(
                                                              children: const [
                                                                SpinKitCircle(
                                                                  color: Colors
                                                                      .deepOrangeAccent,
                                                                ),
                                                                Text(
                                                                  "Sending...",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "Lobster",
                                                                      color: Colors
                                                                          .black),
                                                                )
                                                              ],
                                                            );
                                                          case ConnectionState
                                                              .done:
                                                            if (snapshot
                                                                .hasData) {
                                                              final data =
                                                                  snapshot.data;
                                                              if (data
                                                                  is bool) {
                                                                sendMailBloc
                                                                    .eventController
                                                                    .sink
                                                                    .add(SendMailSuccessEvent(
                                                                        context:
                                                                            context,
                                                                        email: emailTextEditingController
                                                                            .text));
                                                              } else if (data
                                                                  is ServerExceptionModel) {
                                                                sendMailBloc
                                                                    .eventController
                                                                    .sink
                                                                    .add(BackwardToSendMailScreen(
                                                                        context:
                                                                            context,
                                                                        isExcOccured:
                                                                            true,
                                                                        msg: data
                                                                            .message,
                                                                        email: emailTextEditingController
                                                                            .text));
                                                              }
                                                            }
                                                            break;
                                                          default:
                                                            break;
                                                        }
                                                        return const SizedBox();
                                                      },
                                                    ),
                                                  )),
                                            );
                                          }
                                        },
                                        child: const Text(
                                          "Send",
                                          style: TextStyle(
                                              fontFamily: "Lobster",
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                      onPressed: () {},
                                      child: const Text("Cancel"))
                                ],
                              )),
                        ]),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
