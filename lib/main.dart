import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'controllers/db_helper.dart';
import 'views/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DBHelper(),
      child: MaterialApp(
        title: 'Crud App',
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
