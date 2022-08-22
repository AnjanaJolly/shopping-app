import 'package:flutter/material.dart';

class Cart {
  late final String? id;
  final String? productId;
  final String? productName;
  final double? initialPrice;
  final double? productPrice;
  int? quantity;
  final double? calories;
  final String? image;

  Cart(
      {required this.id,
      required this.productId,
      required this.productName,
      required this.initialPrice,
      required this.productPrice,
      required this.quantity,
      required this.calories,
      required this.image});

  Cart.fromMap(Map<dynamic, dynamic> data)
      : id = data['id'],
        productId = data['productId'],
        productName = data['productName'],
        initialPrice = data['initialPrice'],
        productPrice = data['productPrice'],
        quantity = data['quantity'],
        calories = data['calories'],
        image = data['image'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'initialPrice': initialPrice,
      'productPrice': productPrice,
      'quantity': quantity,
      'calories': calories,
      'image': image,
    };
  }

  Map<String, dynamic> quantityMap() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }
}
