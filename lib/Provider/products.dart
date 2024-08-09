import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zojatech_assignment/Provider/product_list.dart';

class ProductProvider extends ChangeNotifier {
  final List<Product> _list = [];
  List<Product> get getItems {
    return _list;
  }
  int? get count {
    return _list.length;
  }

  Future<void> loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedItems = prefs.getStringList('cartItems');

    if (savedItems != null) {
      _list.clear();
      _list.addAll(savedItems.map((item) => Product.fromJson(jsonDecode(item))));
      notifyListeners();
    }
  }

  Future<void> saveCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedItems = _list.map((item) => jsonEncode(item.toJson())).toList();

    await prefs.setStringList('cartItems', savedItems);
  }

  void addItem(
      String name,
      String imageUrl,
      String price,
      ) {
    final existingIndex = _list.indexWhere((item) => item.name == name);

    if (existingIndex != -1) {
      // Remove the existing item from its current position
      final existingItem = _list[existingIndex];
      _list.removeAt(existingIndex);

      // Move the existing item to the top of the list
      _list.insert(0, existingItem);
    } else {
      // Create a new item and add it to the top of the list
      final product = Product(
        name: name,
        imageUrl: imageUrl,
        price: price,

      );
      _list.insert(0, product);
    }

    notifyListeners();
    saveCart();
  }

  void clearCart() {
    _list.clear();
    notifyListeners();
    saveCart();
  }
}

