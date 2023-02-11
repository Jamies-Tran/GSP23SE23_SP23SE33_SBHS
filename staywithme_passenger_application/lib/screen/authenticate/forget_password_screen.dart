import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:staywithme_passenger_application/bloc/forget_password_bloc.dart';
import 'package:staywithme_passenger_application/bloc/state/forget_password_state.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/service/authentication/auth_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

import '../../bloc/event/forget_password_event.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  static const forgetPasswordRoute = "/forget-password";

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final emailTextEditingController = TextEditingController();
  final forgetPasswordBloc = ForgetPasswordBloc();

  @override
  void dispose() {
    forgetPasswordBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    final isForgetPassword = contextArguments["isForgetPassword"];
    String? email = contextArguments["email"] as String?;
    bool isExceptionOccured = contextArguments["isExceptionOccured"] ?? false;
    String message = contextArguments["message"] ?? "";

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: StreamBuilder<ForgetPasswordState>(
            stream: forgetPasswordBloc.stateController.stream,
            initialData: forgetPasswordBloc.initData(),
            builder: (context, snapshot) {
              return Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.white, Colors.orange])),
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Center(
                      child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 250, bottom: 200),
                        padding: const EdgeInsets.all(20),
                        width: 300,
                        height: 320,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurStyle: BlurStyle.normal,
                                  blurRadius: 5.0,
                                  offset: Offset(5.0, 5.0))
                            ]),
                        child: Column(children: [
                          Text(
                            isForgetPassword == true
                                ? "Enter your email"
                                : "Enter otp",
                            style: const TextStyle(
                                fontFamily: "Lobster",
                                color: Colors.deepOrangeAccent,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: emailTextEditingController,
                                    decoration: InputDecoration(
                                        hintText: isForgetPassword == true
                                            ? "Email"
                                            : "Otp",
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(2.0),
                                            borderSide: const BorderSide(
                                                color: Colors.grey,
                                                width: 1.0)),
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black45,
                                                    width: 1.0)),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(2.0),
                                            borderSide: const BorderSide(
                                                color: Colors.red,
                                                width: 1.0))),
                                    onChanged: (value) {
                                      if (isForgetPassword) {
                                        forgetPasswordBloc.eventController.sink
                                            .add(InputEmailEvent(email: value));
                                      } else {
                                        forgetPasswordBloc.eventController.sink
                                            .add(InputOtpEvent(otp: value));
                                      }
                                    },
                                    validator: (value) {
                                      if (isForgetPassword) {
                                        return snapshot.data!.validateEmail();
                                      } else {
                                        return snapshot.data!.validateOtp();
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  isExceptionOccured == true
                                      ? Text(
                                          message,
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : const SizedBox(),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.deepOrangeAccent,
                                          minimumSize: const Size(150, 50),
                                          maximumSize: const Size(150, 50)),
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          if (isForgetPassword) {
                                            forgetPasswordBloc
                                                .eventController.sink
                                                .add(ForwardToSendMailScreenEvent(
                                                    context: context,
                                                    email:
                                                        emailTextEditingController
                                                            .text));
                                          } else {
                                            forgetPasswordBloc
                                                .eventController.sink
                                                .add(ForwardToValidateOtpScreenEvent(
                                                    context: context,
                                                    otp:
                                                        emailTextEditingController
                                                            .text,
                                                    email: email));
                                          }
                                        }
                                      },
                                      child: Text(
                                        isForgetPassword == true
                                            ? "Send otp"
                                            : "Validate",
                                        style: const TextStyle(
                                            fontFamily: "Lobster",
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  TextButton(
                                      onPressed: () => forgetPasswordBloc
                                          .eventController.sink
                                          .add(BackwardToLoginScreenEvent(
                                              context: context)),
                                      child: const Text(
                                        "Cancel",
                                        style:
                                            TextStyle(color: Colors.redAccent),
                                      ))
                                ],
                              )),
                        ]),
                      ),
                    ],
                  )),
                ),
              );
            }),
      ),
    );
  }
}

class SendMailScreen extends StatelessWidget {
  const SendMailScreen({super.key});

  static const String sendMailScreenRoute = "/send-mail";

