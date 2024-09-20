import 'package:esavior_techwiz/models/account.dart';
import 'package:flutter/material.dart';

class DriverPage extends StatefulWidget {
  final Account account;
  const DriverPage({super.key, required this.account});

  @override
  State<DriverPage> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
