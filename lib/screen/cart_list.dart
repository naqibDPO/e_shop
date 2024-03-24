import 'dart:convert';

import 'package:e_shop/bottom_bar.dart';
import 'package:e_shop/model/Carts.dart';
import 'package:e_shop/navigation_provider.dart';
import 'package:e_shop/screen/address.dart';
import 'package:e_shop/screen/home.dart';
import 'package:e_shop/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartList extends StatefulWidget {
  const CartList({super.key});

  @override
  State<CartList> createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  List<CartItem> productList = [];
  List<String> addressList = [];
  String? selectedAddress;
  List<Order> orders = [];

  _loadAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      addressList = prefs.getStringList('addressList') ?? [];
    });
  }

  _loadSelectedAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
     selectedAddress = prefs.getString('selectedAddress');
    });
  }

  _loadList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Retrieve the JSON string stored in shared preferences
      var jsonStringList = prefs.getStringList('productList');
      if (jsonStringList != null) {
        // Convert the JSON strings back to Item objects
        productList = jsonStringList
            .map((itemJson) => CartItem.fromJson(jsonDecode(itemJson)))
            .toList();
      }
    });
  }

  _saveOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jsonStringList =
    orders.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('orders', jsonStringList);
    prefs.remove("productList");
  }
  _loadOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Retrieve the JSON string stored in shared preferences
      var jsonStringList = prefs.getStringList('orders');
      if (jsonStringList != null) {
        // Convert the JSON strings back to Item objects
        orders = jsonStringList
            .map((itemJson) => Order.fromJson(jsonDecode(itemJson)))
            .toList();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _loadList();
    _loadAddress();
    _loadSelectedAddress();
    _loadOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomBar(),
        appBar: AppBarCustom(
          title: 'Cart',
        ),
        body: productList.isEmpty
            ? Center(
                child: Text("No orders yet, please add order into cart"),
              )
            : Stack(
              children: [
                SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: List.generate(productList.length, (index) {
                              return ListTile(
                                title: Text(productList[index].title),
                                subtitle: Text(
                                    "Quantity: ${productList[index].quantity}"),
                                leading: Image.network(
                                  productList[index].image,
                                  width: 80,
                                  height: 100,
                                ),
                                trailing: Text(
                                  "RM ${priceCalculator(productList[index].price, productList[index].quantity)}",
                                  style: TextStyle(fontSize: 15),
                                ),
                              );
                            }),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Address",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          selectedAddress == null
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        flex: 6,
                                        child: Text(
                                            "You dont have any address selected, please select one address")),
                                    Expanded(
                                        flex: 2,
                                        child: IconButton(
                                            onPressed: () {
                                              context
                                                  .read<NavigationModel>()
                                                  .pushToPage(Address());
                                            },
                                            icon: Icon(Icons.arrow_forward)))
                                  ],
                                )
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  flex: 6,
                                  child: Text(
                                      selectedAddress!, style: TextStyle(fontSize: 20),)
                              ),
                              Expanded(
                                  flex: 2,
                                  child: IconButton(
                                      onPressed: () {
                                        context
                                            .read<NavigationModel>()
                                            .pushToPage(Address());
                                      },
                                      icon: Icon(Icons.arrow_forward)))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomButton(
                        text: "Confirm Order",
                        onPressed: () {
                          DateTime now = DateTime.now();
                          String formattedDate = DateFormat('yyyy-MM-dd').format(now);
                          String formattedTime = DateFormat('HH:mm').format(now);
                          orders.add(Order(deliveryAddress: selectedAddress!, deliveryTime: formattedTime, deliveryDate: formattedDate, cartProducts: productList));
                          _saveOrder();
                          context.read<NavigationModel>().pushReplace(Home());


                        },
                        color: Colors.blue),
                  ),
                )
              ],
            ));
  }

  String priceCalculator(int price, int quantity) {
    int result = price * quantity;
    return result.toString();
  }
}
