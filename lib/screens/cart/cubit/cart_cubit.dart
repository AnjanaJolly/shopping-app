import 'package:flutter/material.dart';
import '../../../cubit/main_cubit.dart';
import '../../../data/database/dBHelper.dart';
import '../../../data/models/cart.dart';
import '../../../data/models/get_menu_api_response.dart';
import 'cart_cubit_state.dart';

class CartCubit extends MainCubit<CartCubitState> {
  CartCubit([
    CartCubitState? initialState,
  ]) : super(
          initialState ?? CartCubitInitial(),
        );

  DBHelper dbHelper = DBHelper();

  double totalPrice = 0.0;
  int totalQuantity = 0;
  List<Cart> cart = [];

  Future<List<Cart>> getData() async {
    emit(CartCubitLoadaingState());
    try {
      cart = await dbHelper.getCartList();
      emit(CartCubitSuccessState());
    } catch (e) {
      emit(CartCubitFailureState());
    }

    return cart;
  }

  void upDateCart(Dish dish, {bool removeItem = false}) {
    if (dish.quantity! <= 0) {
      addToCart(dish);
    }
    var val = cart.indexWhere((element) => element.id == dish.dishId);
    if (removeItem) {
      removeQuantity(dish.dishId!);
      getItemQuantity(dish);
    } else {
      if (val < 0) {
        addToCart(dish);
      } else {
        addQuantity(dish.dishId!);
      }
    }
    getTotalPrice();
  }

  int getItemQuantity(Dish dish) {
    var val = cart.indexWhere((element) => element.id == dish.dishId);
    print(val);
    print(dish.quantity);
    if (val < 0) {
      dish.quantity = 0;
    } else {
      dish.quantity = cart[val].quantity;
    }
    return dish.quantity!;
  }

  double getTotalPrice() {
    double dishTotal = 0;
    totalQuantity = 0;
    totalPrice = 0;
    for (var i in cart) {
      dishTotal = i.quantity! * i.productPrice!;
      totalQuantity = totalQuantity + i.quantity!;
      totalPrice = totalPrice + dishTotal;
    }
    return totalPrice;
  }

  void addToCart(Dish dish) {
    Cart cart = Cart(
      id: dish.dishId,
      productId: dish.dishId,
      productName: dish.dishName,
      initialPrice: dish.dishPrice,
      productPrice: dish.dishPrice,
      quantity: 1,
      calories: dish.dishCalories,
      image: dish.dishImage,
    );
    print(cart);
    getItemQuantity(dish);
    dbHelper.insert(cart);
    getData();
  }

  Future placeOrder() async {
    emit(CartCubitLoadaingState());
    cart = [];
    dbHelper.clearTable();
    totalQuantity = 0;
    emit(CartCubitSuccessState());
  }

  void addQuantity(String id) {
    emit(CartCubitLoadaingState());
    final index = cart.indexWhere((element) => element.id == id);
    print(cart[index].quantity!);
    cart[index].quantity = cart[index].quantity! + 1;
    print(cart[index].quantity!);
    dbHelper.updateQuantity(cart[index]);
    emit(CartCubitSuccessState());
  }

  void removeQuantity(String id) {
    emit(CartCubitLoadaingState());
    final index = cart.indexWhere((element) => element.id == id);
    final currentQuantity = cart[index].quantity!;
    if (currentQuantity <= 1) {
      removeItem(id);
    } else {
      cart[index].quantity = currentQuantity - 1;
      print(currentQuantity);
    }
    if (cart.isEmpty) {
      placeOrder();
      cart = [];
    }
    dbHelper.updateQuantity(cart[index]);
    emit(CartCubitSuccessState());
  }

  void removeItem(String id) {
    emit(CartCubitLoadaingState());
    final index = cart.indexWhere((element) => element.id == id);
    cart.removeAt(index);

    emit(CartCubitSuccessState());
  }
}
