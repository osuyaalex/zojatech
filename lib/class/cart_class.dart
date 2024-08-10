class Cart {
  String name;
  String imageUrl;
  int quantity;
  dynamic price;

  Cart(this.name, this.imageUrl, this.quantity, this.price);

  // Convert a Cart instance to a Map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'price': price,
    };
  }

  // Create a Cart instance from a Map
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      json['name'] ?? '',
      json['imageUrl'] ?? '',
      json['quantity'] ?? 0,
      json['price'], // `price` is dynamic, so it will take whatever type it was serialized as
    );
  }

  void increase() {
    quantity++;
  }

  void decrease() {
    if (quantity > 0) {
      quantity--;
    }
  }
}
