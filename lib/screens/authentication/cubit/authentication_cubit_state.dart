import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery/cubit/main_state.dart';

abstract class AuthCubitState extends MainCubitState {}

class InitialState extends AuthCubitState {
  @override
  List<Object?> get props => [];
}

class LoginLoadingState extends AuthCubitState {
  @override
  List<Object?> get props => [];
}

class LoginSuccessState extends AuthCubitState {
  final bool isSuccess;
  final UserCredential credential;
  LoginSuccessState({this.isSuccess = false, required this.credential});
  @override
  List<Object?> get props => [isSuccess, credential];
}

class OtpLoginSuccessState extends AuthCubitState {
  final bool isSuccess;
  final UserCredential credential;
  OtpLoginSuccessState({this.isSuccess = false, required this.credential});
  @override
  List<Object?> get props => [isSuccess, credential];
}

class LoginFailureState extends AuthCubitState {
  final bool isSuccess;
  final String response;
  LoginFailureState({this.isSuccess = false, this.response = ""});
  @override
  List<Object?> get props => [isSuccess, response];
}

class OTPSentSuccessState extends AuthCubitState {
  List<Object?> get props => [];
}

class OTPVerificationMainState extends AuthCubitState {
  final String message;
  OTPVerificationMainState({this.message = ""});
  List<Object?> get props => [message];
}
