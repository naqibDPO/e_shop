import 'dart:convert';

import 'package:e_shop/model/Products.dart';
import 'package:e_shop/screen/login.dart';
import 'package:e_shop/widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ApiService{
  final toast = FToast();

  Future<ProductsList> getProduct(BuildContext context) async {
    toast.init(context);
    var url = Uri.parse('${Shared.url}/products');
    final headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.get(
      url,
    );
    if (response.statusCode == 200) {
      print("success product list");
      return ProductsList.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const Login()),
        ModalRoute.withName('/home'),
      );
    } else if (response.statusCode == 400) {
      toast.showToast(
        child: Shared.customToast(Colors.red, response.body.toString()),
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      toast.showToast(
        child: Shared.customToast(
            Colors.red, "Something went wrong, please try again later"),
        gravity: ToastGravity.BOTTOM,
      );
    }
    return ProductsList();
  }

}