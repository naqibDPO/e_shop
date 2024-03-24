import 'package:e_shop/model/Carts.dart';
import 'package:e_shop/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../navigation_provider.dart';

class OrderDetails extends StatefulWidget {
  final Order order;
  const OrderDetails({super.key, required this.order});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustomWithBackButton(title: "Order Detail", onPressed: (){context.read<NavigationModel>().pop();},),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Date", style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(widget.order.deliveryDate)
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Time", style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(widget.order.deliveryTime)
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(thickness: 1,),
              SizedBox(
                height: 10,
              ),
              Text("Delivery Address", style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(
                height: 10,
              ),
              Text(widget.order.deliveryAddress,),
              Divider(thickness: 1,),
              Column(
                children:
                List.generate(widget.order.cartProducts.length, (index) {
                  return ListTile(
                    title: Text(widget.order.cartProducts[index].title),
                    subtitle: Text(
                        "Quantity: ${widget.order.cartProducts[index].quantity}"),
                    leading: Image.network(
                      widget.order.cartProducts[index].image,
                      width: 80,
                      height: 100,
                    ),
                    trailing: Text(
                      "RM ${priceCalculator(widget.order.cartProducts[index].price, widget.order.cartProducts[index].quantity)}",
                      style: TextStyle(fontSize: 15),
                    ),
                  );
                })

              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Order Total", style: TextStyle(fontWeight: FontWeight.bold),),
                  Text("RM ${totalPriceCalculator(widget.order.cartProducts)}")
                ],
              ),

              
            ],
          ),
        ),
      ),
    );
  }
  String priceCalculator(int price, int quantity) {
    int result = price * quantity;
    return result.toString();
  }
  String totalPriceCalculator(List<CartItem> list) {
    int total = 0;
    for (int i = 0; i < list.length; i++) {
      int totalQuantity = list[i].price * list[i].quantity;
      total = total + totalQuantity;
    }
    return total.toString();
  }
}
