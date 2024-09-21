

import 'package:esavior_techwiz/models/account.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  final Account account;
  const Notifications({super.key, required this.account});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('notification'),
      )
    );
  }
}
