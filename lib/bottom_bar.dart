import 'package:e_shop/navigation_provider.dart';
import 'package:e_shop/screen/OrderList.dart';
import 'package:e_shop/screen/cart_list.dart';
import 'package:e_shop/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {


  final toast = FToast();

  @override
  void initState() {
    super.initState();
    toast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      fixedColor: Colors.grey[600],
      onTap: (int index) async {
        switch (index) {
          case 0:
            context.read<NavigationModel>().pushReplace(const Home());
            break;
          case 1:
            context.read<NavigationModel>().pushReplace(const CartList());
            break;
          case 2:
            context.read<NavigationModel>().pushReplace(const OrderList());
            break;
        }
      },
      items: [
        /* BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                  color: Color(0xff2143DB),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Center(
                child: Image.asset(
                  'assets/images/pickup.png',
                  height: 25,
                ),
              ),
            ),
          ),
          label: LocaleKeys.pickup.tr(),
        ),*/
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Container(
              height: 30,
              width: 30,

              child: Center(
                child: Icon(Icons.home, size: 25,)
              ),
            ),
          ),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Container(
              height: 30,
              width: 30,

              child: Center(
                child:  Icon(Icons.shopping_cart, size: 25,)
              ),
            ),
          ),
          label: "Cart",
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Container(
              height: 30,
              width: 30,

              child:Center(
                  child: Icon(Icons.format_list_bulleted, size: 25,)
              ),
            ),
          ),
          label: "Order",
        ),
      ],
      unselectedLabelStyle: TextStyle(
          fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[600]),
      selectedLabelStyle: TextStyle(
          fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[600]),
    );
  }
}
