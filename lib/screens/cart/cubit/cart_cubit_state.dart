import 'package:flutter/material.dart';
import '../../../cubit/main_state.dart';

@immutable
abstract class CartCubitState extends MainCubitState {}

class CartCubitInitial extends CartCubitState {
  @override
  List<Object?> get props => [];
}

class CartCubitLoadaingState extends CartCubitState {
  @override
  List<Object?> get props => [];
}

class CartCubitSuccessState extends CartCubitState {
  @override
  List<Object?> get props => [];
}

class CartCubitFailureState extends CartCubitState {
  String message;
  CartCubitFailureState({this.message = ""});
  @override
  List<Object?> get props => [];
}
