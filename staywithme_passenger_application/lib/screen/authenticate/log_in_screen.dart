import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:staywithme_passenger_application/bloc/event/log_in_event.dart';
import 'package:staywithme_passenger_application/bloc/log_in_bloc.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/model/login_model.dart';
import 'package:staywithme_passenger_application/service/authentication/auth_service.dart';
import 'package:staywithme_passenger_application/service/authentication/firebase_service.dart';
import 'package:staywithme_passenger_application/service/authentication/google_auth_service.dart';
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
  final _firebase = locator.get<IFirebaseService>();
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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        loginBloc.eventController.sink.add(FocusTextFieldLoginEvent(
            isFocusUsername: false, isFocusPassword: false));
      },
      child: Stack(children: [
        Scaffold(
          body: StreamBuilder(
            stream: loginBloc.stateController.stream,
            initialData: loginBloc.initData(),
            builder: (context, snapshot) {
              return SafeArea(
                  top: true,
                  child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.orange, Colors.white])),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.only(top: 50, bottom: 50),
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
                                                    fontSize: 20,
                                                    color: Colors.greenAccent,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                prefixIcon: const Icon(
                                                  Icons.account_box,
                                                  color: Colors.greenAccent,
                                                ),
                                                suffixIcon: IconButton(
                                                    onPressed: () {
                                                      if (snapshot.data!
                                                              .focusUsernameColor ==
                                                          Colors.black45) {
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
                                                            color:
                                                                Colors.black45,
                                                            width: 2.5)),
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
                                                            color:
                                                                Colors.black45,
                                                            width: 2.5)),
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
                                                      fontSize: 20,
                                                      color: Colors.orange,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                prefixIcon: const Icon(
                                                  Icons.lock,
                                                  color: Colors.orange,
                                                ),
                                                suffixIcon: IconButton(
                                                    onPressed: () {
                                                      if (snapshot.data!
                                                              .focusPasswordColor ==
                                                          Colors.black45) {
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
                                                        Dialog(
                                                            backgroundColor:
                                                                Colors
                                                                    .orangeAccent,
                                                            child: Container(
                                                              height: 70,
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 25,
                                                                      bottom:
                                                                          25),
                                                              child: Center(
                                                                child:
                                                                    FutureBuilder(
                                                                  future: _authService
                                                                      .login(
                                                                          loginModel),
                                                                  builder: (context,
                                                                      futureBuilderSnapshot) {
                                                                    dynamic
                                                                        data =
                                                                        futureBuilderSnapshot
                                                                            .data;
                                                                    switch (futureBuilderSnapshot
                                                                        .connectionState) {
                                                                      case ConnectionState
                                                                          .waiting:
                                                                        return Column(
                                                                          children: const [
                                                                            SpinKitCircle(
                                                                              color: Colors.deepOrangeAccent,
                                                                            ),
                                                                            Text(
                                                                              "Checking your information...",
                                                                              style: TextStyle(fontFamily: "Lobster", color: Colors.black),
                                                                            )
                                                                          ],
                                                                        );
                                                                      case ConnectionState
                                                                          .done:
                                                                        if (data
                                                                            is LoginModel) {
                                                                          return FutureBuilder(
                                                                            future:
                                                                                _firebase.saveLoginInfo(data),
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
                                                                            is ServerExceptionModel) {
                                                                          loginBloc.eventController.sink.add(LogInFailEvent(
                                                                              context: context,
                                                                              message: data.message,
                                                                              excCount: 0));
                                                                        } else if (data
                                                                                is TimeoutException ||
                                                                            data
                                                                                is SocketException) {
                                                                          loginBloc.eventController.sink.add(LogInFailEvent(
                                                                              context: context,
                                                                              message: data.message,
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
                                                  );
                                                }
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.deepOrangeAccent,
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
                      ],
                    ),
                  ));
            },
          ),
        ),
      ]),
    );
  }
}

class LoginLoadingScreen extends StatefulWidget {
  const LoginLoadingScreen({super.key});
  static String loginLoadingScreenRoute = "/login-loading";

  @override
  State<LoginLoadingScreen> createState() => _LoginLoadingScreenState();
}

class _LoginLoadingScreenState extends State<LoginLoadingScreen> {
  final loginBloc = LoginBloc();
  final firebaseAuth = locator.get<IAuthenticateByGoogleService>();

  @override
  void dispose() {
    loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contextArgurments = ModalRoute.of(context)!.settings.arguments as Map;
    String email = contextArgurments["email"];
    String username = contextArgurments["username"];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.orange, Colors.white])),
        child: FutureBuilder(
          future: firebaseAuth.informLoginToFireAuth(email),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SpinKitCircle(
                          color: Colors.white,
                        ),
                        Text(
                          "Just a minutes...",
                          style: TextStyle(fontFamily: "Lobster"),
                        )
                      ]),
                );
              case ConnectionState.done:
                loginBloc.eventController.sink.add(InformLoginToFireAuthEvent(
                    context: context, email: email, username: username));
                break;
              default:
                break;
            }

            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.orange, Colors.white]),
              ),
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.check_box_rounded,
                        color: Colors.greenAccent,
                        size: 50,
                      ),
                      Text(
                        "Success",
                        style: TextStyle(fontFamily: "Lobster"),
                      )
                    ]),
              ),
            );
          },
        ),
      ),
    );
  }
}
