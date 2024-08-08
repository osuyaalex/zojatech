import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import '../utilities/snackbar.dart';
import 'json/product_json.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

class ProductServices {
  Future<Products> products(
      BuildContext context) async {
    const url = "https://api.naijacp.com/api/general/games";
    var jsonResponse;

    try {
      final response = await _getRequest(url, context);
      jsonResponse = response;
    } catch (error) {
      _handleError(error, context);
    }

    return Products.fromJson(jsonResponse);
  }
}

Future<Map<String, dynamic>> _getRequest(String url, BuildContext context) async {
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data, status code: ${response.statusCode}');
    }
  } catch (error) {
    _handleError(error, context);
    throw error; // Rethrow the error to be handled by the caller if needed
  }
}

void _handleError(Object error, BuildContext context) {
  String errorMessage = error.toString();
  if (errorMessage.contains('Failed host lookup')) {
    EasyLoading.dismiss();
    snack(context, "Connection is down currently");
  } else if (errorMessage.contains('DOCTYPE HTML') ||
      errorMessage.contains('Connection reset by peer') ||
      errorMessage.contains('roken')) {
    EasyLoading.dismiss();
    snack(context, "Something went wrong");
  } else {
    snack(context, errorMessage);
  }
}
