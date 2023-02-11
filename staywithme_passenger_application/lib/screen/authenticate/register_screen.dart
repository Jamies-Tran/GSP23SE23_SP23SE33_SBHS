import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:staywithme_passenger_application/bloc/event/reg_event.dart';
import 'package:staywithme_passenger_application/bloc/reg_bloc.dart';
import 'package:staywithme_passenger_application/bloc/state/reg_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const registerAccountRoute = "/register_account";

  @override
  State<RegisterScreen> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  final formState = GlobalKey<FormState>();
  final registerBloc = RegisterBloc();
  final dateFormat = DateFormat("yyyy-MM-dd");

  final dobTextFieldController = TextEditingController();
  final usernameTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final idCardTextEditingController = TextEditingController();

  @override
  void dispose() {
    registerBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dynamic contextArguments =
        ModalRoute.of(context)!.settings.arguments as Map?;
    dynamic isExcOccured = contextArguments != null
        ? contextArguments["isExceptionOccured"]
        : false;
    dynamic message =
        contextArguments != null && contextArguments["message"] != null
            ? contextArguments["message"]
            : null;

    return GestureDetector(
      onTap: () {
        registerBloc.eventController.sink.add(FocusTextFieldRegisterEvent(
            isFocusOnUsername: false,
            isFocusOnPassword: false,
            isFocusOnAddress: false,
            isFocusOnPhone: false,
            isFocusOnCitizenIdentification: false,
            isFocusOnBirthday: false));
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.white, Colors.orange])),
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            bottom: true,
            child: SingleChildScrollView(
              child: StreamBuilder<RegisterState>(
                stream: registerBloc.stateController.stream,
                initialData: registerBloc.initData,
                builder: (context, snapshot) {
                  return Column(children: [
                    Form(
                        key: formState,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 20, bottom: 20, left: 10, right: 10),
                              child: Column(children: [
                                const Text(
                                  "Register",
                                  style: TextStyle(
                                      fontFamily: "Lobster",
                                      fontSize: 50,
                                      color: Colors.black),
                                ),
                                isExcOccured == true
                                    ? Container(
                                        margin: const EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: Center(
                                            child: Text(
                                          message,
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      )
                                    : const SizedBox(
                                        height: 20,
                                      ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                        controller:
                                            usernameTextEditingController,
                                        style: const TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          label: const Text(
                                            "Username",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.account_box,
                                            color: Colors.black,
                                          ),
                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                if (snapshot.data!
                                                        .focusUsernameColor ==
                                                    Colors.black45) {
                                                  usernameTextEditingController
                                                      .clear();
                                                  registerBloc
                                                      .eventController.sink
                                                      .add(InputUsernameEvent(
                                                          username:
                                                              usernameTextEditingController
                                                                  .text));
                                                }
                                              },
                                              icon: Icon(
                                                Icons.close,
                                                color: snapshot
                                                    .data!.focusUsernameColor,
                                              )),
                                          enabledBorder:
                                              const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 2.5)),
                                          focusedBorder:
                                              const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white,
                                                      width: 3.0)),
                                          errorStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.redAccent),
                                        ),
                                        onTap: () => registerBloc
                                            .eventController.sink
                                            .add(FocusTextFieldRegisterEvent(
                                                isFocusOnUsername: true,
                                                isFocusOnAddress: false,
                                                isFocusOnBirthday: false,
                                                isFocusOnCitizenIdentification:
                                                    false,
                                                isFocusOnPassword: false,
                                                isFocusOnPhone: false)),
                                        onChanged: (value) => registerBloc
                                            .eventController.sink
                                            .add(InputUsernameEvent(
                                                username: value)),
                                        validator: (value) =>
                                            snapshot.data!.validateUsername(),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                        controller:
                                            passwordTextEditingController,
                                        style: const TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          label: const Text(
                                            "Password",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.lock,
                                            color: Colors.black,
                                          ),
                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                if (snapshot.data!
                                                        .focusPasswordColor ==
                                                    Colors.black45) {
                                                  passwordTextEditingController
                                                      .clear();
                                                  registerBloc
                                                      .eventController.sink
                                                      .add(InputPasswordEvent(
                                                          password:
                                                              passwordTextEditingController
                                                                  .text));
                                                }
                                              },
                                              icon: Icon(
                                                Icons.close,
                                                color: snapshot
                                                    .data!.focusPasswordColor,
                                              )),
                                          enabledBorder:
                                              const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 2.5)),
                                          focusedBorder:
                                              const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white,
                                                      width: 3.0)),
                                          errorStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.redAccent),
                                        ),
                                        onTap: () => registerBloc
                                            .eventController.sink
                                            .add(FocusTextFieldRegisterEvent(
                                                isFocusOnPassword: true,
                                                isFocusOnAddress: false,
                                                isFocusOnBirthday: false,
                                                isFocusOnCitizenIdentification:
                                                    false,
                                                isFocusOnPhone: false,
                                                isFocusOnUsername: false)),
                                        onChanged: (value) => registerBloc
                                            .eventController.sink
                                            .add(InputPasswordEvent(
                                                password: value)),
                                        validator: (value) =>
                                            snapshot.data!.validatePassword(),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: emailTextEditingController,
                                  style: const TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    label: const Text(
                                      "Email",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.mail,
                                      color: Colors.black,
                                    ),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          if (snapshot.data!.focusEmailColor ==
                                              Colors.black45) {
                                            emailTextEditingController.clear();
                                            registerBloc.eventController.sink
                                                .add(InputEmailEvent(
                                                    email:
                                                        emailTextEditingController
                                                            .text));
                                          }
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          color: snapshot.data!.focusEmailColor,
                                        )),
                                    enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 2.5)),
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 3.0)),
                                    errorStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent),
                                  ),
                                  onTap: () => registerBloc.eventController.sink
                                      .add(FocusTextFieldRegisterEvent(
                                          isFocusOnEmail: true,
                                          isFocusOnAddress: false,
                                          isFocusOnBirthday: false,
                                          isFocusOnCitizenIdentification: false,
                                          isFocusOnPassword: false,
                                          isFocusOnPhone: false,
                                          isFocusOnUsername: false)),
                                  onChanged: (value) => registerBloc
                                      .eventController.sink
                                      .add(InputEmailEvent(email: value)),
                                  validator: (value) =>
                                      snapshot.data!.validateEmail(),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: addressTextEditingController,
                                  style: const TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    label: const Text(
                                      "Address",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.location_city,
                                      color: Colors.black,
                                    ),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          if (snapshot
                                                  .data!.focusAddressColor ==
                                              Colors.black45) {
                                            addressTextEditingController
                                                .clear();
                                            registerBloc.eventController.sink
                                                .add(InputAddressEvent(
                                                    address:
                                                        addressTextEditingController
                                                            .text));
                                          }
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          color:
                                              snapshot.data!.focusAddressColor,
                                        )),
                                    enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 2.5)),
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 3.0)),
                                    errorStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent),
                                  ),
                                  onTap: () => registerBloc.eventController.sink
                                      .add(FocusTextFieldRegisterEvent(
                                          isFocusOnAddress: true,
                                          isFocusOnBirthday: false,
                                          isFocusOnCitizenIdentification: false,
                                          isFocusOnEmail: false,
                                          isFocusOnPassword: false,
                                          isFocusOnPhone: false,
                                          isFocusOnUsername: false)),
                                  onChanged: (value) => registerBloc
                                      .eventController.sink
                                      .add(InputAddressEvent(address: value)),
                                  validator: (value) =>
                                      snapshot.data!.validateAddress(),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                        controller: phoneTextEditingController,
                                        keyboardType: TextInputType.phone,
                                        style: const TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          label: const Text(
                                            "Phone",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.phone,
                                            color: Colors.black,
                                          ),
                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                if (snapshot.data!
                                                        .focusPhoneColor ==
                                                    Colors.black45) {
                                                  phoneTextEditingController
                                                      .clear();
                                                  registerBloc
                                                      .eventController.sink
                                                      .add(InputPhoneEvent(
                                                          phone:
                                                              phoneTextEditingController
                                                                  .text));
                                                }
                                              },
                                              icon: Icon(
                                                Icons.close,
                                                color: snapshot
                                                    .data!.focusPhoneColor,
                                              )),
                                          enabledBorder:
                                              const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 2.5)),
                                          focusedBorder:
                                              const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white,
                                                      width: 3.0)),
                                          errorStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.redAccent),
                                        ),
                                        onTap: () => registerBloc
                                            .eventController.sink
                                            .add(FocusTextFieldRegisterEvent(
                                          isFocusOnPhone: true,
                                          isFocusOnAddress: false,
                                          isFocusOnBirthday: false,
                                          isFocusOnCitizenIdentification: false,
                                          isFocusOnEmail: false,
                                          isFocusOnPassword: false,
                                          isFocusOnUsername: false,
                                        )),
                                        onChanged: (value) => registerBloc
                                            .eventController.sink
                                            .add(InputPhoneEvent(phone: value)),
                                        validator: (value) =>
                                            snapshot.data!.validatePhone(),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                        controller: idCardTextEditingController,
                                        keyboardType: TextInputType.number,
                                        style: const TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          label: const Text(
                                            "ID Card",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.card_membership,
                                            color: Colors.black,
                                          ),
                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                if (snapshot.data!
                                                        .focusCitizenIdentificationColor ==
                                                    Colors.black45) {
                                                  idCardTextEditingController
                                                      .clear();
                                                  registerBloc
                                                      .eventController.sink
                                                      .add(InputidCardNumberEvent(
                                                          idCardNumber:
                                                              idCardTextEditingController
                                                                  .text));
                                                }
                                              },
                                              icon: Icon(
                                                Icons.close,
                                                color: snapshot.data!
                                                    .focusCitizenIdentificationColor,
                                              )),
                                          enabledBorder:
                                              const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 2.5)),
                                          focusedBorder:
                                              const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white,
                                                      width: 3.0)),
                                          errorStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.redAccent),
                                        ),
                                        onTap: () => registerBloc
                                            .eventController.sink
                                            .add(FocusTextFieldRegisterEvent(
                                                isFocusOnCitizenIdentification:
                                                    true,
                                                isFocusOnAddress: false,
                                                isFocusOnBirthday: false,
                                                isFocusOnEmail: false,
                                                isFocusOnPassword: false,
                                                isFocusOnPhone: false,
                                                isFocusOnUsername: false)),
                                        onChanged: (value) => registerBloc
                                            .eventController.sink
                                            .add(InputidCardNumberEvent(
                                                idCardNumber: value)),
                                        validator: (value) => snapshot.data!
                                            .validateCitizenIdentification(),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                          height: 59,
                                          child: InputDecorator(
                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                prefixIcon:
                                                    snapshot.data!.gender ==
                                                            "Male"
                                                        ? const Icon(
                                                            Icons.boy,
                                                            color: Colors.black,
                                                          )
                                                        : const Icon(
                                                            Icons.girl,
                                                            color: Colors.black,
                                                          ),
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.white24,
                                                            width: 2.5)),
                                                focusedBorder:
                                                    const UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.white,
                                                            width: 3.0)),
                                                errorStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.redAccent)),
                                            child: DropdownButton<String>(
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                              dropdownColor: Colors.blueAccent,
                                              items: registerBloc
                                                  .genderSelection
                                                  .map((e) => DropdownMenuItem(
                                                        value: e,
                                                        child: Text(
                                                          e,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black45),
                                                        ),
                                                      ))
                                                  .toList(),
                                              value: snapshot.data!.gender,
                                              underline: const SizedBox(),
                                              onChanged: (value) {
                                                registerBloc
                                                    .eventController.sink
                                                    .add(ChooseGenderEvent(
                                                        gender: value));
                                              },
                                            ),
                                          ),
                                        )),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: dobTextFieldController,
                                        style: const TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          label: const Text(
                                            "Birth day",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.calendar_month,
                                            color: Colors.black,
                                          ),
                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                if (snapshot.data!
                                                        .focusBirthdayColor ==
                                                    Colors.black45) {
                                                  dobTextFieldController
                                                      .clear();
                                                  registerBloc
                                                      .eventController.sink
                                                      .add(InputDobEvent(
                                                          dob:
                                                              dobTextFieldController
                                                                  .text));
                                                }
                                              },
                                              icon: Icon(
                                                Icons.close,
                                                color: snapshot
                                                    .data!.focusBirthdayColor,
                                              )),
                                          enabledBorder:
                                              const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 2.5)),
                                          focusedBorder:
                                              const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white,
                                                      width: 3.0)),
                                          errorStyle: const TextStyle(
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
                                            registerBloc.eventController.sink
                                                .add(InputDobEvent(
                                                    dob: dobTextFieldController
                                                        .text));
                                            registerBloc.eventController.sink
                                                .add(FocusTextFieldRegisterEvent(
                                                    isFocusOnBirthday: true,
                                                    isFocusOnAddress: false,
                                                    isFocusOnCitizenIdentification:
                                                        false,
                                                    isFocusOnEmail: false,
                                                    isFocusOnPassword: false,
                                                    isFocusOnPhone: false,
                                                    isFocusOnUsername: false));
                                          });
                                        },
                                        validator: (value) =>
                                            snapshot.data!.validateDob(),
                                      ),
                                    )
                                  ],
                                ),
                              ]),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  if (formState.currentState!.validate()) {
                                    registerBloc.eventController.sink.add(
                                        SubmitRegisterAccountEvent(
                                            address: snapshot.data!.address,
                                            avatarUrl: snapshot.data!.avatarUrl,
                                            idCardNumber:
                                                snapshot.data!.idCardNumber,
                                            dob: snapshot.data!.dob,
                                            email: snapshot.data!.email,
                                            gender: snapshot.data!.gender,
                                            password: snapshot.data!.password,
                                            phone: snapshot.data!.phone,
                                            username: snapshot.data!.username,
                                            context: context));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepOrangeAccent,
                                    minimumSize: const Size(300, 50),
                                    maximumSize: const Size(300, 50)),
                                child: const Text(
                                  "Register",
                                  style: TextStyle(fontFamily: "Lobster"),
                                )),
                            const SizedBox(
                              height: 25,
                            ),
                            const Center(
                              child: Text(
                                "Or sign up with",
                                style: TextStyle(
                                    fontFamily: "SourceCodePro",
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  registerBloc.eventController.sink.add(
                                      ChooseGoogleAccountEvent(
                                          context: context));
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    minimumSize: const Size(300, 50),
                                    maximumSize: const Size(300, 50)),
                                child: const Text(
                                  "Google Account",
                                  style: TextStyle(fontFamily: "Lobster"),
                                )),
                            const SizedBox(
                              height: 30,
                            ),
                            TextButton(
                                onPressed: () {
                                  registerBloc.eventController.sink.add(
                                      NaviageToLoginScreenEvent(
                                          context: context));
                                },
                                child: const Text(
                                  "Already had an account? Login",
                                  style: TextStyle(
                                    backgroundColor: Colors.white,
                                    color: Colors.deepOrange,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ))
                          ],
                        )),
                  ]);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
