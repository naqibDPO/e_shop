import 'package:e_shop/api_service.dart';
import 'package:e_shop/navigation_provider.dart';
import 'package:e_shop/screen/product_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../bottom_bar.dart';
import '../model/Products.dart';
import '../widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<ProductsList> getProductList() async {
    final ProductsList data = await ApiService().getProduct(context);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomBar(),
      appBar: const AppBarCustom(title: 'eShop'),
      body: FutureBuilder<ProductsList>(
        future: getProductList(),
        builder: (context, AsyncSnapshot<ProductsList> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
                strokeWidth: 4.0,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData ||
              snapshot.data!.products!.isEmpty) {
            return Center(
              child: Text('No data available.'),
            );
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: (1 / 1.5),
                crossAxisCount: 2, // number of items in each row
                mainAxisSpacing: 8.0, // spacing between rows
                crossAxisSpacing: 8.0, // spacing between columns
              ),
              padding: EdgeInsets.all(8.0), // padding around the grid
              itemCount: snapshot.data!.products!.length, // total number of items
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: (){
                    context.read<NavigationModel>().pushToPage(ProductDetail(products: snapshot.data!.products![index]));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    height: 200,
                    width: 160,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Image.network(
                            snapshot.data!.products![index].thumbnail!,
                            height: 100,
                            width: 160,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(snapshot
                                    .data!.products![index].title!),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                    "RM ${snapshot.data!.products![index].price!}"),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Text(snapshot.data!.products![index].description!),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );

  }
}
