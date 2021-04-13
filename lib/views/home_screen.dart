import 'package:flutter/material.dart';

import 'body.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Employee Crud'),
        ),
        body: Body(),
      ),
    );
  }
}
