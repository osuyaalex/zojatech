import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {

  Future<void> addSampleProducts() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      final products = [
        {
          'name': 'Product 1',
          'description': 'High-quality electronic gadget',
          'price': 29.99,
          'category': 'Electronics',
          'stock': 100,
          'imageUrl': 'https://example.com/product1.jpg',
        },
        {
          'name': 'Product 2',
          'description': 'Comfortable and stylish chair',
          'price': 49.99,
          'category': 'Furniture',
          'stock': 50,
          'imageUrl': 'https://example.com/product2.jpg',
        },
        {
          'name': 'Product 3',
          'description': 'Durable backpack for travel',
          'price': 89.99,
          'category': 'Travel',
          'stock': 30,
          'imageUrl': 'https://example.com/product3.jpg',
        },
        {
          'name': 'Product 4',
          'description': 'Smartphone with the latest features',
          'price': 699.99,
          'category': 'Electronics',
          'stock': 200,
          'imageUrl': 'https://example.com/product4.jpg',
        },
        {
          'name': 'Product 5',
          'description': 'High-definition headphones',
          'price': 119.99,
          'category': 'Electronics',
          'stock': 75,
          'imageUrl': 'https://example.com/product5.jpg',
        },
        {
          'name': 'Product 6',
          'description': 'Organic cotton t-shirt',
          'price': 25.99,
          'category': 'Clothing',
          'stock': 150,
          'imageUrl': 'https://example.com/product6.jpg',
        },
        {
          'name': 'Product 7',
          'description': 'Stylish wristwatch with leather strap',
          'price': 199.99,
          'category': 'Accessories',
          'stock': 60,
          'imageUrl': 'https://example.com/product7.jpg',
        },
        {
          'name': 'Product 8',
          'description': 'Comfortable running shoes',
          'price': 89.99,
          'category': 'Footwear',
          'stock': 100,
          'imageUrl': 'https://example.com/product8.jpg',
        },
        {
          'name': 'Product 9',
          'description': 'Portable Bluetooth speaker',
          'price': 59.99,
          'category': 'Electronics',
          'stock': 80,
          'imageUrl': 'https://example.com/product9.jpg',
        },
        {
          'name': 'Product 10',
          'description': 'Luxury leather wallet',
          'price': 149.99,
          'category': 'Accessories',
          'stock': 40,
          'imageUrl': 'https://example.com/product10.jpg',
        },
      ];

      for (var i = 0; i < products.length; i++) {
        await _firestore.collection('Products').doc('product${i + 1}').set(products[i]);
      }

      print('Sample products added successfully.');
    } catch (e) {
      print('Error adding products: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: addSampleProducts,
            child: Text('data')
        ),
      ),
    );
  }
}
