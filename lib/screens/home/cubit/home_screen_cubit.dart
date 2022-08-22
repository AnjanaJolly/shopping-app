import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery/cubit/main_cubit.dart';
import 'package:food_delivery/data/models/api_response.dart';
import 'package:food_delivery/data/models/get_menu_api_response.dart';
import 'package:food_delivery/screens/home/cubit/home_screen_state.dart';
import 'package:food_delivery/screens/home/home_repo.dart';

class HomeScreenCubit extends MainCubit<HomeScreenState> {
  HomeScreenCubit([
    HomeScreenState? initialState,
  ]) : super(
          initialState ?? HomeScreenInitial(),
        );
  final HomeScreenRepo _repo = HomeScreenRepo();

  List dishCategory = [];
  List<MenuCategory> menu = [];

  List getDishCategories(List<MenuCategory>? list) {
    list!.forEach((element) {
      if (element.menuCategory != null) dishCategory.add(element.menuCategory);
    });
    return dishCategory;
  }

  Future getFoodMenu() async {
    emit(HomeScreenLoadingState());
    ApiResponse response = await _repo.getFoodMenu();

    if (response.isSuccessful &&
        response.rawResponse!.isNotEmpty &&
        response != null) {
      MenuApiResponse menuApiResponse =
          MenuApiResponse.fromMap(response.rawResponse[0]);
      menu = menuApiResponse.tableMenuList!;
      getDishCategories(menu);
      emit(HomeScreenSuccessState());
    }
  }

  Future signOut() async {
    emit(SignOutLoadingState());
    try {
      await FirebaseAuth.instance.signOut();
      emit(SignOutSuccessState());
    } on FirebaseException catch (e) {
      emit(SignOutFailureState(errorMsg: e.message!));
    }
    return;
  }
}
