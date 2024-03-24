import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

// Define a navigation model to handle navigation-related state and methods
class NavigationModel extends ChangeNotifier {


  void pushToPage(Widget page) {
    navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => page));
  }

  void pushReplace(Widget page) {
    navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => page),
            (route) => false
    );
  }

  void pop() {
    navigatorKey.currentState?.pop();
  }
}



