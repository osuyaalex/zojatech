import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zojatech_assignment/class/cart_class.dart';

class CartProvider extends ChangeNotifier {
  final List<Cart> _list = [];
  List<String> _itemNames = [];
  List<Cart> get getItems {
    return _list;
  }
  List<String> get itemNames => _itemNames;
  int? get count {
    return _list.length;
  }

  double get totalPrice {
    var total = 0.00;

    for (var item in _list) {
      total += item.price * item.quantity;
    }
    return total;
  }

  Future<void> loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartJson = prefs.getStringList('cartItems');

    if (cartJson != null) {
      _list.clear();
      _list.addAll(cartJson.map((item) => Cart.fromJson(jsonDecode(item))));
      _updateItemNames();
      notifyListeners();
    }
  }

  void addItem(
      String name,
      String imageUrl,
      int quantity,
      dynamic price,
      ) {
    final existingCartIndex = _list.indexWhere((cart) => cart.name == name);

    if (existingCartIndex != -1) {
      final existingCart = _list[existingCartIndex];
      existingCart.quantity += quantity;
    } else {
      final cart = Cart(name, imageUrl, quantity, price);
      _list.add(cart);
    }
    _updateItemNames();
    _saveCart();
    notifyListeners();
  }

  void increment(Cart cart) {
    cart.increase();
    _updateItemNames();
    _saveCart();
    notifyListeners();
  }

  void decrement(Cart cart) {
    cart.decrease();
    _updateItemNames();
    _saveCart();
    notifyListeners();
  }

  void clearCart() {
    _list.clear();
    _saveCart(); // Save cart after clearing it
    notifyListeners();
  }

  Future<void> _saveCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartJson = _list.map((cart) => jsonEncode(cart.toJson())).toList();
    await prefs.setStringList('cartItems', cartJson);
  }

  void _updateItemNames() {
    _itemNames = _list.map((cart) => cart.name).toList();
  }
}
