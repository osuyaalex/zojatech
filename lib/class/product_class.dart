class Product {
  final String title;
  final String imagePath;
  final String price;
  final String description;
  final String genre;

  Product({
    required this.title,
    required this.imagePath,
    required this.price,
    required this.description,
    required this.genre
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['name'],
      imagePath: json['imageUrl'],
      price: json['price'],
      description: json['description'],
      genre: json['genre']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': title,
      'imageUrl': imagePath,
      'price': price,
      'description': description,
      "genre": genre
    };
  }
}
