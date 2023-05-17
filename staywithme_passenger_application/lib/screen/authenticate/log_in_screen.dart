import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:staywithme_passenger_application/bloc/event/log_in_event.dart';
import 'package:staywithme_passenger_application/bloc/log_in_bloc.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/model/login_model.dart';
import 'package:staywithme_passenger_application/service/authentication/auth_service.dart';

import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String loginScreenRoute = "/log-in";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final loginBloc = LoginBloc();

  final _authService = locator.get<IAuthenticateService>();
  //final _firebaseAuth = locator.get<IAuthenticateByGoogleService>();

  @override
  void dispose() {
    loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dynamic contextArguments =
        ModalRoute.of(context)!.settings.arguments as Map?;

    dynamic isExceptionOccured = contextArguments != null
        ? contextArguments["isExceptionOccured"]
        : false;

    dynamic message =
        contextArguments != null ? contextArguments["message"] : null;

    dynamic excCount =
        contextArguments != null ? contextArguments["excCount"] : 0;

    TextEditingController usernameTextEditingController =
        contextArguments != null &&
                contextArguments["usernameTextEditingController"] != null
            ? contextArguments["usernameTextEditingController"]
            : TextEditingController();

    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          loginBloc.eventController.sink.add(FocusTextFieldLoginEvent(
              isFocusUsername: false, isFocusPassword: false));
        },
        child: Stack(children: [
          Scaffold(
            body: StreamBuilder(
              stream: loginBloc.stateController.stream,
              initialData:
                  loginBloc.initData(usernameTextEditingController.text),
              builder: (context, snapshot) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.orange, Colors.white])),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(seconds: 1),
                        builder: (context, value, child) => Opacity(
                          opacity: value,
                          child: child,
                        ),
                        child: Container(
                          color: Colors.white,
                          // padding: const EdgeInsets.only(top: 50, bottom: 50),
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "Login",
                                style: TextStyle(
                                    fontFamily: "Lobster",
                                    fontSize: 50,
                                    color: Colors.black45),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              Form(
                                  key: formKey,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: 300,
                                          child: TextFormField(
                                            controller:
                                                usernameTextEditingController,
                                            style: const TextStyle(
                                                color: Colors.black45),
                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                label: const Text(
                                                  "Username",
                                                  style: TextStyle(
                                                    fontFamily: "Lobster",
                                                    color: primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                prefixIcon: const Icon(
                                                  Icons.account_box,
                                                  color: primaryColor,
                                                ),
                                                suffixIcon: IconButton(
                                                    onPressed: () {
                                                      if (snapshot.data!
                                                              .focusUsernameColor ==
                                                          secondaryColor) {
                                                        usernameTextEditingController
                                                            .clear();
                                                        loginBloc
                                                            .eventController
                                                            .sink
                                                            .add(InputUsernameLoginEvent(
                                                                username:
                                                                    usernameTextEditingController
                                                                        .text));
                                                      }
                                                    },
                                                    icon: Icon(
                                                      Icons.close,
                                                      color: snapshot.data!
                                                          .focusUsernameColor,
                                                    )),
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent,
                                                            width: 2.5)),
                                                focusedBorder:
                                                    const UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                secondaryColor,
                                                            width: 3.0)),
                                                errorStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.redAccent)),
                                            onTap: () => loginBloc
                                                .eventController.sink
                                                .add(FocusTextFieldLoginEvent(
                                                    isFocusUsername: true,
                                                    isFocusPassword: false)),
                                            onChanged: (value) => loginBloc
                                                .eventController.sink
                                                .add(InputUsernameLoginEvent(
                                                    username: value)),
                                            validator: (value) => snapshot.data!
                                                .validateUsername(),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        SizedBox(
                                          width: 300,
                                          child: TextFormField(
                                            obscureText:
                                                snapshot.data!.isShowPassword!,
                                            style: const TextStyle(
                                                color: Colors.black45),
                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .transparent,
                                                            width: 2.5)),
                                                focusedBorder:
                                                    const UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                secondaryColor,
                                                            width: 3.0)),
                                                errorBorder:
                                                    const OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    3.0)),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.orange,
                                                            width: 1.0)),
                                                errorStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.redAccent),
                                                label: const Text(
                                                  "Password",
                                                  style: TextStyle(
                                                      fontFamily: "Lobster",
                                                      color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                prefixIcon: const Icon(
                                                  Icons.lock,
                                                  color: primaryColor,
                                                ),
                                                suffixIcon: IconButton(
                                                    onPressed: () {
                                                      if (snapshot.data!
                                                              .focusPasswordColor ==
                                                          secondaryColor) {
                                                        loginBloc
                                                            .eventController
                                                            .sink
                                                            .add(
                                                                ShowPasswordLoginEvent());
                                                      }
                                                    },
                                                    icon: Icon(
                                                      Icons.remove_red_eye,
                                                      color: snapshot.data!
                                                          .focusPasswordColor,
                                                    ))),
                                            onTap: () => loginBloc
                                                .eventController.sink
                                                .add(FocusTextFieldLoginEvent(
                                                    isFocusPassword: true,
                                                    isFocusUsername: false)),
                                            onChanged: (value) => loginBloc
                                                .eventController.sink
                                                .add(InputPasswordLoginEvent(
                                                    password: value)),
                                            validator: (value) => snapshot.data!
                                                .validatePassword(),
                                          ),
                                        ),
                                        isExceptionOccured == true
                                            ? Container(
                                                margin: const EdgeInsets.only(
                                                    top: 20),
                                                child: Text(
                                                  message,
                                                  style: const TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            : message != null
                                                ? Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 20),
                                                    child: Text(
                                                      message,
                                                      style: const TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                if (excCount == 2) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (alertContext) =>
                                                        AlertDialog(
                                                      title: const Center(
                                                          child: Text(
                                                              "Notification")),
                                                      content: const SizedBox(
                                                        height: 100,
                                                        child: Center(
                                                            child: Text(
                                                                "Do you forget your password?")),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pushReplacementNamed(
                                                                  context,
                                                                  LoginScreen
                                                                      .loginScreenRoute,
                                                                  arguments: {
                                                                    "excCount":
                                                                        0
                                                                  });
                                                            },
                                                            child: const Text(
                                                              "Cancel",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .green),
                                                            )),
                                                        TextButton(
                                                            onPressed: () {
                                                              loginBloc
                                                                  .eventController
                                                                  .sink
                                                                  .add(NavigateToForgetPasswordScreenEvent(
                                                                      context:
                                                                          context));
                                                            },
                                                            child: const Text(
                                                              "Change",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            ))
                                                      ],
                                                    ),
                                                  );
                                                } else {
                                                  LoginModel loginModel =
                                                      LoginModel(
                                                          username: snapshot
                                                              .data!.username,
                                                          password: snapshot
                                                              .data!.password);

                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        TweenAnimationBuilder(
                                                      tween: Tween<double>(
                                                          begin: 0, end: 1),
                                                      duration: const Duration(
                                                          milliseconds: 500),
                                                      builder: (context, value,
                                                              child) =>
                                                          Opacity(
                                                        opacity: value,
                                                        child: child,
                                                      ),
                                                      child: Dialog(
                                                          backgroundColor:
                                                              Colors
                                                                  .orangeAccent,
                                                          child: Container(
                                                            height: 70,
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 25,
                                                                    bottom: 25),
                                                            child: Center(
                                                              child:
                                                                  FutureBuilder(
                                                                future: _authService
                                                                    .login(
                                                                        loginModel),
                                                                builder: (context,
                                                                    futureBuilderSnapshot) {
                                                                  switch (futureBuilderSnapshot
                                                                      .connectionState) {
                                                                    case ConnectionState
                                                                        .waiting:
                                                                      return Column(
                                                                        children: const [
                                                                          SpinKitCircle(
                                                                            color:
                                                                                Colors.deepOrangeAccent,
                                                                          ),
                                                                          Text(
                                                                            "Checking your information...",
                                                                            style:
                                                                                TextStyle(fontFamily: "Lobster", color: Colors.black),
                                                                          )
                                                                        ],
                                                                      );
                                                                    case ConnectionState
                                                                        .done:
                                                                      dynamic
                                                                          data =
                                                                          futureBuilderSnapshot
                                                                              .data;
                                                                      if (data
                                                                          is LoginModel) {
                                                                        return FutureBuilder(
                                                                          future:
                                                                              Future.delayed(const Duration(seconds: 3)),
                                                                          builder:
                                                                              (context, snapshot) {
                                                                            switch (snapshot.connectionState) {
                                                                              case ConnectionState.waiting:
                                                                                return Column(
                                                                                  children: const [
                                                                                    SpinKitCircle(
                                                                                      color: Colors.deepOrangeAccent,
                                                                                    ),
                                                                                    Text(
                                                                                      "Loging in...",
                                                                                      style: TextStyle(fontFamily: "Lobster", color: Colors.black),
                                                                                    )
                                                                                  ],
                                                                                );
                                                                              case ConnectionState.done:
                                                                                loginBloc.eventController.sink.add(LogInSuccessEvent(context: context, email: data.email, username: data.username));
                                                                                break;
                                                                              default:
                                                                                break;
                                                                            }
                                                                            return const SizedBox();
                                                                          },
                                                                        );
                                                                      } else if (data
                                                                          is Exception) {
                                                                        return Column(
                                                                          children: [
                                                                            const Text(
                                                                              "Invalid account",
                                                                              style: TextStyle(fontFamily: "Lobster", color: Colors.black),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 2,
                                                                            ),
                                                                            TextButton(
                                                                                onPressed: () => Navigator.pop(context),
                                                                                child: const Text(
                                                                                  "Back",
                                                                                  style: TextStyle(color: Colors.green),
                                                                                ))
                                                                          ],
                                                                        );
                                                                      } else if (data
                                                                          is ServerExceptionModel) {
                                                                        loginBloc.eventController.sink.add(LogInFailEvent(
                                                                            context:
                                                                                context,
                                                                            message:
                                                                                data.message,
                                                                            excCount: 0));
                                                                      } else if (data
                                                                              is TimeoutException ||
                                                                          data
                                                                              is SocketException) {
                                                                        loginBloc.eventController.sink.add(LogInFailEvent(
                                                                            context:
                                                                                context,
                                                                            message:
                                                                                data.message,
                                                                            excCount: null));
                                                                      }

                                                                      break;
                                                                    default:
                                                                      return const Text(
                                                                          "done");
                                                                  }
                                                                  return const SizedBox();
                                                                },
                                                              ),
                                                            ),
                                                          )),
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: secondaryColor,
                                                minimumSize:
                                                    const Size(300, 50),
                                                maximumSize:
                                                    const Size(300, 50)),
                                            child: const Text(
                                              "Login",
                                              style: TextStyle(
                                                  fontFamily: "Lobster"),
                                            )),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  loginBloc.eventController.add(
                                                      ChooseGoogleAccountEvent(
                                                          context: context));
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                    minimumSize:
                                                        const Size(140, 50),
                                                    maximumSize:
                                                        const Size(140, 50)),
                                                child: const Text(
                                                  "Google",
                                                  style: TextStyle(
                                                      fontFamily: "Lobster"),
                                                )),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  loginBloc.eventController.sink
                                                      .add(
                                                          NavigateToRegScreenEvent(
                                                              context:
                                                                  context));
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.greenAccent,
                                                    minimumSize:
                                                        const Size(140, 50),
                                                    maximumSize:
                                                        const Size(140, 50)),
                                                child: const Text(
                                                  "Register",
                                                  style: TextStyle(
                                                      fontFamily: "Lobster"),
                                                )),
                                          ],
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              loginBloc.eventController.sink.add(
                                                  NavigateToForgetPasswordScreenEvent(
                                                      context: context));
                                            },
                                            child:
                                                const Text("Forget password?"))
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
