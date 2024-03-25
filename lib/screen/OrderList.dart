import 'dart:convert';
import 'package:e_shop/bottom_bar.dart';
import 'package:e_shop/navigation_provider.dart';
import 'package:e_shop/screen/OrderDetails.dart';
import 'package:e_shop/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/Carts.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  List<Order> orderList = [];

  _loadOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Retrieve the JSON string stored in shared preferences
      var jsonStringList = prefs.getStringList('orders');
      if (jsonStringList != null) {
        // Convert the JSON strings back to Item objects
        orderList = jsonStringList
            .map((itemJson) => Order.fromJson(jsonDecode(itemJson)))
            .toList();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _loadOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: "Order",
      ),
      body: orderList.isEmpty
          ? Center(
              child: Text("No order added from cart list"),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                    children: List.generate(orderList.length, (index) {
                  return InkWell(
                    onTap: () {
                      context
                          .read<NavigationModel>()
                          .pushToPage(OrderDetails(order: orderList[index]));
                    },
                    child: ListTile(
                      title: Text(orderList[index].getCartProductTitles()),
                      trailing: Column(
                        children: [
                          Text(
                            "RM ${priceCalculator(orderList[index].cartProducts)}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            orderList[index].deliveryDate,
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  );
                })),
              ),
            ),
      bottomNavigationBar: BottomBar(),
    );
  }

  String priceCalculator(List<CartItem> list) {
    int total = 0;
    for (int i = 0; i < list.length; i++) {
      int totalQuantity = list[i].price * list[i].quantity;
      total = total + totalQuantity;
    }
    return total.toString();
  }
}
