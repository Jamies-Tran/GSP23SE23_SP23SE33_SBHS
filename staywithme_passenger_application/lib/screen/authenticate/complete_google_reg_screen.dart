import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:staywithme_passenger_application/bloc/complete_google_reg_bloc.dart';
import 'package:staywithme_passenger_application/bloc/event/reg_google_event.dart';

// TODO: update complete gg reg screen
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
  final dateFormat = DateFormat("yyyy-MM-dd");

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
    final TextEditingController phoneTextFieldController =
        TextEditingController();
    final TextEditingController addressTextFieldController =
        TextEditingController();

    final GoogleSignIn googleSignIn = getArguments["googleSignIn"];
    dynamic isExceptionOccured = getArguments["isExceptionOccured"] ?? false;
    dynamic message = getArguments["message"];

    return GestureDetector(
      onTap: () {
        completeGoogleRegisterBloc.eventController.sink.add(
            FocusTextFieldCompleteGoogleRegEvent(
                isFocusOnAddress: false,
                isFocusOnBirthDay: false,
                isFocusOnCitizenIdentification: false,
                isFocusOnPhone: false,
                isFocusOnUsername: false));
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(left: 15, right: 15, top: 50),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    StreamBuilder(
                      stream: completeGoogleRegisterBloc.stateController.stream,
                      initialData: completeGoogleRegisterBloc.initData(
                          usernameTextFieldController.text,
                          emailTextFieldController.text),
                      builder: (context, snapshot) {
                        return Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(children: [
                            Center(
                              child: Column(children: const [
                                Text(
                                  "Additional Information",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                              ]),
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
                                                  fontFamily: "SourceCodePro",
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.5),
                                            ),
                                            prefixIcon: const Icon(
                                              Icons.account_circle,
                                              color: Colors.black45,
                                            ),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                color: snapshot
                                                    .data!.focusUsernameColor,
                                              ),
                                              onPressed: () {
                                                usernameTextFieldController
                                                    .clear();
                                                completeGoogleRegisterBloc
                                                    .eventController.sink
                                                    .add(InputUsernameGoogleAuthEvent(
                                                        username:
                                                            usernameTextFieldController
                                                                .text));
                                              },
                                            ),
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white,
                                                        width: 1.0)),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black45,
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
                                                isFocusOnCitizenIdentification:
                                                    false,
                                                isFocusOnPhone: false)),
                                        onChanged: (value) =>
                                            completeGoogleRegisterBloc
                                                .eventController.sink
                                                .add(
                                                    InputUsernameGoogleAuthEvent(
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
                                                  fontFamily: "SourceCodePro",
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.5),
                                            ),
                                            prefixIcon: const Icon(
                                              Icons.mail,
                                              color: Colors.black45,
                                            ),
                                            suffixIcon: IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: const Center(
                                                        child: Text(
                                                          "Choose account",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      content: const Padding(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: Text(
                                                          "Do you want to change google account?",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "SourceCodePro",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      actions: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  completeGoogleRegisterBloc
                                                                      .eventController
                                                                      .sink
                                                                      .add(CancelChooseAnotherGoogleAccountEvent(
                                                                          context:
                                                                              context));
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "Cancel",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "SourceCodePro",
                                                                      color: Colors
                                                                          .red,
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
                                                                child:
                                                                    const Text(
                                                                  "Change",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "SourceCodePro",
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
                                                    Icons.restart_alt)),
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white,
                                                        width: 1.0)),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black45,
                                                        width: 1.0)),
                                            errorStyle: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.redAccent)),
                                        onChanged: (value) =>
                                            completeGoogleRegisterBloc
                                                .eventController.sink
                                                .add(
                                                    ReceiveEmailGoogleAuthEvent(
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
                                                  fontFamily: "SourceCodePro",
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.5),
                                            ),
                                            prefixIcon: const Icon(
                                              Icons.phone,
                                              color: Colors.black45,
                                            ),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                color: snapshot
                                                    .data!.focusPhoneColor,
                                              ),
                                              onPressed: () {
                                                phoneTextFieldController
                                                    .clear();
                                                completeGoogleRegisterBloc
                                                    .eventController.sink
                                                    .add(InputPhoneGoogleAuthEvent(
                                                        phone:
                                                            phoneTextFieldController
                                                                .text));
                                              },
                                            ),
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white,
                                                        width: 1.0)),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black45,
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
                                                isFocusOnCitizenIdentification:
                                                    false,
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
                                    SizedBox(
                                      width: 300,
                                      child: TextFormField(
                                        controller: addressTextFieldController,
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
                                                  fontFamily: "SourceCodePro",
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.5),
                                            ),
                                            prefixIcon: const Icon(
                                              Icons.location_city,
                                              color: Colors.black45,
                                            ),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                color: snapshot
                                                    .data!.focusAddressColor,
                                              ),
                                              onPressed: () {
                                                addressTextFieldController
                                                    .clear();
                                                completeGoogleRegisterBloc
                                                    .eventController.sink
                                                    .add(InputAddressGoogleAuthEvent(
                                                        address:
                                                            addressTextFieldController
                                                                .text));
                                              },
                                            ),
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white,
                                                        width: 1.0)),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black45,
                                                        width: 1.0)),
                                            errorStyle: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.redAccent)),
                                        onTap: () => completeGoogleRegisterBloc
                                            .eventController.sink
                                            .add(FocusTextFieldCompleteGoogleRegEvent(
                                                isFocusOnAddress: true,
                                                isFocusOnBirthDay: false,
                                                isFocusOnCitizenIdentification:
                                                    false,
                                                isFocusOnPhone: false,
                                                isFocusOnUsername: false)),
                                        onChanged: (value) =>
                                            completeGoogleRegisterBloc
                                                .eventController.sink
                                                .add(
                                                    InputAddressGoogleAuthEvent(
                                                        address: value)),
                                        validator: (value) =>
                                            snapshot.data!.validateAddress(),
                                      ),
                                    ),
                                    isExceptionOccured == true
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                top: 25, bottom: 25),
                                            child: Text(
                                              message,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        : const SizedBox(
                                            height: 50,
                                          ),
                                    ElevatedButton(
                                        onPressed: () {
                                          if (formState.currentState!
                                              .validate()) {
                                            completeGoogleRegisterBloc
                                                .eventController.sink
                                                .add(
                                                    SubmitGoogleCompleteRegisterEvent(
                                                        address: snapshot
                                                            .data!.address,
                                                        idCardNumber: snapshot
                                                            .data!.idCardNumber,
                                                        dob: snapshot.data!.dob,
                                                        email: snapshot
                                                            .data!.email,
                                                        gender: snapshot
                                                            .data!.gender,
                                                        phone: snapshot
                                                            .data!.phone,
                                                        username: snapshot
                                                            .data!.username,
                                                        googleSignIn:
                                                            googleSignIn,
                                                        // googleSignInAccount:
                                                        //     googleSignInAccount,
                                                        context: context));
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blueAccent,
                                            minimumSize: const Size(300, 50),
                                            maximumSize: const Size(300, 50)),
                                        child: const Text(
                                          "Submit",
                                          style:
                                              TextStyle(fontFamily: "Lobster"),
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
                                                      googleSignIn:
                                                          googleSignIn,
                                                      isChangeGoogleAccount:
                                                          false));
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
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
