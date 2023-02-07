import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:staywithme_passenger_application/bloc/event/log_in_event.dart';
import 'package:staywithme_passenger_application/bloc/log_in_bloc.dart';
import 'package:staywithme_passenger_application/screen/authenticate/log_in_screen.dart';
import 'package:staywithme_passenger_application/screen/authenticate/register_screen.dart';

import '../../bloc/complete_google_reg_bloc.dart';
import '../../bloc/event/reg_google_event.dart';

import '../../service/google_auth_service.dart';
import '../../service_locator/service_locator.dart';

class GoogleAccountValidationScreen extends StatefulWidget {
  const GoogleAccountValidationScreen({super.key});

  static const String checkValidGoogleAccountRoute = "/google-validation";

  @override
  State<GoogleAccountValidationScreen> createState() =>
      _GoogleAccountRegisterValidationScreenState();
}

class _GoogleAccountRegisterValidationScreenState
    extends State<GoogleAccountValidationScreen> {
  final authByGoogleService = locator.get<IAuthenticateByGoogleService>();
  final completeGoogleAuthBloc = CompleteGoogleRegBloc();
  final loginBloc = LoginBloc();

  @override
  void dispose() {
    completeGoogleAuthBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routeArguments = ModalRoute.of(context)!.settings.arguments as Map;
    GoogleSignIn googleSignIn = routeArguments["googleSignIn"];

    final isGoogleRegister = routeArguments["isGoogleRegister"];

    return Scaffold(
      backgroundColor: Colors.green,
      body: FutureBuilder(
        future: authByGoogleService
            .validateGoogleAccount(googleSignIn.currentUser!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            if (snapshot.error.toString().contains("TimeoutException") ||
                snapshot.error.toString().contains("SocketException")) {
              if (isGoogleRegister) {
                completeGoogleAuthBloc.eventController.sink.add(
                    BackwardToRegisterScreenEvent(
                        context: context, message: "Network error"));
              } else {
                loginBloc.eventController.sink.add(BackwardToLoginScreenEvent(
                    context: context, message: "Network error"));
              }
            }
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SpinKitCircle(
                      color: Colors.white,
                    ),
                    Text(
                      "Validating your account...",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: "SourceCodePro"),
                    ),
                  ],
                );
              case ConnectionState.done:
                if (snapshot.hasData) {
                  if (snapshot.data is bool) {
                    if (snapshot.data == true) {
                      if (isGoogleRegister) {
                        completeGoogleAuthBloc.eventController.sink
                            .add(ForwardCompleteGoogleRegisterScreenEvent(
                          context: context,
                          googleSignIn: googleSignIn,
                        ));
                      } else {
                        return AlertDialog(
                          title: const Center(child: Text("Caution")),
                          content: const SizedBox(
                            height: 100,
                            width: 100,
                            child: Center(
                                child: Text("Your email was not registered")),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  completeGoogleAuthBloc.eventController.sink
                                      .add(
                                          CancelChooseAnotherGoogleAccountEvent(
                                              context: context));
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                      fontFamily: "SourceCodePro",
                                      fontWeight: FontWeight.bold),
                                )),
                            TextButton(
                                onPressed: () {
                                  completeGoogleAuthBloc.eventController.sink.add(
                                      ForwardCompleteGoogleRegisterScreenEvent(
                                          context: context,
                                          googleSignIn: googleSignIn));
                                },
                                child: const Text("Register",
                                    style: TextStyle(
                                        fontFamily: "Lobster",
                                        color: Colors.red)))
                          ],
                        );
                      }
                    } else {
                      if (isGoogleRegister) {
                        return AlertDialog(
                          title: const Center(child: Text("Caution")),
                          content: const SizedBox(
                            height: 100,
                            width: 100,
                            child: Center(
                                child: Text("Your email registered on system")),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  completeGoogleAuthBloc.eventController.sink
                                      .add(
                                          CancelChooseAnotherGoogleAccountEvent(
                                              context: context));
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                      fontFamily: "SourceCodePro",
                                      fontWeight: FontWeight.bold),
                                )),
                            TextButton(
                                onPressed: () {
                                  loginBloc.eventController.sink.add(
                                      LogInByGoogleAccountEvent(
                                          context: context,
                                          googleSignIn: googleSignIn));
                                },
                                child: const Text("Login",
                                    style: TextStyle(
                                        fontFamily: "Lobster",
                                        color: Colors.red)))
                          ],
                        );
                      } else {
                        loginBloc.eventController.sink.add(
                            LogInByGoogleAccountEvent(
                                context: context, googleSignIn: googleSignIn));
                      }
                    }
                  }
                }
                break;
              default:
                return Container();
            }
          }

          return Container();
        },
      ),
    );
  }
}
