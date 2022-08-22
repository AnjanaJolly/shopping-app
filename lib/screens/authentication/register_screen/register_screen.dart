import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/screens/authentication/cubit/authentication_cubit.dart';
import 'package:food_delivery/utils/app_colors.dart';
import 'package:food_delivery/utils/app_loader.dart';
import 'package:food_delivery/widgets/app_widgets.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../home/cubit/home_screen_cubit.dart';
import '../../home/home_screen.dart';
import '../cubit/authentication_cubit_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String otpPin = "";
  String countryDial = "+91";
  late AuthenticationCubit cubit;
  int screenState = 0;
  AppLoader loader = AppLoader();
  Color green = AppColors.phone_green;
  Color border_color = AppColors.google_blue;

  @override
  void initState() {
    cubit = context.read<AuthenticationCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          setState(() {
            screenState = 0;
          });
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: AppColors.backgroundWhite,
          body: BlocListener<AuthenticationCubit, AuthCubitState>(
              bloc: BlocProvider.of<AuthenticationCubit>(context),
              listener: (context, state) {
                print(state);
                if (state is OtpLoginLoadingState) {
                  loader.show(context);
                }
                if (state is OTPSentSuccessState) {
                  loader.hide(context);
                  setState(() {
                    screenState = 1;
                  });
                }
                if (state is OTPVerificationMainState) {
                  loader.hide(context);
                  BotToast.showText(text: state.message);
                }
                if (state is OtpLoginFailureState) {
                  loader.hide(context);
                  BotToast.showText(text: state.response);
                }

                if (state is OtpLoginSuccessState) {
                  loader.hide(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider<HomeScreenCubit>(
                        create: (BuildContext context) => HomeScreenCubit(),
                        child: HomeScreen(
                            userId: state.credential.user!.uid,
                            username: state.credential.user!.phoneNumber!),
                      ),
                    ),
                  );
                }
              },
              child: body()),
        ));
  }

  Widget body() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 100, 20, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/firebase_logo.png',
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 4,
            ),
            const SizedBox(
              height: 100,
            ),
            screenState == 0 ? stateRegister() : stateOTP(),
            GestureDetector(
              onTap: () {
                if (screenState == 0) {
                  if (usernameController.text.isEmpty) {
                    BotToast.showText(text: "Username is still empty!");
                  } else if (phoneController.text.isEmpty) {
                    BotToast.showText(text: "Phone number is still empty!");
                  } else {
                    cubit.verifyPhone(countryDial + phoneController.text);
                  }
                } else {
                  if (otpPin.length >= 6) {
                    cubit.verifyOTP(
                      otpPin,
                    );
                  } else {
                    BotToast.showText(text: "Enter OTP correctly!");
                  }
                }
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                alignment: Alignment.center,
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: green,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: AppWidgets.text(
                    'Continue', FontWeight.w500, AppColors.backgroundWhite, 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget stateRegister() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              AppWidgets.text("User Name", FontWeight.w400, Colors.black, 16),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: usernameController,
          decoration: InputDecoration(
            focusColor: green,
            fillColor: green,
            hoverColor: green,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: border_color)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppWidgets.text(
              "Phone Number", FontWeight.w400, Colors.black, 16),
        ),
        IntlPhoneField(
          controller: phoneController,
          showCountryFlag: false,
          showDropdownIcon: false,
          initialValue: countryDial,
          onCountryChanged: (country) {
            setState(() {
              countryDial = "+${country.dialCode}";
            });
          },
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: border_color)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget stateOTP() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppWidgets.text(
            "We just sent a code to \n${countryDial + phoneController.text} \nEnter the code here and we can continue!",
            FontWeight.w500,
            Colors.black,
            16,
            align: TextAlign.center),
        const SizedBox(
          height: 20,
        ),
        PinCodeTextField(
          appContext: context,
          length: 6,
          onChanged: (value) {
            setState(() {
              otpPin = value;
            });
          },
          pinTheme: PinTheme(
            activeColor: green,
            selectedColor: green,
            inactiveColor: Colors.black26,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppWidgets.text(
                "Didn't receive the code? ", FontWeight.w400, Colors.black, 16),
            InkWell(
                onTap: () {
                  setState(() {
                    screenState = 0;
                  });
                },
                child: AppWidgets.text(
                    "Resend Code", FontWeight.w400, border_color, 16)),
          ],
        ),
      ],
    );
  }
}
