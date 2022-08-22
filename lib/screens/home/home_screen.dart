import 'package:badges/badges.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/screens/authentication/login_screen.dart';
import 'package:food_delivery/screens/cart/cubit/cart_cubit.dart';
import 'package:food_delivery/screens/cart/cubit/cart_cubit_state.dart';
import 'package:food_delivery/screens/home/cubit/home_screen_cubit.dart';
import 'package:food_delivery/screens/home/tab_screens/tab_screen.dart';
import 'package:food_delivery/utils/app_colors.dart';
import 'package:food_delivery/utils/app_loader.dart';
import 'package:food_delivery/widgets/app_widgets.dart';
import '../cart/cart_screen.dart';
import 'cubit/home_screen_state.dart';

class HomeScreen extends StatefulWidget {
  String username;
  String userId;
  HomeScreen({Key? key, this.userId = " ", this.username = ""})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  HomeScreenCubit cubit = HomeScreenCubit();
  AppLoader loader = AppLoader();

  @override
  void initState() {
    cubit = context.read<HomeScreenCubit>();
    cubit.getFoodMenu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeScreenCubit, HomeScreenState>(
        listener: ((context, state) {
          if (state is HomeScreenLoadingState) {
            loader.show(context);
          }
          if (state is SignOutLoadingState) {
            loader.show(context);
          }

          if (state is SignOutSuccessState) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          }
          if (state is SignOutFailureState) {
            BotToast.showText(text: state.errorMsg);
          }
          if (state is HomeScreenFailureState) {
            BotToast.showText(text: state.errorMsg);
          }
          loader.hide(context);
        }),
        bloc: BlocProvider.of<HomeScreenCubit>(context),
        child: BlocBuilder<HomeScreenCubit, HomeScreenState>(
            builder: (context, state) {
          if (state is HomeScreenSuccessState || state is SignOutFailureState) {
            return DefaultTabController(
              length: tabWidgets.length,
              child: Scaffold(
                  backgroundColor: AppColors.backgroundWhite,
                  appBar: appBar,
                  drawer: _drawer(),
                  body: body()),
            );
          }
          if (state is HomeScreenLoadingState) {
            return emptyView();
          }
          loader.hide(context);
          return Scaffold(
            body: Container(),
          );
        }));
  }

  AppBar get appBar => AppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0,
      bottom: TabBar(
        isScrollable: true,
        tabs: tabWidgets,
        labelColor: AppColors.selected_tab_color,
        indicatorColor: AppColors.selected_tab_color,
        unselectedLabelColor: AppColors.unselected_tab_color,
      ),
      // ,
      actions: [
        BlocBuilder<CartCubit, CartCubitState>(builder: (context, state) {
          CartCubit _cubit = context.read<CartCubit>();
          return Badge(
            badgeContent: Text(
              _cubit.cart.length.toString(),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            position: const BadgePosition(start: 30, bottom: 30),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CartScreen()));
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          );
        }),
        const SizedBox(
          width: 20.0,
        ),
      ],
      backgroundColor: AppColors.backgroundWhite);

  Widget body() {
    return TabBarView(
      children: [
        TabScreen(dishes: cubit.menu[0].categoryDishes!),
        TabScreen(dishes: cubit.menu[1].categoryDishes!),
        TabScreen(dishes: cubit.menu[2].categoryDishes!),
        TabScreen(dishes: cubit.menu[3].categoryDishes!),
        TabScreen(dishes: cubit.menu[4].categoryDishes!),
        TabScreen(dishes: cubit.menu[5].categoryDishes!),
      ],
    );
  }

  Widget emptyView() {
    return const Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Center(
        child: CircularProgressIndicator(strokeWidth: 1),
      ),
    );
  }

  List<Widget> get tabWidgets {
    List<Widget> tabs = [];
    List tabNames = cubit.dishCategory;
    tabNames.forEach((element) {
      tabs.add(
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: Tab(
            icon: Text(
              element,
            ),
          ),
        ),
      );
    });
    return tabs;
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
                color: Color.fromARGB(207, 65, 196, 70),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )),
            child: Column(children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.backgroundWhite,
                child: Image.asset(
                  'assets/images/firebase_logo.png',
                  height: 50,
                  width: 50,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              AppWidgets.text(
                  widget.username, FontWeight.w500, Colors.black, 18),
              const SizedBox(
                height: 10,
              ),
              AppWidgets.text(
                  'ID : ${widget.userId}', FontWeight.w500, Colors.black, 16),
            ]),
          ),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              cubit.signOut();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(
                    width: 20,
                  ),
                  AppWidgets.text('Log Out', FontWeight.w500, Colors.black, 18)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
