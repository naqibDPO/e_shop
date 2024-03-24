import 'package:e_shop/navigation_provider.dart';
import 'package:e_shop/screen/add_address.dart';
import 'package:e_shop/screen/cart_list.dart';
import 'package:e_shop/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Address extends StatefulWidget {
  const Address({Key? key}) : super(key: key);

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  List<String> addressList = [];
  String? selectedAddress;


  _loadList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      addressList = prefs.getStringList('addressList') ?? [];
    });
  }

  // Save the list to shared preferences
  _saveAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedAddress', selectedAddress!);
  }

  @override
  void initState() {
    super.initState();
    _loadList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustomWithBackButton(
        title: "Address",
        onPressed: () {
          context.read<NavigationModel>().pop();
        },
      ),
      body: addressList.isEmpty
          ? Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Text("No address added, please add one"),
            CustomButton(
                text: "Add Address",
                onPressed: () {
                  context
                      .read<NavigationModel>()
                      .pushToPage(AddAddress());
                },
                color: Colors.blue)
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Column(
              children: List.generate(addressList.length, (index) {
                return CheckboxListTile(
                  title: Text(addressList[index]),
                  value: selectedAddress == addressList[index],
                  onChanged: (newValue) {
                    setState(() {
                      selectedAddress =
                      newValue! ? addressList[index] : null;
                    });
                  },
                  controlAffinity:
                  ListTileControlAffinity.leading, // leading Checkbox
                );
              }),
            ),
            SizedBox(
              height: 10,
            ),
            CustomButton(
                text: "Add Address",
                onPressed: () {
                  context
                      .read<NavigationModel>()
                      .pushToPage(AddAddress());
                },
                color: Colors.blue),
            SizedBox(
              height: 10,
            ),
            CustomButton(
                text: "Select Address",
                onPressed: () {
                  if (selectedAddress != null) {
                    _saveAddress();
                    context.read<NavigationModel>().pushReplace(CartList());
                  } else {
                    // Prompt the user to select an address
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Error"),
                        content: Text("Please select an address."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("OK"),
                          ),
                        ],
                      ),
                    );
                  }
                },
                color: Colors.blue)
          ],
        ),
      ),
    );
  }
}
