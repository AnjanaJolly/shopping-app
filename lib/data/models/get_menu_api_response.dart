import 'dart:convert';

class MenuApiResponse {
  String? restaurantId;
  String? restaurantImage;

  String? restaurantName;
  String? tableId;
  String? tableName;
  String? branchName;
  String? nexturl;
  List<MenuCategory>? tableMenuList;

  MenuApiResponse(
      {required this.branchName,
      required this.nexturl,
      required this.restaurantName,
      required this.restaurantId,
      required this.restaurantImage,
      required this.tableId,
      required this.tableMenuList,
      required this.tableName});

  factory MenuApiResponse.fromJson(String str) =>
      MenuApiResponse.fromJson(json.decode(str));

  factory MenuApiResponse.fromMap(Map<String, dynamic> json) => MenuApiResponse(
        restaurantName: json["restaurant_name"] ?? null,
        branchName: json["branch_name"] ?? null,
        nexturl: json["nexturl"] ?? null,
        restaurantId: json["restaurant_id"] ?? null,
        restaurantImage: json["restaurant_image"] ?? null,
        tableId: json["table_id"] ?? null,
        tableMenuList: json["table_menu_list"] == null
            ? null
            : List<MenuCategory>.from(
                json["table_menu_list"].map((x) => MenuCategory.fromMap(x))),
        tableName: json["table_name"] ?? null,
      );
}

class MenuCategory {
  String? menuCategory;
  String? menuCategoryId;
  String? menuCategoryImage;
  String? nexturl;
  List<Dish>? categoryDishes;

  MenuCategory(
      {required this.categoryDishes,
      required this.menuCategory,
      required this.menuCategoryId,
      required this.menuCategoryImage,
      required this.nexturl});

  factory MenuCategory.fromJson(String str) =>
      MenuCategory.fromMap(json.decode(str));

  factory MenuCategory.fromMap(Map<String, dynamic> json) => MenuCategory(
        categoryDishes: json["category_dishes"] == null
            ? null
            : List<Dish>.from(
                json["category_dishes"].map((x) => Dish.fromMap(x))),
        menuCategory: json["menu_category"] ?? null,
        menuCategoryId: json["menu_category_id"] ?? null,
        menuCategoryImage: json["menu_category_image"] ?? null,
        nexturl: json["nexturl"] ?? null,
      );
}

class Dish {
  String? dishId;
  String? dishName;
  double? dishPrice;
  String? dishImage;
  String? dishCurrency;
  double? dishCalories;
  String? dishDescription;
  bool? dishAvailability;
  int? dishType;
  String? nexturl;
  List<AddOnCategory>? addOnCategory;
  int? quantity;

  Dish({
    required this.addOnCategory,
    required this.dishAvailability,
    required this.dishCalories,
    required this.dishCurrency,
    required this.dishDescription,
    required this.dishId,
    required this.dishImage,
    required this.dishName,
    required this.dishPrice,
    required this.dishType,
    required this.nexturl,
    this.quantity = 0,
  });

  factory Dish.fromJson(String str) => Dish.fromMap(json.decode(str));

  factory Dish.fromMap(Map<String, dynamic> json) => Dish(
      addOnCategory: json["addonCat"] == null
          ? null
          : List<AddOnCategory>.from(
              json["addonCat"].map((x) => AddOnCategory.fromMap(x))),
      dishAvailability: json["dish_Availability"] ?? null,
      dishCalories: json["dish_calories"] ?? null,
      dishCurrency: json["dish_currency"] ?? null,
      dishDescription: json["dish_description"] ?? null,
      dishId: json["dish_id"] ?? null,
      dishImage: json["dish_image"] ?? null,
      dishName: json["dish_name"] ?? null,
      dishPrice: json["dish_price"] * 21.25 ?? null,
      dishType: json["dish_Type"] ?? null,
      nexturl: json["nexturl"] ?? null);
}

class AddOnCategory {
  String? addonCategory;
  String? addonCategoryId;
  int? addonSelection;
  String? nexturl;
  List<AddOns>? addons;

  AddOnCategory(
      {required this.addonCategory,
      required this.addonCategoryId,
      required this.addonSelection,
      required this.addons,
      required this.nexturl});

  factory AddOnCategory.fromJson(String str) =>
      AddOnCategory.fromMap(jsonDecode(str));

  factory AddOnCategory.fromMap(Map<String, dynamic> json) => AddOnCategory(
      addonCategory: json["addon_category"] ?? null,
      addonCategoryId: json["addon_category_id"] ?? null,
      addonSelection: json["addon_selection"] ?? null,
      addons: json["addons"] == null
          ? null
          : List<AddOns>.from(json["addons"].map((x) => AddOns.fromMap(x))),
      nexturl: json["nexturl"] ?? null);
}

class AddOns {
  String? dishId;
  String? dishName;
  double? dishPrice;
  String? dishImage;
  String? dishCurrency;
  double? dishCalories;
  String? dishDescription;
  bool? dishAvailability;
  int? dishType;

  AddOns(
      {required this.dishAvailability,
      required this.dishCalories,
      required this.dishCurrency,
      required this.dishDescription,
      required this.dishId,
      required this.dishImage,
      required this.dishName,
      required this.dishPrice,
      required this.dishType});

  factory AddOns.fromJson(String str) => AddOns.fromMap(json.decode(str));

  factory AddOns.fromMap(Map<String, dynamic> json) => AddOns(
        dishAvailability: json["dish_Availability"] ?? null,
        dishCalories: json["dish_calories"] ?? null,
        dishCurrency: json["dish_currency"] ?? null,
        dishDescription: json["dish_description"] ?? null,
        dishId: json["dish_id"] ?? null,
        dishImage: json["dish_image"] ?? null,
        dishName: json["dish_name"] ?? null,
        dishPrice: json["dish_price"] ?? null,
        dishType: json["dish_Type"] ?? null,
      );
}
