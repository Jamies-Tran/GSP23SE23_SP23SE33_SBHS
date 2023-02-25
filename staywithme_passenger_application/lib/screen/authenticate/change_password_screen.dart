import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:staywithme_passenger_application/bloc/change_password_bloc.dart';
import 'package:staywithme_passenger_application/bloc/event/change_password_event.dart';
import 'package:staywithme_passenger_application/bloc/state/change_password_state.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/service/authentication/auth_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});
  static const String changePasswordScreenRoute = "/change-password";

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final changePasswordBloc = ChangePasswordBloc();
  final formKey = GlobalKey<FormState>();
  final authService = locator.get<IAuthenticateService>();

  @override
  void dispose() {
    changePasswordBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map?;
    final isExcOccured =
        contextArguments != null && contextArguments["isExcOccured"] != null
            ? contextArguments["isExcOccured"]
            : false;
    final msg = contextArguments != null ? contextArguments["msg"] : null;
    final email = contextArguments!["email"];

    return StreamBuilder<ChangePasswordState>(
        stream: changePasswordBloc.stateController.stream,
        initialData: changePasswordBloc.initData(),
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
                            "Change password",
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
                                  TweenAnimationBuilder(
                                    tween: Tween<double>(begin: 0, end: 1),
                                    duration: const Duration(seconds: 4),
                                    builder: (context, value, child) => Opacity(
                                      opacity: value,
                                      child: child,
                                    ),
                                    child: TweenAnimationBuilder(
                                      tween: Tween<double>(begin: 200, end: 0),
                                      duration: const Duration(seconds: 4),
                                      builder: (context, value, child) =>
                                          Container(
                                        margin: EdgeInsets.only(left: value),
                                        child: child,
                                      ),
                                      child: TextFormField(
                                        decoration: const InputDecoration(
                                            hintText: "Enter new password",
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: primaryColor,
                                                    width: 1.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: primaryColor),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            errorBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red,
                                                    width: 1.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            hintStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.451))),
                                        onChanged: (value) => changePasswordBloc
                                            .eventController.sink
                                            .add(InputNewPasswordEvent(
                                                newPassword: value)),
                                        validator: (value) => snapshot.data!
                                            .validateNewPassword(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TweenAnimationBuilder(
                                    tween: Tween<double>(begin: 0, end: 1),
                                    duration: const Duration(seconds: 4),
                                    builder: (context, value, child) => Opacity(
                                      opacity: value,
                                      child: child,
                                    ),
                                    child: TweenAnimationBuilder(
                                      tween: Tween<double>(begin: 200, end: 0),
                                      duration: const Duration(seconds: 4),
                                      builder: (context, value, child) =>
                                          Container(
                                        margin: EdgeInsets.only(right: value),
                                        child: child,
                                      ),
                                      child: TextFormField(
                                        decoration: const InputDecoration(
                                            hintText: "Re-enter password",
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: primaryColor,
                                                    width: 1.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: primaryColor),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            errorBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red,
                                                    width: 1.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            hintStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.451))),
                                        onChanged: (value) => changePasswordBloc
                                            .eventController.sink
                                            .add(InputRePasswordEvent(
                                                rePassword: value)),
                                        validator: (value) =>
                                            snapshot.data!.validateRePassword(),
                                      ),
                                    ),
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
                                                          .changePassword(
                                                              snapshot.data!
                                                                  .newPassword!,
                                                              email),
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
                                                                  "Please wait...",
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
                                                                changePasswordBloc
                                                                    .eventController
                                                                    .sink
                                                                    .add(ChangePasswordSuccessEvent(
                                                                        context:
                                                                            context));
                                                              } else if (data
                                                                  is ServerExceptionModel) {
                                                                changePasswordBloc
                                                                    .eventController
                                                                    .sink
                                                                    .add(BackWardToChangePasswordScreenEvent(
                                                                        context:
                                                                            context,
                                                                        isExcOccured:
                                                                            true,
                                                                        msg: data
                                                                            .message,
                                                                        email:
                                                                            email));
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
                                          "Change",
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
