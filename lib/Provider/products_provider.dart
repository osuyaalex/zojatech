import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zojatech_assignment/class/product_class.dart';

class ProductProvider extends ChangeNotifier {
  final List<Product> _list = [];
  List<Product> get getItems {
    return _list;
  }
  int? get count {
    return _list.length;
  }

  Future<void> loadProduct() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedItems = prefs.getStringList('cartItems');

    if (savedItems != null) {
      _list.clear();
      _list.addAll(savedItems.map((item) => Product.fromJson(jsonDecode(item))));
      notifyListeners();
    }
  }

  Future<void> saveProduct() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedItems = _list.map((item) => jsonEncode(item.toJson())).toList();

    await prefs.setStringList('cartItems', savedItems);
  }

  void addItem(
      String name,
      String imageUrl,
      String price,
      String description,
      String genre,
      ) {
    final existingIndex = _list.indexWhere((item) => item.title == name);

    if (existingIndex != -1) {
      // Remove the existing item from its current position
      final existingItem = _list[existingIndex];
      _list.removeAt(existingIndex);

      // Move the existing item to the top of the list
      _list.insert(0, existingItem);
    } else {
      // Create a new item and add it to the top of the list
      final product = Product(
        title: name,
        imagePath: imageUrl,
        price: price,
        description: description,
        genre: genre

      );
      _list.insert(0, product);
    }

    notifyListeners();
    saveProduct();
  }

  void clearCart() {
    _list.clear();
    notifyListeners();
    saveProduct();
  }
}

