import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/screens/authentication/cubit/authentication_cubit.dart';
import 'package:food_delivery/screens/authentication/login_screen.dart';
import 'package:food_delivery/screens/cart/cubit/cart_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiBlocProvider(providers: [
    BlocProvider<AuthenticationCubit>(
      create: (BuildContext context) => AuthenticationCubit(),
    ),
    BlocProvider<CartCubit>(create: (BuildContext context) => CartCubit()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(BlocProvider.of<AuthenticationCubit>(context).state);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: LoginScreen(),
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
    );
  }
}
