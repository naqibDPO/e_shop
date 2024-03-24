import 'dart:convert';

import 'package:e_shop/navigation_provider.dart';
import 'package:e_shop/screen/home.dart';
import 'package:e_shop/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController postcode = TextEditingController();
  TextEditingController state = TextEditingController();

  List<String> addressList = [];

  _loadList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      addressList = prefs.getStringList('addressList') ?? [];
    });
  }

  // Save the list to shared preferences
  _saveList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('addressList', addressList);
  }

  @override
  void initState() {
    // TODO: implement initState
    _loadList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustomWithBackButton(title: '', onPressed: () { 
        context.read<NavigationModel>().pop();
      },),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text("Address"),
            SizedBox(
              height: 5,
            ),
            CustomTextField(controller: address, labelText: "Address"),
            SizedBox(
              height: 10,
            ),
            Text("City"),
            SizedBox(
              height: 5,
            ),
            CustomTextField(controller: city, labelText: "City"),
            SizedBox(
              height: 10,
            ),
            Text("Postcode"),
            SizedBox(
              height: 5,
            ),
            CustomTextField(controller: postcode, labelText: "Postcode"),
            SizedBox(
              height: 10,
            ),
            Text("State"),
            SizedBox(
              height: 5,
            ),
            CustomTextField(controller: state, labelText: "State"),
            SizedBox(
              height: 15,
            ),
            CustomButton(text: "Submit", onPressed: (){
             addressList.add("${address.text}, ${city.text}, ${postcode.text}, ${state.text}");
             _saveList();
             context.read<NavigationModel>().pushReplace(Home());
            }, color: Colors.blue)
          ],
        ),
      ),
    );
  }
}
