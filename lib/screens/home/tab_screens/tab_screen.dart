import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/data/database/dBHelper.dart';
import 'package:food_delivery/data/models/get_menu_api_response.dart';
import 'package:food_delivery/screens/cart/cubit/cart_cubit.dart';
import 'package:food_delivery/screens/cart/cubit/cart_cubit_state.dart';
import 'package:food_delivery/utils/app_colors.dart';
import 'package:food_delivery/utils/app_loader.dart';
import 'package:food_delivery/widgets/app_widgets.dart';

class TabScreen extends StatefulWidget {
  List<Dish> dishes;
  TabScreen({Key? key, required this.dishes}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  late CartCubit _cubit;
  DBHelper dbHelper = DBHelper();
  List<Dish> dishes = [];
  AppLoader loader = AppLoader();
  @override
  void initState() {
    _cubit = context.read<CartCubit>();
    _cubit.getData();
    dishes = widget.dishes;
    print(_cubit.cart);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartCubit, CartCubitState>(
      listener: (context, state) {
        if (state is CartCubitLoadaingState) {
          loader.show(context);
        }
        if (state is CartCubitSuccessState) {
          loader.hide(context);
          _cubit.getTotalPrice();
          print(_cubit.cart);
        }
        if (state is CartCubitFailureState) {
          loader.hide(context);
          BotToast.showText(text: state.message);
        }
      },
      child: BlocBuilder<CartCubit, CartCubitState>(
        builder: (context, state) {
          return Container(
            color: AppColors.backgroundWhite,
            child: ListView.builder(
                itemCount: widget.dishes.length,
                itemBuilder: ((context, index) {
                  var item = widget.dishes[index];
                  var quantity = _cubit.getItemQuantity(item);
                  return menuItem(item, quantity);
                })),
          );
        },
      ),
    );
  }

  Widget menuItem(Dish item, quantity) {
    return Container(
      padding: EdgeInsets.only(left: 20, bottom: 20, top: 10, right: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        border:
            Border.all(color: Color.fromARGB(255, 183, 180, 180), width: .5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppWidgets.text(
                    item.dishName!,
                    FontWeight.w500,
                    Colors.black,
                    18,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppWidgets.text(
                        'INR ${item.dishPrice!.toStringAsFixed(2)}',
                        FontWeight.w400,
                        Colors.black,
                        16,
                      ),
                      AppWidgets.text(
                        '${item.dishCalories} Calories',
                        FontWeight.w400,
                        Colors.black,
                        16,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    child: AppWidgets.text(
                      item.dishDescription!,
                      FontWeight.w400,
                      AppColors.unselected_tab_color,
                      16,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AppWidgets.plusMinusButton(
                      quantity <= 0
                          ? () {}
                          : () {
                              _cubit.upDateCart(item, removeItem: true);
                            }, () {
                    _cubit.upDateCart(item);
                  }, quantity.toString(), AppColors.phone_green),
                  const SizedBox(
                    height: 10,
                  ),
                  item.addOnCategory!.isEmpty
                      ? SizedBox()
                      : AppWidgets.text('Customisations Availabe',
                          FontWeight.w400, Color.fromARGB(255, 188, 43, 33), 16)
                ]),
          ),
          const SizedBox(
            width: 10,
          ),
          CachedNetworkImage(
            height: 100,
            width: 80,
            imageUrl: item.dishImage!,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    colorFilter:
                        ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
              ),
            ),
            placeholder: (context, url) =>
                Image.asset('assets/images/placeholder.png'),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ],
      ),
    );
  }
}
