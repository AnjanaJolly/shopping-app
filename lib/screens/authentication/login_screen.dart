import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/screens/authentication/cubit/authentication_cubit.dart';
import 'package:food_delivery/screens/authentication/register_screen/register_screen.dart';
import 'package:food_delivery/screens/home/cubit/home_screen_cubit.dart';
import 'package:food_delivery/screens/home/home_screen.dart';
import 'package:food_delivery/utils/app_colors.dart';
import 'package:food_delivery/utils/app_loader.dart';
import 'package:food_delivery/widgets/app_widgets.dart';
import 'cubit/authentication_cubit_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AppLoader loader = AppLoader();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        body: BlocListener<AuthenticationCubit, AuthCubitState>(
          bloc: BlocProvider.of<AuthenticationCubit>(context),
          listener: (context, state) {
            if (state is LoginLoadingState) {
              loader.show(context);
            } else if (state is LoginSuccessState) {
              loader.hide(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider<HomeScreenCubit>(
                    create: (BuildContext context) => HomeScreenCubit(),
                    child: HomeScreen(
                      username: state.credential.user!.displayName!,
                      userId: state.credential.user!.uid,
                    ),
                  ),
                ),
              );
            } else if (state is LoginFailureState) {
              loader.hide(context);
              showMessage(state.response);
            }
            setState(() {
              loader.hide(context);
            });
          },
          child: body(),
        ));
  }

  Widget body() {
    return Container(
      padding: const EdgeInsets.only(bottom: 50, left: 50, right: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(
            'assets/images/firebase_logo.png',
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 4,
          ),
          const SizedBox(
            height: 200,
          ),
          googleButton,
          const SizedBox(
            height: 20,
          ),
          phoneButton
        ],
      ),
    );
  }

  Widget get googleButton => AppWidgets.elevatedIconButton(
      onPressed: () {
        context.read<AuthenticationCubit>().signInWithGoogle();
      },
      buttonName: 'Google',
      width: double.infinity,
      height: 50,
      color: AppColors.google_blue,
      path: 'assets/images/google.png',
      loader: false);

  Widget get phoneButton => AppWidgets.elevatedIconButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterScreen(),
            ));
      },
      buttonName: 'Phone',
      width: double.infinity,
      height: 50,
      color: AppColors.phone_green,
      path: 'assets/images/phone_logo.png',
      loader: false);

  void showMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
