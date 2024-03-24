import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_shop/model/Carts.dart';
import 'package:e_shop/model/Products.dart';
import 'package:e_shop/navigation_provider.dart';
import 'package:e_shop/screen/home.dart';
import 'package:e_shop/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetail extends StatefulWidget {
  final Products products;
  const ProductDetail({super.key, required this.products});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int quantity = 0;
  List<CartItem> productList = [];

  _saveList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jsonStringList =
        productList.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('productList', jsonStringList);
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

  @override
  void initState() {
    // TODO: implement initState
    _loadList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = widget.products.images!
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(item, fit: BoxFit.cover, width: 1000.0),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();
    return Scaffold(
      appBar: AppBarCustomWithBackButton(
        title: widget.products.title!,
        onPressed: () {
          context.read<NavigationModel>().pop();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: CarouselSlider(
                    options: CarouselOptions(
                        enableInfiniteScroll: false,
                        aspectRatio: 1 / 1,
                        scrollDirection: Axis.horizontal,
                        enlargeCenterPage: true,
                        pageSnapping: true),
                    items: imageSliders,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text(
                          widget.products.title!,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                        flex: 2,
                        child: Text(
                          "RM ${widget.products.price}",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
                Text(widget.products.description!),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomButton(
                  text: "Add to cart",
                  onPressed: () {
                    showFilter();
                  },
                  color: Colors.blue),
            )
          ],
        ),
      ),
    );
  }

  showFilter() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return DraggableScrollableSheet(
                expand: false,
                maxChildSize: 1.0,
                initialChildSize: 0.3,
                builder: (context, scrollController) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Image.network(
                                  widget.products.thumbnail!,
                                  width: 100,
                                  height: 100,
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.products.title!),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text("Quantity"),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                if (quantity > 0) {
                                                  quantity--;
                                                } else {}
                                              });
                                            },
                                            icon: Icon(
                                              Icons.remove,
                                              size: 20,
                                            )),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          quantity.toString(),
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                quantity++;
                                              });
                                            },
                                            icon: Icon(
                                              Icons.add,
                                              size: 20,
                                            )),
                                      ],
                                    )
                                  ],
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                            text: "Add to cart",
                            onPressed: () {
                              if (quantity > 0) {
                                productList.add(CartItem(
                                    title: widget.products.title!,
                                    price: widget.products.price!,
                                    quantity: quantity,
                                    image: widget.products.thumbnail!));
                                _saveList();
                                context.read<NavigationModel>().pushReplace(Home());
                              } else {
                                Shared.customToast(Colors.red,
                                    "Please add quantity to add to cart");
                              }
                            },
                            color: Colors.blue)
                      ],
                    ),
                  );
                });
          });
        });
  }
}
