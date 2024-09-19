import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'customAppBar.dart';

class DriverManagerTab extends StatelessWidget {
  const DriverManagerTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Driver Manager',
        subtitle: 'Manage your drivers',
      ),
      body: Center(child: Text('Driver Manager Tab')),
    );
  }
}