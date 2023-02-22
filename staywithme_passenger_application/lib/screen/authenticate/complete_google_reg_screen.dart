import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:staywithme_passenger_application/bloc/complete_google_reg_bloc.dart';
import 'package:staywithme_passenger_application/bloc/event/reg_google_event.dart';
import 'package:staywithme_passenger_application/global_variable.dart';

import '../../model/auto_complete_model.dart';
import '../../service/user/auto_complete_service.dart';
import '../../service_locator/service_locator.dart';

class CompleteGoogleRegisterScreen extends StatefulWidget {
  const CompleteGoogleRegisterScreen({super.key});

  static const completeGoogleRegisterScreenRoute = "/complete_google_sign_in";

  @override
  State<CompleteGoogleRegisterScreen> createState() =>
      _CompleteGoogleRegisterScreenState();
}

class _CompleteGoogleRegisterScreenState
    extends State<CompleteGoogleRegisterScreen> {
  final completeGoogleRegisterBloc = CompleteGoogleRegBloc();
  final formState = GlobalKey<FormState>();
  final dobTextFieldController = TextEditingController();
  final TextEditingController phoneTextFieldController =
      TextEditingController();

  final dateFormat = DateFormat("yyyy-MM-dd");
  String displayStringForOption(Prediction prediction) =>
      utf8.decode(prediction.description!.runes.toList());
  final autoCompleteService = locator.get<IAutoCompleteService>();

  @override
  void dispose() {
    completeGoogleRegisterBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final getArguments = ModalRoute.of(context)!.settings.arguments as Map;
    // GoogleSignInAccount googleSignInAccount =
    //     getArguments["googleSignInAccount"];
    final TextEditingController usernameTextFieldController =
        getArguments["usernameTextEditingCtl"];
    final TextEditingController emailTextFieldController =
        getArguments["emailTextEditingCtl"];

    final GoogleSignIn googleSignIn = getArguments["googleSignIn"];
    dynamic isExceptionOccured = getArguments["isExceptionOccured"] ?? false;
    dynamic message = getArguments["message"];

    return GestureDetector(
      onTap: () {
        completeGoogleRegisterBloc.eventController.sink.add(
            FocusTextFieldCompleteGoogleRegEvent(
                isFocusOnAddress: false,
                isFocusOnBirthDay: false,
                isFocusOnIdCardNumber: false,
                isFocusOnPhone: false,
                isFocusOnUsername: false));
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [secondaryColor, Colors.white, primaryColor]),
          ),
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            child: SingleChildScrollView(
              child: StreamBuilder(
                stream: completeGoogleRegisterBloc.stateController.stream,
                initialData: completeGoogleRegisterBloc.initData(
                    usernameTextFieldController.text,
                    emailTextFieldController.text),
                builder: (context, snapshot) {
                  return Container(
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 50),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Column(children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const Center(
                        child: Text(
                          "Additional Information",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Form(
                          key: formState,
                          child: Column(
                            children: [
                              SizedBox(
                                width: 300,
                                child: TextFormField(
                                  controller: usernameTextFieldController,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5),
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      label: const Text(
                                        "Username",
                                        style: TextStyle(
                                            fontFamily: "Lobster",
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.account_circle,
                                        color: primaryColor,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color:
                                              snapshot.data!.focusUsernameColor,
                                        ),
                                        onPressed: () {
                                          usernameTextFieldController.clear();
                                          completeGoogleRegisterBloc
                                              .eventController.sink
                                              .add(InputUsernameGoogleAuthEvent(
                                                  username:
                                                      usernameTextFieldController
                                                          .text));
                                        },
                                      ),
                                      enabledBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 1.0)),
                                      focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: secondaryColor,
                                              width: 1.0)),
                                      errorStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.redAccent)),
                                  onTap: () => completeGoogleRegisterBloc
                                      .eventController.sink
                                      .add(FocusTextFieldCompleteGoogleRegEvent(
                                          isFocusOnUsername: true,
                                          isFocusOnAddress: false,
                                          isFocusOnBirthDay: false,
                                          isFocusOnIdCardNumber: false,
                                          isFocusOnPhone: false)),
                                  onChanged: (value) =>
                                      completeGoogleRegisterBloc
                                          .eventController.sink
                                          .add(InputUsernameGoogleAuthEvent(
                                              username: value)),
                                  validator: (value) =>
                                      snapshot.data!.validateUsername(),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              SizedBox(
                                width: 300,
                                child: TextFormField(
                                  controller: emailTextFieldController,
                                  readOnly: true,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5),
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      label: const Text(
                                        "Email",
                                        style: TextStyle(
                                            fontFamily: "Lobster",
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.mail,
                                        color: Colors.orange,
                                      ),
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                backgroundColor: primaryColor,
                                                title: const Center(
                                                  child: Text(
                                                    "Change account",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                content: const Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                    "Do you want to change google account?",
                                                    style: TextStyle(
                                                        fontFamily: "Lobster",
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                actions: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      TextButton(
                                                          onPressed: () {
                                                            completeGoogleRegisterBloc
                                                                .eventController
                                                                .sink
                                                                .add(CancelChooseAnotherGoogleAccountEvent(
                                                                    context:
                                                                        context,
                                                                    googleSignIn:
                                                                        googleSignIn));
                                                          },
                                                          child: const Text(
                                                            "Cancel",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Lobster",
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )),
                                                      TextButton(
                                                          onPressed: () {
                                                            completeGoogleRegisterBloc
                                                                .eventController
                                                                .sink
                                                                .add(CancelCompleteGoogleAccountRegisterEvent(
                                                                    context:
                                                                        context,
                                                                    googleSignIn:
                                                                        googleSignIn,
                                                                    isChangeGoogleAccount:
                                                                        true));
                                                          },
                                                          child: const Text(
                                                            "Change",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Lobster",
                                                                color: Colors
                                                                    .green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ))
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.restart_alt,
                                            color: secondaryColor,
                                          )),
                                      enabledBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 1.0)),
                                      focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: secondaryColor,
                                              width: 1.0)),
                                      errorStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.redAccent)),
                                  onChanged: (value) =>
                                      completeGoogleRegisterBloc
                                          .eventController.sink
                                          .add(ReceiveEmailGoogleAuthEvent(
                                              email: value)),
                                  validator: (value) =>
                                      snapshot.data!.validateEmail(),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              SizedBox(
                                width: 300,
                                child: TextFormField(
                                  keyboardType: TextInputType.phone,
                                  controller: phoneTextFieldController,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5),
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      label: const Text(
                                        "Phone",
                                        style: TextStyle(
                                            fontFamily: "Lobster",
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.phone,
                                        color: primaryColor,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: snapshot.data!.focusPhoneColor,
                                        ),
                                        onPressed: () {
                                          phoneTextFieldController.clear();
                                          completeGoogleRegisterBloc
                                              .eventController.sink
                                              .add(InputPhoneGoogleAuthEvent(
                                                  phone:
                                                      phoneTextFieldController
                                                          .text));
                                        },
                                      ),
                                      enabledBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 1.0)),
                                      focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: secondaryColor,
                                              width: 1.0)),
                                      errorStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.redAccent)),
                                  onTap: () => completeGoogleRegisterBloc
                                      .eventController.sink
                                      .add(FocusTextFieldCompleteGoogleRegEvent(
                                          isFocusOnPhone: true,
                                          isFocusOnAddress: false,
                                          isFocusOnBirthDay: false,
                                          isFocusOnIdCardNumber: false,
                                          isFocusOnUsername: false)),
                                  onChanged: (value) =>
                                      completeGoogleRegisterBloc
                                          .eventController.sink
                                          .add(InputPhoneGoogleAuthEvent(
                                              phone: value)),
                                  validator: (value) =>
                                      snapshot.data!.validatePhone(),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Autocomplete<Prediction>(
                                displayStringForOption: displayStringForOption,
                                fieldViewBuilder: (context,
                                    textEditingController,
                                    focusNode,
                                    onFieldSubmitted) {
                                  return SizedBox(
                                    width: 300,
                                    child: TextFormField(
                                      controller: textEditingController,
                                      focusNode: focusNode,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5),
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          label: const Text(
                                            "Address",
                                            style: TextStyle(
                                                fontFamily: "Lobster",
                                                color: primaryColor,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.5),
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.location_city,
                                            color: primaryColor,
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              Icons.close,
                                              color: snapshot
                                                  .data!.focusAddressColor,
                                            ),
                                            onPressed: () {
                                              textEditingController.clear();
                                              completeGoogleRegisterBloc
                                                  .eventController.sink
                                                  .add(InputAddressGoogleAuthEvent(
                                                      address:
                                                          textEditingController
                                                              .text));
                                            },
                                          ),
                                          enabledBorder:
                                              const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white,
                                                      width: 1.0)),
                                          focusedBorder:
                                              const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: secondaryColor,
                                                      width: 1.0)),
                                          errorStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.redAccent)),
                                      onTap: () => completeGoogleRegisterBloc
                                          .eventController.sink
                                          .add(
                                              FocusTextFieldCompleteGoogleRegEvent(
                                                  isFocusOnAddress: true,
                                                  isFocusOnBirthDay: false,
                                                  isFocusOnIdCardNumber: false,
                                                  isFocusOnPhone: false,
                                                  isFocusOnUsername: false)),
                                      validator: (value) =>
                                          snapshot.data!.validateAddress(),
                                    ),
                                  );
                                },
                                optionsBuilder: (textEditingValue) {
                                  if (textEditingValue.text.isEmpty ||
                                      textEditingValue.text == '') {
                                    return const Iterable.empty();
                                  }

                                  return autoCompleteService
                                      .autoComplet(textEditingValue.text)
                                      .then((value) {
                                    if (value is PlacesResult) {
                                      return value.predictions!.where(
                                          (element) => utf8
                                              .decode(element.description!.runes
                                                  .toList())
                                              .toLowerCase()
                                              .contains(textEditingValue.text
                                                  .toLowerCase()));
                                    } else {
                                      return const Iterable.empty();
                                    }
                                  });
                                },
                                onSelected: (option) =>
                                    completeGoogleRegisterBloc
                                        .eventController.sink
                                        .add(InputAddressGoogleAuthEvent(
                                            address: utf8.decode(option
                                                .description!.runes
                                                .toList()))),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              SizedBox(
                                width: 300,
                                child: TextFormField(
                                  readOnly: true,
                                  controller: dobTextFieldController,
                                  style: const TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    label: Text(
                                      "Birthday",
                                      style: TextStyle(
                                        fontFamily: "Lobster",
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.calendar_month,
                                      color: primaryColor,
                                    ),
                                    // suffixIcon: IconButton(
                                    //     onPressed: () {
                                    //       if (snapshot.data!.focusBirthdayColor ==
                                    //           secondaryColor) {
                                    //         dobTextFieldController.clear();
                                    //         registerBloc.eventController.sink.add(
                                    //             InputDobEvent(
                                    //                 dob: dobTextFieldController
                                    //                     .text));
                                    //       }
                                    //     },
                                    //     icon: Icon(
                                    //       Icons.close,
                                    //       color:
                                    //           snapshot.data!.focusBirthdayColor,
                                    //     )),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 2.5)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: secondaryColor, width: 3.0)),
                                    errorStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent),
                                  ),
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime(1980),
                                      firstDate: DateTime(1980),
                                      lastDate: DateTime(2004),
                                    ).then((value) {
                                      dobTextFieldController.text =
                                          dateFormat.format(value!);
                                      completeGoogleRegisterBloc
                                          .eventController.sink
                                          .add(InputDobGoogleAuthEvent(
                                              dob:
                                                  dobTextFieldController.text));
                                      completeGoogleRegisterBloc
                                          .eventController.sink
                                          .add(FocusTextFieldCompleteGoogleRegEvent(
                                              //isFocusOnBirthday: true,
                                              isFocusOnAddress: false,
                                              //isFocusOnCitizenIdentification:
                                              //false,
                                              //isFocusOnEmail: false,
                                              //isFocusOnPassword: false,
                                              isFocusOnPhone: false,
                                              isFocusOnUsername: false));
                                    });
                                  },
                                  validator: (value) =>
                                      snapshot.data!.validateDob(),
                                ),
                              ),
                              isExceptionOccured == true
                                  ? Container(
                                      margin: const EdgeInsets.only(
                                          top: 25, bottom: 25),
                                      child: Text(
                                        message,
                                        style: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : const SizedBox(
                                      height: 50,
                                    ),
                              ElevatedButton(
                                  onPressed: () {
                                    if (formState.currentState!.validate()) {
                                      completeGoogleRegisterBloc
                                          .eventController.sink
                                          .add(
                                              SubmitGoogleCompleteRegisterEvent(
                                                  address:
                                                      snapshot.data!.address,
                                                  idCardNumber: snapshot
                                                      .data!.idCardNumber,
                                                  dob: snapshot.data!.dob,
                                                  email: snapshot.data!.email,
                                                  gender: snapshot.data!.gender,
                                                  phone: snapshot.data!.phone,
                                                  username:
                                                      snapshot.data!.username,
                                                  googleSignIn: googleSignIn,
                                                  // googleSignInAccount:
                                                  //     googleSignInAccount,
                                                  context: context));
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: secondaryColor,
                                      minimumSize: const Size(300, 50),
                                      maximumSize: const Size(300, 50)),
                                  child: const Text(
                                    "Submit",
                                    style: TextStyle(fontFamily: "Lobster"),
                                  )),
                              const SizedBox(
                                height: 25,
                              ),
                              TextButton(
                                  onPressed: (() async {
                                    completeGoogleRegisterBloc
                                        .eventController.sink
                                        .add(
                                            CancelCompleteGoogleAccountRegisterEvent(
                                                context: context,
                                                googleSignIn: googleSignIn,
                                                isChangeGoogleAccount: false));
                                  }),
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.red),
                                  ))
                            ],
                          ))
                    ]),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
