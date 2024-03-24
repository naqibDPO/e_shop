import 'package:e_shop/screen/home.dart';
import 'package:e_shop/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../navigation_provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(title: 'Login'),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 6,
            ),
            const Text(
              "Login",
              style: TextStyle(fontSize: 30),
            ),
            Container(
              height: 30,
            ),
            CustomTextField(controller: username, labelText: "Username"),
            Container(
              height: 15,
            ),
            CustomTextField(controller: password, labelText: "Password"),
            Container(
              height: 30,
            ),
            CustomButton(text: "Submit", onPressed: () {
              context.read<NavigationModel>().pushToPage(Home());
            }, color: Colors.blue)
          ],
        ),
      ),
    );
  }
}
