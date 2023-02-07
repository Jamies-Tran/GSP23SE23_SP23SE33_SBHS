import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/change_password_bloc.dart';
import 'package:staywithme_passenger_application/bloc/event/change_password_event.dart';
import 'package:staywithme_passenger_application/bloc/state/change_password_state.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});
  static const changePasswordScreenRoute = "/change-password";

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final newPasswordTextEditingController = TextEditingController();
  final rePasswordTextEditingController = TextEditingController();
  final changePasswordBloc = ChangePasswordBloc();

  @override
  void dispose() {
    changePasswordBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    String email = contextArguments["email"];
    bool isExceptionOccured = contextArguments["isExceptionOccured"] ?? false;
    String message = contextArguments["message"] ?? "";

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            StreamBuilder<ChangePasswordState>(
                initialData: changePasswordBloc.initData(),
                stream: changePasswordBloc.stateController.stream,
                builder: (context, snapshot) {
                  return Container(
                    margin: const EdgeInsets.only(top: 250, bottom: 200),
                    padding: const EdgeInsets.all(20),
                    width: 300,
                    height: 400,
                    decoration:
                        const BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurStyle: BlurStyle.normal,
                          blurRadius: 5.0,
                          offset: Offset(5.0, 5.0))
                    ]),
                    child: Column(children: [
                      const Text(
                        "Change password",
                        style: TextStyle(
                            fontFamily: "Lobster",
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
                                controller: newPasswordTextEditingController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    label: const Text("New password"),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(2.0),
                                        borderSide: const BorderSide(
                                            color: Colors.grey, width: 1.0)),
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black45, width: 1.0)),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(2.0),
                                        borderSide: const BorderSide(
                                            color: Colors.red, width: 1.0))),
                                onChanged: (value) => changePasswordBloc
                                    .eventController.sink
                                    .add(InputNewPasswordEvent(
                                        newPassword: value)),
                                validator: (value) =>
                                    snapshot.data!.validateNewPassword(),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                  controller: rePasswordTextEditingController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      label: const Text("re-enter password"),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(2.0),
                                          borderSide: const BorderSide(
                                              color: Colors.grey, width: 1.0)),
                                      focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black45,
                                              width: 1.0)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(2.0),
                                          borderSide: const BorderSide(
                                              color: Colors.red, width: 1.0))),
                                  onChanged: (value) => changePasswordBloc
                                      .eventController.sink
                                      .add(InputRePasswordEvent(
                                          rePassword: value)),
                                  validator: (value) =>
                                      snapshot.data!.validateRePassword()),
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
                                      backgroundColor: Colors.green,
                                      minimumSize: const Size(150, 50),
                                      maximumSize: const Size(150, 50)),
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      if (!snapshot.data!.isRePasswordValid()) {
                                        changePasswordBloc.eventController.sink.add(
                                            BackwardToChangePasswordScreenEvent(
                                                context: context,
                                                message:
                                                    "Invalid re-password"));
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Center(
                                                child: Text("Confirm")),
                                            content: Container(
                                              margin: const EdgeInsets.all(20),
                                              height: 100,
                                              width: 100,
                                              child: const Text(
                                                  "Do you want to change password?"),
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {},
                                                  child: const Text(
                                                    "No",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  )),
                                              TextButton(
                                                  onPressed: () {
                                                    changePasswordBloc
                                                        .eventController.sink
                                                        .add(PasswordModificationEvent(
                                                            context: context,
                                                            email: email,
                                                            newPassword: snapshot
                                                                .data!
                                                                .newPassword));
                                                  },
                                                  child: const Text(
                                                    "Yes",
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  ))
                                            ],
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: const Text(
                                    "Change",
                                    style: TextStyle(
                                        fontFamily: "Lobster",
                                        fontWeight: FontWeight.bold),
                                  )),
                              const SizedBox(
                                height: 15,
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.red),
                                  ))
                            ],
                          )),
                    ]),
                  );
                }),
          ],
        )),
      )),
    );
  }
}
