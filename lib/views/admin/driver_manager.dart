import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'customAppBar.dart';

class DriverManager extends StatelessWidget {
  const DriverManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Driver Manager',
        subtitle: 'Manage all driver',
      ),
      body: Center(child: Text('Profile Tab')),
    );
  }
}