  @override
  Widget build(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    String email = contextArguments["email"];
    final forgetPasswordBloc = ForgetPasswordBloc();
    final authService = locator.get<IAuthenticateService>();

    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 250, bottom: 200),
          padding: const EdgeInsets.only(top: 110, bottom: 30),
          width: 300,
          height: 350,
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.grey,
                blurStyle: BlurStyle.normal,
                blurRadius: 5.0,
                offset: Offset(5.0, 5.0))
          ]),
          child: FutureBuilder(
            future: authService.sendOtpByEmail(email),
            // future: Future.delayed(Duration(seconds: 1)),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Column(
                    children: const [
                      SpinKitCircle(
                        color: Colors.blue,
                        size: 50,
                      ),
                      Text(
                        "Sending...",
                        style: TextStyle(color: Colors.blue, fontSize: 40),
                      )
                    ],
                  );
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    final data = snapshot.data;
                    if (data is bool) {
                      return FutureBuilder(
                        // future: Future.delayed(const Duration(seconds: 3)),
                        future: Future.delayed(const Duration(seconds: 5)),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Center(
                                child: Column(
                                  children: const [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.green,
                                      size: 50,
                                    ),
                                    Text(
                                      "Success",
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 50),
                                    )
                                  ],
                                ),
                              );
                            case ConnectionState.done:
                              forgetPasswordBloc.eventController.sink.add(
                                  ForwardToSendOtpScreenEvent(
                                      context: context, email: email));
                              break;
                            default:
                              return const SizedBox();
                          }
                          return const SizedBox();
                        },
                      );
                    } else if (data is ServerExceptionModel) {
                      forgetPasswordBloc.eventController.sink.add(
                          BackwardToSendOtpByMailScreenEvent(
                              context: context,
                              email: email,
                              message: data.message));
                    } else if (data is TimeoutException ||
                        data is SocketException) {
                      forgetPasswordBloc.eventController.sink.add(
                          BackwardToSendOtpByMailScreenEvent(
                              context: context,
                              email: email,
                              message: "Network error"));
                    }
                  } else {
                    forgetPasswordBloc.eventController.sink.add(
                        BackwardToSendOtpByMailScreenEvent(
                            context: context,
                            email: email,
                            message: snapshot.error.toString()));
                  }
                  return const SizedBox();
                default:
                  return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}

class ValidatePasswordModificationOtpScreen extends StatelessWidget {
  const ValidatePasswordModificationOtpScreen({super.key});

  static const String validatePasswordModificationScreenRoute = "/verify-otp";

  @override
  Widget build(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    String email = contextArguments["email"];
    String otp = contextArguments["otp"];
    final forgetPasswordBloc = ForgetPasswordBloc();
    final authService = locator.get<IAuthenticateService>();

    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 250, bottom: 200),
          padding: const EdgeInsets.only(top: 110, bottom: 30),
          width: 300,
          height: 350,
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.grey,
                blurStyle: BlurStyle.normal,
                blurRadius: 5.0,
                offset: Offset(5.0, 5.0))
          ]),
          child: FutureBuilder(
            future: authService.validatePasswordModificationOtp(otp),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Column(
                    children: const [
                      SpinKitCircle(
                        color: Colors.blue,
                        size: 50,
                      ),
                      Text(
                        "Checking...",
                        style: TextStyle(color: Colors.blue, fontSize: 40),
                      )
                    ],
                  );
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    final data = snapshot.data;
                    if (data is bool) {
                      return FutureBuilder(
                        // future: Future.delayed(const Duration(seconds: 3)),
                        future: Future.delayed(const Duration(seconds: 5)),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Center(
                                child: Column(
                                  children: const [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.green,
                                      size: 50,
                                    ),
                                    Text(
                                      "Success",
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 50),
                                    )
                                  ],
                                ),
                              );
                            case ConnectionState.done:
                              forgetPasswordBloc.eventController.sink.add(
                                  ForwardToChangePasswordScreenEvent(
                                      context: context, email: email));
                              break;
                            default:
                              return const SizedBox();
                          }
                          return const SizedBox();
                        },
                      );
                    } else if (data is ServerExceptionModel) {
                      forgetPasswordBloc.eventController.sink.add(
                          BackwardToValidateOtpScreenEvent(
                              context: context,
                              email: email,
                              message: data.message));
                    } else if (data is TimeoutException ||
                        data is SocketException) {
                      forgetPasswordBloc.eventController.sink.add(
                          BackwardToValidateOtpScreenEvent(
                              context: context,
                              email: email,
                              message: "Network error"));
                    }
                  }
                  return const SizedBox();
                default:
                  return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}
