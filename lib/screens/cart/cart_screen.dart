import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/data/database/dBHelper.dart';
import 'package:food_delivery/screens/cart/cubit/cart_cubit.dart';
import 'package:food_delivery/utils/app_colors.dart';
import 'package:food_delivery/utils/app_loader.dart';
import 'package:food_delivery/widgets/app_widgets.dart';

import '../../data/models/cart.dart';
import 'cubit/cart_cubit_state.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartCubit cubit;
  AppLoader loader = AppLoader();
  DBHelper dbHelper = DBHelper();
  final ValueNotifier<double?> totalPrice = ValueNotifier(null);

  @override
  void initState() {
    cubit = context.read<CartCubit>();
    cubit.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: AppColors.backgroundWhite,
          centerTitle: true,
          title: AppWidgets.text(
            'Order Summary',
            FontWeight.w400,
            Colors.black,
            19,
          ),
        ),
        body: SingleChildScrollView(
          child: BlocListener<CartCubit, CartCubitState>(
            listener: (context, state) {
              if (state is CartCubitLoadaingState) {
                loader.show(context);
              }
              if (state is CartCubitSuccessState) {
                loader.hide(context);
              }
              if (state is CartCubitFailureState) {
                loader.hide(context);
                BotToast.showText(text: state.message);
              }
            },
            child: BlocBuilder<CartCubit, CartCubitState>(
                builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.only(
                        top: 5, left: 5, right: 5, bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color.fromARGB(255, 187, 179, 179),
                      ),
                    ),
                    child: Column(children: [
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.order_green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: AppWidgets.text(
                            '${cubit.cart.length} Dishes - ${cubit.totalQuantity} Items',
                            FontWeight.w500,
                            AppColors.backgroundWhite,
                            18),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: ((context, index) {
                          var item = cubit.cart[index];

                          return Column(
                            children: [menuItem(item, index), seperator],
                          );
                        }),
                        itemCount: cubit.cart.length,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppWidgets.text('Total Amount', FontWeight.w600,
                              Colors.black, 18),
                          AppWidgets.text(
                              'INR ${cubit.totalPrice.toStringAsFixed(2)}',
                              FontWeight.w600,
                              Colors.black,
                              18),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ]),
                  ),
                  InkWell(
                    onTap: cubit.cart.isEmpty
                        ? () {
                            BotToast.showText(text: 'Cart is Empty !! ');
                          }
                        : () {
                            BotToast.showText(
                                text: 'Order Successfully Placed');
                            cubit.placeOrder().then((value) {
                              Navigator.of(context).pop();
                            });
                          },
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.order_green,
                      ),
                      alignment: Alignment.center,
                      child: AppWidgets.text('Place Order', FontWeight.w500,
                          AppColors.backgroundWhite, 20),
                    ),
                  )
                ],
              );
            }),
          ),
        ));
  }
  /* */

  Widget incrementDecrementButton(Cart item, index) {
    return Container(
      height: 40,
      width: 120,
      decoration: BoxDecoration(
          color: AppColors.order_green,
          borderRadius: BorderRadius.circular(30)),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.remove,
                color: AppColors.backgroundWhite,
              ),
              onPressed: () {
                cubit.removeQuantity(cubit.cart[index].id!);
              },
            ),
            Text(
              item.quantity.toString(),
              style: const TextStyle(
                  color: AppColors.backgroundWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.add,
                  color: AppColors.backgroundWhite,
                ),
                onPressed: () {
                  cubit.addQuantity(cubit.cart[index].id!);
                })
          ]),
    );
  }

  Widget menuItem(Cart cart, int index) {
    return Container(
      padding: EdgeInsets.only(left: 10, bottom: 10, top: 20, right: 10),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    child: AppWidgets.text(
                      cart.productName!,
                      FontWeight.w500,
                      Colors.black,
                      18,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AppWidgets.text(
                    "INR ${cart.initialPrice!.toStringAsFixed(2)}",
                    FontWeight.w500,
                    Colors.black,
                    16,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AppWidgets.text(
                    '${cart.calories} Calories',
                    FontWeight.w500,
                    Colors.black,
                    16,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ]),
          ),
          incrementDecrementButton(cart, index),
          const SizedBox(
            width: 10,
          ),
          AppWidgets.text(
            "INR ${(cart.productPrice! * cart.quantity!).toStringAsFixed(2)}",
            FontWeight.w400,
            Colors.black,
            16,
          ),
        ],
      ),
    );
  }

  Widget get seperator => Container(
        width: double.infinity,
        height: .5,
        color: Color.fromARGB(255, 149, 144, 144),
      );
}
